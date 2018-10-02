[![travis](https://travis-ci.org/heartysoft/docker-builder-aws.svg?branch=master)](https://travis-ci.org/heartysoft/docker-builder-aws)

# docker-builder-aws
A docker container based on alpine with aws cli, and docker installed. Use this to build containers, while using AWS services (e.g. push to ECR).

# containers

* **heartysoft/docker-builder-aws:[version]**  
python, aws-cli, scripts to configure assume role account, etc.
* **heartysoft/docker-builder-aws:[version]-node**  
as above, but with node and yarn installed. 
* **heartysoft/docker-builder-aws:[version]-helm**  
as heartysoft/docker-builder-aws:[version], but with helm and kubectl installed. 
* **heartysoft/docker-builder-aws:[version]-helm-terraform**
as heartysoft/docker-builder-aws:[version], but with helm, kubectl and terraform installed.

[https://hub.docker.com/r/heartysoft/docker-builder-aws/](https://hub.docker.com/r/heartysoft/docker-builder-aws/) 
