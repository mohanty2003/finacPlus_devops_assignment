const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// Main route
app.get('/', (req, res) => {
  res.json({
    message: 'Hello from SRE CI/CD App!',
    status: 'running',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    uptime: process.uptime()
  });
});

// Simple API endpoint
app.get('/api/info', (req, res) => {
  res.json({
    app: 'SRE CI/CD Sample',
    description: 'Node.js app with Jenkins pipeline',
    hostname: require('os').hostname(),
    nodeVersion: process.version
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

module.exports = app;
