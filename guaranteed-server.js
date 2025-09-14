// SUPER SIMPLE GUARANTEED SERVER
const http = require('http');
const port = 3000;

const server = http.createServer((req, res) => {
    console.log('Request received:', req.url);
    
    if (req.url === '/api/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'OK', message: 'I AM WORKING!' }));
        return;
    }
    
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello World!');
});

server.listen(port, 'localhost', () => {
    console.log('🚀 GUARANTEED SERVER RUNNING ON http://localhost:' + port);
    console.log('📍 Test with: curl http://localhost:3000/api/health');
});

server.on('error', (error) => {
    console.error('🚨 SERVER ERROR:', error.message);
    process.exit(1);
});
