#!/bin/bash

# Simple validation script to check if all files are there

echo "Checking project files..."

# Check main files
files=(
    "src/package.json"
    "src/index.js"
    "src/test.js"
    "Dockerfile"
    "Jenkinsfile"
    "build.sh"
    "deploy.sh"
    "README.md"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✓ $file exists"
    else
        echo "✗ Missing: $file"
    fi
done

echo ""
echo "Checking k8s manifests..."
k8s_files=(
    "k8s/namespace.yaml"
    "k8s/deployment.yaml"
    "k8s/service.yaml"
    "k8s/configmap.yaml"
    "k8s/rbac.yaml" 
    "k8s/secret.template.yaml"
)

for file in "${k8s_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✓ $file exists"
    else
        echo "✗ Missing: $file"
    fi
done

echo ""
echo "Testing node app..."
cd src
npm install --silent
npm test

echo ""
echo "Validation complete!"
    "src/index.js"
    "src/test.js"
    "Dockerfile"
    "Jenkinsfile"
    "build.sh"
    "deploy.sh"
    "README.md"
)

for file in "${files_to_check[@]}"; do
    if [[ -f "$file" ]]; then
        print_status "File exists: $file"
    else
        echo "❌ Missing file: $file"
    fi
done

echo ""
echo -e "${BLUE}☸️  Kubernetes Manifests Validation${NC}"
echo "-------------------------------------"

k8s_files=(
    "k8s/namespace.yaml"
    "k8s/deployment.yaml"
    "k8s/service.yaml"
    "k8s/configmap.yaml"
    "k8s/rbac.yaml"
    "k8s/secret.template.yaml"
    "k8s/hpa.yaml"
)

for file in "${k8s_files[@]}"; do
    if [[ -f "$file" ]]; then
        print_status "K8s manifest exists: $file"
    else
        echo "❌ Missing K8s file: $file"
    fi
done

echo ""
echo -e "${BLUE}🧪 Application Testing${NC}"
echo "----------------------"

# Test Node.js application syntax
cd src/
if node -c index.js 2>/dev/null; then
    print_status "Node.js application syntax is valid"
else
    echo "❌ Node.js application has syntax errors"
fi

# Test npm configuration
if npm list --depth=0 &>/dev/null; then
    print_status "NPM dependencies are properly installed"
else
    echo "⚠️  NPM dependencies may need installation"
fi

# Go back to root
cd ..

echo ""
echo -e "${BLUE}🐳 Docker Configuration${NC}"
echo "----------------------------"

# Check if Docker is available
if command -v docker &> /dev/null; then
    print_status "Docker is available"
    
    # Check if our image exists
    if docker images | grep -q "mohanty2003/sre-ci-cd-sample"; then
        print_status "Docker image 'mohanty2003/sre-ci-cd-sample' exists"
        IMAGE_ID=$(docker images mohanty2003/sre-ci-cd-sample:v1 --format "{{.ID}}")
        print_info "Image ID: $IMAGE_ID"
    else
        echo "⚠️  Docker image not built yet. Run: ./build.sh"
    fi
else
    echo "❌ Docker is not available"
fi

echo ""
echo -e "${BLUE}⚙️  Scripts and Permissions${NC}"
echo "-----------------------------"

# Check script permissions
scripts=("build.sh" "deploy.sh" "scripts/test-deployment.sh")
for script in "${scripts[@]}"; do
    if [[ -x "$script" ]]; then
        print_status "Script is executable: $script"
    else
        echo "⚠️  Script not executable: $script (run: chmod +x $script)"
    fi
done

echo ""
echo -e "${BLUE}📋 Configuration Summary${NC}"
echo "-------------------------"

print_info "Docker Hub Username: mohanty2003"
print_info "Application Name: sre-ci-cd-sample"
print_info "Kubernetes Namespace: dev"
print_info "Application Port: 3000"

echo ""
echo -e "${BLUE}🚀 Next Steps${NC}"
echo "-------------"
echo "1. Ensure you have a Kubernetes cluster running"
echo "2. Configure Jenkins with the required credentials:"
echo "   - docker-registry-cred (Docker Hub credentials)"
echo "   - kubeconfig-cred (Kubernetes config file)"
echo "3. Update Jenkins pipeline parameters if needed"
echo "4. Run the Jenkins pipeline!"

echo ""
echo -e "${BLUE}🔧 Manual Testing Commands${NC}"
echo "----------------------------"
echo "# Test locally:"
echo "cd src && npm install && npm test && npm start"
echo ""
echo "# Build Docker image:"
echo "./build.sh docker.io/mohanty2003 sre-ci-cd-sample v1"
echo ""
echo "# Test Docker container:"
echo "docker run -p 3000:3000 docker.io/mohanty2003/sre-ci-cd-sample:v1"
echo ""
echo "# Deploy to Kubernetes (when cluster is available):"
echo "./deploy.sh ~/.kube/config dev docker.io/mohanty2003 sre-ci-cd-sample v1"

echo ""
print_status "Project validation completed! ✨"
