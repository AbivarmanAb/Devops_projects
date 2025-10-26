const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.json({
        version: 'v1.0',
        message: 'Welcome to Stable Version!',
        timestamp: new Date().toISOString(),
        pod: process.env.HOSTNAME
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy', version: 'v1.0' });
});

app.listen(port, '0.0.0.0', () => {
    console.log(`App v1.0 running on port ${port}`);
});
