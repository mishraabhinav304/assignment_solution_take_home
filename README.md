# Scaler DevSecOps Take-Home Assignment: Fix the Pipeline

Estimated time: 6 hours | AI tools: Allowed and encouraged |

---

## Context

You've just been assigned a DevSecOps challenge at Scaler. A Node.js web application has been set up with Docker and CI/CD infrastructure, but the team suspects there are security issues. You've been handed the files below and told:

"This works, but we suspect it's not secure. Please audit it."

The app is a simple Node.js web server. Your job isn't to change the app code, just fix the infrastructure around it.

**AI policy:** You are free and encouraged to use AI tools (ChatGPT, Claude, Copilot, etc.) anywhere in this assignment. We won't penalize you for using them. However, your explanations must be in your own words.

---

## Getting Started

1. Clone or fork this repository
2. Examine the Dockerfile and .github/workflows/deploy.yml files
3. Follow the tasks in order (1 through 6)
4. Document all issues you find and your fixes in SECURITY_AUDIT.md
5. Test your fixes locally before submitting
6. Create REFLECTION.md with your AI usage notes

The estimated time for each task is provided. You should complete all tasks and deliverables within 6 hours.

---

## File 1 - The Dockerfile

Note: Highlighted comments mark known issues. There may be additional issues that aren't marked.

```dockerfile
FROM node:latest                                         # Issue

WORKDIR /app

COPY . .                                                 # Issue

RUN npm install

ENV SECRET_KEY=s3cr3t_k3y_abc123                         # Issue

ENV DB_PASSWORD=admin123                                 # Issue

RUN apt-get update && apt-get install -y curl vim wget   # Issue

EXPOSE 3000

EXPOSE 22                                                # Issue

CMD ["node", "server.js"]
```

---

## File 2 - The CI/CD Pipeline

Note: Same as above - some issues are marked, others are not. The workflow is currently disabled and will not execute automatically when you push to main. Re-enabling the push trigger is part of Task 2.

```yaml
name: Build and Deploy

on:
  workflow_dispatch:

  # DISABLED: This workflow will not run automatically on push.
  # You must enable the push trigger below after implementing security fixes.
  # push:
  #   branches: [ main ]

env:
  DOCKER_HUB_PASSWORD: "p@ssw0rd_docker_123"            # Issue
  AWS_SECRET_ACCESS_KEY: "wJalrXUtnFEMI/K7MDENG/bPxRfiCY"  # Issue

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:

      - name: Checkout code
        uses: actions/checkout@v3                        # Issue

      - name: Build Docker image
        run: docker build -t myapp:latest .

      - name: Push to Docker Hub
        run: |
          echo "$DOCKER_HUB_PASSWORD" | docker login -u myuser --password-stdin
          docker push myapp:latest                       # Issue
```

---

## Tasks

### Task 1 - Audit and Fix the Dockerfile (approximately 1 hour)

Identify every security and quality issue. Produce a fixed Dockerfile and for each change, write 1-2 sentences explaining what the problem was and why your fix addresses it.

### Task 2 - Audit and Fix the CI/CD Pipeline (approximately 1 hour)

Same as Task 1 but for the GitHub Actions workflow. Identify all issues, produce a corrected deploy.yml, and explain each fix. Note: Re-enable the push trigger once you have addressed all security issues. The workflow is currently disabled to prevent accidental deployment of an insecure pipeline.

### Task 3 - Add a Vulnerability Scan (approximately 1 hour)

Add a container image vulnerability scan to the pipeline using Trivy (or a tool you prefer). The scan must:

- Run after the image is built
- Fail the pipeline if any CRITICAL severity CVEs are found
- Produce a report as a build artifact

In your docs, explain where you placed the scan step and why that position matters.

### Task 4 - Update the Pipeline with ECR, OIDC, and Image Signing (approximately 1.5 hours)

Replace the Docker Hub push with the following steps:

- Configure OIDC authentication to Amazon ECR using the ARN template provided below
- Push the image to ECR instead of Docker Hub
- Sign the image using cosign after pushing
- Ensure the Trivy scan runs before pushing

Document each step and explain the security benefits of OIDC authentication and image signing.

Use this template for your OIDC configuration:

```yaml
permissions:
  id-token: write

- name: Configure AWS credentials via OIDC
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::ACCOUNT_ID:role/github-actions-role
    aws-region: us-east-1
```

Replace `ACCOUNT_ID` with your actual AWS account ID. The IAM role must have permissions to push images to ECR.

### Task 5 - Answer the Decision Questions (approximately 45 minutes)

See the Decision Questions section below. These have no single right answer - we're looking at your reasoning process.

### Task 6 - Reflection (approximately 15 minutes)

Write a short paragraph (150-250 words): What did AI help you with? Where did you need to use your own judgment? Was there anything AI got wrong that you had to correct?

---

## Decision Questions

These questions have no single correct answer. We're evaluating how you reason through a problem, not whether you've memorized a fact.

**Q1 - Vulnerability management**

Your Trivy scan finds 3 CRITICAL CVEs in the base image. The CVEs are in OpenSSL. However, switching to a newer base image breaks one of your app's native modules. You can't fix it in the next 24 hours. What are your options and what would you actually do?

Hint: consider the difference between fixing, mitigating, and accepting risk, and how you'd communicate your decision.

---

**Q2 - Container security**

A colleague argues: "We use --privileged in Docker, but it's fine because this service is only ever accessed internally, never from the internet." How do you respond? Be specific about what the risk is, not just that it's bad.

---

**Q3 - Git history and secrets**

You've removed the hardcoded secrets from the YAML file and rotated the credentials. Your manager says "great, we're clean now." Is that true? If not, what else needs to happen and why?

Hint: Think about what git commits preserve, and for how long.

---

**Q4 - Trade-off reasoning**

You want to pin all GitHub Actions to commit SHAs for supply chain security. Your teammate says this makes updating dependencies a pain. What's a practical approach that gives you both security and maintainability?

---

## Tools and Prerequisites

For this assignment, you will need:

- Docker (for building and testing containers locally)
- Node.js and npm (for testing the application)
- Git (for version control)
- Trivy (for vulnerability scanning)
- Cosign (for image signing)
- AWS CLI (for ECR and OIDC configuration)

You can install most tools using your system package manager or follow official installation guides.

## Testing Your Work

Before submitting:

- Test the fixed Dockerfile by building the image locally
- Verify the Node.js application runs correctly
- Test the GitHub Actions workflow by triggering it manually or examining the syntax
- Run Trivy against your built image to validate the scanning step
- Document any test results in your SECURITY_AUDIT.md

---

## Deliverables

Submit a GitHub repository (public or invite us) or a zip file containing:

| File | Description |
|---|---|
| Dockerfile | Your fixed, production-ready Dockerfile |
| .github/workflows/deploy.yml | Your fixed and hardened pipeline with OIDC, ECR, cosign, and Trivy steps |
| SECURITY_AUDIT.md | Every issue you found, why it's a problem, how you fixed it, and your answers to the Decision Questions |
| REFLECTION.md | Your 150-250 word reflection on your AI usage (Task 6) |

Note: A clear, honest SECURITY_AUDIT.md beats perfect code with no explanation. We're evaluating your thinking, not polish.

---

## Evaluation Criteria

We're looking for:

- Security awareness: Understanding the why behind each fix, not just the what
- Completeness: All issues identified and addressed
- Documentation: Clear explanations of problems and solutions
- Reasoning: Thoughtful answers to decision questions that show tradeoff analysis
- Honesty: Transparent about AI usage and your own limitations

You will have a 30-minute follow-up call to discuss your work. Be prepared to explain:

- What issues you found and why they matter
- How your fixes address each issue
- Your reasoning for the decision questions
- What you learned during the assignment

---

## Submission

Send your completed assignment to ***REMOVED*** with:

- GitHub repository link (preferred) or zip file with all deliverables
- A note on time spent and any blockers encountered
- Your availability for the 30-minute follow-up call

Good luck!
