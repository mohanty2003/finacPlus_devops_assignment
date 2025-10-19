# Dockerfile for node.js app
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY src/package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY src/ .

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s CMD node -e "require('http').get('http://localhost:3000/health', (res) => process.exit(res.statusCode === 200 ? 0 : 1))"

# Start the app
CMD ["node", "index.js"]
