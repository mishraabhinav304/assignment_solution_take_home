latest != tag
node:lates -> specific img tag or such -> 22.04.0
                                       -> 23.04.0

gitinore inside dockerignore : correct
dockerignore inside gitignore : wrong



pipeline flow
checkout -> build -> unit_test -> containerization -> vulnerability_scaning -> signing_image -> push_to_registy -> deploy_to_prod 

OIDC : OpenID Connect

Google login -> JWT -> Other provider -> access

OIDC Provider -> IAM Policy -> IAM Role -> Attatch that policy to the Role

Three security principles we need to remember:

1. Principle of Least Privilege
2. Shift Left Security
3. Configs are not secrets

488519936220.dkr.ecr.us-east-1.amazonaws.com/scaler-devsecops-app

provider_url : https://token.actions.githubusercontent.com
Audience : sts.amazonaws.com

arn : arn:aws:iam::488519936220:role/github-actions-role