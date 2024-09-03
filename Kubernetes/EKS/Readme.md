![Amazon EKS](header_1.png)

## Introduction

Welcome to the EKS section of the Kubernetes folder! 

Amazon Elastic Kubernetes Service (EKS) is a managed Kubernetes service that simplifies running Kubernetes on AWS without needing to install and operate your own Kubernetes control plane. EKS is widely used in production environments due to its scalability, security, and seamless integration with other AWS services.

## Why Use EKS in Production?

Imagine you're running a large e-commerce platform with millions of users worldwide. Your infrastructure needs to handle varying traffic loads, secure sensitive data, and maintain high availability at all times. Managing such an environment can be complex and resource-intensive, especially when dealing with Kubernetes clusters.

This is where Amazon EKS comes in. EKS takes the heavy lifting off your shoulders by managing the Kubernetes control plane, including the API servers and etcd database. With EKS, you can focus on deploying and scaling your applications, while AWS handles the underlying infrastructure.

## How to create EKS cluster using eksctl utility

## Pre-requisites:
- IAM user with **access keys and secret access keys**
- AWSCLI should be configured
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

- Install **kubectl**
```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

- Install **eksctl**
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

#
### Steps to create EKS cluster:
- Create EKS Cluster
```bash
eksctl create cluster --name=my-cluster \
                      --region=us-west-2 \
                      --version=1.30 \
                      --without-nodegroup
```

- Associate IAM OIDC Provider
```bash
eksctl utils associate-iam-oidc-provider \
    --region us-west-2 \
    --cluster my-cluster \
    --approve
```
#

- Create Nodegroup
```bash
eksctl create nodegroup --cluster=my-cluster \
                       --region=us-west-2 \
                       --name=my-cluster \
                       --node-type=t2.medium \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=2 \
                       --node-volume-size=29 \
                       --ssh-access \
                       --ssh-public-key=eks-nodegroup-key 
```
#### Note: Make sure the ssh-public-key "eks-nodegroup-key is available in your aws account"
#

- Update Kubectl Context
```bash
aws eks update-kubeconfig --region us-west-2 --name my-cluster
```
#

- Delete EKS Cluster
```bash
eksctl delete cluster --name=my-cluster --region=us-west-2
```