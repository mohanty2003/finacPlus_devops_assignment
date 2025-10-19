# SRE CI/CD Assignment

This is my submission for the SRE intern assignment. I've created a CI/CD pipeline using Jenkins to deploy a Node.js app to Kubernetes.

## What I Built

- Simple Node.js web application 
- Docker container for the app
- Jenkins pipeline for CI/CD
- Kubernetes deployment manifests
- Scripts to build and deploy

## Project Structure
```
sre-ci-cd/
├── src/                    # node.js application
│   ├── index.js           # main app file
│   ├── package.json       # dependencies
│   └── test.js            # basic tests
├── k8s/                   # kubernetes manifests
│   ├── namespace.yaml     
│   ├── deployment.yaml    
│   ├── service.yaml       
│   ├── configmap.yaml     
│   ├── rbac.yaml          
│   └── secret.template.yaml
├── scripts/               # helper scripts
│   └── validate-project.sh
├── Dockerfile             # container build
├── Jenkinsfile           # CI/CD pipeline
├── build.sh              # build script
└── deploy.sh             # deploy script
```

## How to Use

### Prerequisites 
- Docker installed
- Kubernetes cluster (minikube is fine)
- Jenkins server
- kubectl configured

### Running Locally
```bash
# test the app
cd src/
npm install
npm test
npm start
```

### Build Docker Image
```bash
./build.sh
# or with custom params
./build.sh docker.io/myusername myapp v1.0
```

### Deploy to Kubernetes
```bash
./deploy.sh
# or with custom params  
./deploy.sh ~/.kube/config dev docker.io/myusername myapp v1.0
```

## Jenkins Pipeline

The Jenkinsfile has these stages:
1. Checkout - gets the code
2. Test - runs npm test
3. Build Docker Image - builds container
4. Push to Registry - pushes to docker hub
5. Deploy to K8s - deploys to kubernetes

### Jenkins Setup
1. Create a new pipeline job in Jenkins
2. Point it to this repository 
3. Add these credentials:
   - `docker-registry-cred` - your docker hub username/password
   - `kubeconfig-cred` - your kubeconfig file
4. Run the pipeline

## Application Details

The Node.js app is pretty simple:
- Express server on port 3000
- Health check endpoint at `/health`
- Basic test coverage
- Dockerfile for containerization

### Kubernetes Manifests

I've included all the k8s files needed:
- namespace.yaml - creates the dev namespace
- deployment.yaml - runs the app pods  
- service.yaml - exposes the app
- configmap.yaml - configuration data
- rbac.yaml - permissions
- secret.template.yaml - template for secrets

## What I Learned

This project helped me understand:
- How CI/CD pipelines work
- Docker containerization 
- Kubernetes deployments
- Jenkins configuration
- DevOps best practices

## Issues I Faced

- Had trouble with Jenkins credentials setup initially
- Kubernetes RBAC was confusing at first
- Docker build optimization took some time to figure out
- Testing in different environments was tricky

## Next Steps

If I had more time, I would add:
- Better monitoring and alerting
- More comprehensive tests
- Security scanning
- Multiple environments (staging, prod)
- GitOps with ArgoCD or Flux

## Validation

To check if everything is working:
```bash
./scripts/validate-project.sh
```

This will verify all files are present and the app loads correctly.

