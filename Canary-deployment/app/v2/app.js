const express = require('express');
const app = express();
const port = 3000;

// Simulate new feature with potential performance characteristics
app.get('/', (req, res) => {
    // Simulate some processing time
    const processingTime = Math.random() * 100;
    
    res.json({
        version: 'v1.1',
        message: 'Welcome to Canary Version with New Features!',
        timestamp: new Date().toISOString(),
        pod: process.env.HOSTNAME,
        processingTime: `${processingTime.toFixed(2)}ms`,
        feature: 'Enhanced User Dashboard'
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'healthy', 
        version: 'v1.1',
        features: ['enhanced-dashboard', 'performance-optimizations']
    });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`App v1.1 running on port ${port}`);
});
