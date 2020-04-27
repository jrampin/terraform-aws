AWS EC2 and RDS - Terraform and Ansible
=========
This Terraform code will deploy:

* ec2 instance - Running Docker and a TO-DO App
* PostgreSQL instance - Used as a backend for the To-do App


Requirements
------------

* Terraform 0.12
* Ansible 2.9
* AWSCLI 
* Make sure you have your priv/pub key like ~/.ssh/id_rsa.pub - If your priv/pub key is different, you can change it on main.tf

Variables
--------------

All the variables can be found on variables.tf 


Example
----------------

Once you clone this repo:

    # Access the folder
    cd terraform-aws
    
    # Set Access and Security key
    aws configure
    
    # Initialize terraform - download plugins
    terraform init
    
    # Dry-run - it will show what is going to be deployed
    terraform plan
    
    # Deploy it
    terraform apply -auto-approve


Once it's finished, you should get an output similiar to this:
    
    Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

    Outputs:

    server_ip = ec2-52-70-13-161.compute-1.amazonaws.com

And you should be able to browser the server_ip url on port 80.

    http://ec2-52-70-13-161.compute-1.amazonaws.com

Improvements
----------------

* Remote state - move local state to a a s3 bucket and DynamoDB (make sure to enable Bucket Versioning on the S3 bucket to allow for state recovery in the case of accidental deletions and human error.)

* Implement secret vaults and remove plain/hard-coded passwords out of the files

* EKS

* Create modules
