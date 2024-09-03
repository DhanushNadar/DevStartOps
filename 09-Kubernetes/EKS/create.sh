#Make to install EKS CLI and configure it before running this script

# Create EKS Cluster
eksctl create cluster --name=my-cluster \
                      --region=us-west-2 \
                      --version=1.30 \
                      --without-nodegroup
#Make sure to replace the cluster name with the one you created 


# Associate IAM OIDC Provider
eksctl utils associate-iam-oidc-provider \
    --region us-west-2 \
    --cluster my-cluster \
    --approve
#Make sure to replace the cluster name with the one you created 


# Create Nodegroup
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
#Make sure to replace the cluster name with the one you created 



# Update Kubectl Context
aws eks update-kubeconfig --region us-west-2 --name my-cluster
#Make sure to replace the cluster name with the one you created 