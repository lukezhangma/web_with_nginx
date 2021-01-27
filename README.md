 web_with_nginx
==========================================================================

This project contains two directories, such as:
`packer`,`terraform` 
+ These scripts don't contain Amazon account dependency. Assuming you have proper AWS credential configure in `.aws` directory and if using MFA. you have temporary token obtained. You can run these scripts against any Amazon accounts.

+ I assume that you have Pakcer, Terraform, Ansible properly installed. 

+ `packer` contains Packer scripts to build a customized Amazon Linux image with NGINX installed.
 Here are some hilights on bulding customized images:
 + I attached two EBS volume to the images, they are all encrypted volumes to ensure the data is encrypted at rest:
```ini
1) EBS based root volume where OS is intalled, encrypted.
2) EBS based secondary volume , expandable, encryted. 
```
 For the seconary volume, Later on when an instance is initiated for this image, I used 'userdata.sh' to mount /var/log to this volume. It can be expanded without stopping the instance.
  + I used `shell` provisioner and `ansible` provisioner to install nginx and to provision os.

+ `terraform` contains several modules of Terraform scripts.
+ `terrafrom/autoscaling` contain `terraform` scripts to create an autoscaling group, it uses launch configuration to launch NGINX web server from pre-built image, and use userdata.sh to further provision the instances.
It also creates autoscaling policy to control how to scaling up the group based on CPU usage and triger the alarms.
+ `terrafrom/loadbalancer` contain `terraform` scripts to create an application load balancer , it forward internet traffic on port 80 to target group of NGINX web server instances. It uses port 80 for health check.
+ `terrafrom/bastion` contains scripts to create a bastion host in public subnet. User will first `ssh` to this host then access to other server instances in private subnets. Amazon bastion image costs money to use, for demo purpose I use the same image as nginx web server for bastion. In real situation we would build our own bastion image.
+ `terrafrom/security_group` contains the scripts to create three security groups. 
1. One for load balancer to allow traffic on port 80. We could add port 443 for HTTPS traffic, but it requires certificate for that, so I just leave it for future expansion. For demo, only port 80 is open.
2. Second security group is for NGINX web servers, it allow traffic from load balancer on port 80. It also permit traffic from bastion host to it on port 22.
3. The third security groups is for bastion host, it allows traffic to it on port 22 from internet. 

+ `terraform/vpc` contains scripts that provision VPC and subnets, it creates a vpc with two public subnets and one private subnet. And it creates internet gateway and route table for communication to the internet.
+ `terrafrom/alarm` contains the scripts that create CloudWatch alarms on CPU usage of web servers.


Usage:
-------------

I assume that you have Pakcer, Terraform, Ansible properly installed. If you need to install them, please follow these links to install them. [Pakcer installation](https://learn.hashicorp.com/tutorials/packer/getting-started-install), [Terraform installtion](https://learn.hashicorp.com/tutorials/terraform/install-cli), [Ansible installtion](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

First step, go to `packer/nginx` directory, run follwing command to build customize AMI:
```sh
1. packer build nginx_image.json
```
Second step. Then you should get ami id from screen output or log in Amazon console EC2 management console to find out AMI id. Then you would edit terraform.tfvar and use this id as input parameter for terraform scripts.
Edit `terraform.tfvar` in `terraform` directory,  add this line:
```sh
nginx_ami_id = "<ami-id>"
```
*Before running `terraform` scripts, we need create a management S3 bucket as terraform backend. I give a example terraform script for creating S3 bucket. It is `s3.tf`. I run it seperatedly because this bucket lifecycle spans across the creating and destroying the NGINX cluster. So the backend bucket of 'luke-zhang-management' should be created before running terraform scripts. You could delete backend section to run without s3 backend.*

Assuming you have proper AWS credential configure in .aws directory and if using MFA. you have temporary token obtained. Go to `terraform` directory, run these commands:
```sh
1. terraform init
2. terraform apply
```

Explanation of Some Details
---------------------------

* When EBS volumes are provisioned, they are all encrypted for ensuring encryted data at rest. Which is done by Ansible provisioner.

* When the customized NGINX AMI image is created, I created a user `deploy` that is used for management of instance purpose. It is created with playbook  `playbook.yml` by ansible provisioner. Here is example code:
```ini
    - name: Add sudoers users to wheel group
      user: 
         name: deploy
         password: "{{ 'password' | password_hash('sha512') }}"
         groups: wheel
         shell: /bin/bash
         home: /srv/apps
```

* Following ausoscling policy should allow autoscaler add more server instances when load is high.
```ini
resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "web-cluster-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.sessionm_asg.name
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.tracking_policy_target_value
  }
}
```

* CloudWatch alarms are used for alerting the server load and autoscaling issues. Located in `terraform/alarm` directory.

* The secondary volume attached to the web server instances are EBS volumes that can be expaned in realtime. So the usage of volume by logs grow bigger, we could expend the storage without stopping the instance.
