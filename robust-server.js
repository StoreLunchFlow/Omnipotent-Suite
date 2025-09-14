// ROBUST SERVER WITH PORT FALLBACK MECHANISM
const http = require('http');

const PORT_OPTIONS = [3000, 8080, 8081, 3001, 9090];
let currentPort = null;

function startServer(portIndex = 0) {
    const port = PORT_OPTIONS[portIndex];
    
    const server = http.createServer((req, res) => {
        // Handle all requests with JSON responses
        res.setHeader('Content-Type', 'application/json');
        
        if (req.url === '/api/health') {
            res.end(JSON.stringify({
                status: 'OPERATIONAL',
                message: 'Omnipotent-Suite Server Running',
                port: port,
                version: '1.0.0'
            }));
            return;
        }
        
        if (req.url === '/api/premium/content') {
            res.end(JSON.stringify({
                title: 'Premium Content Active',
                content: 'This is working premium content',
                tier: 'architect'
            }));
            return;
        }
        
        res.end(JSON.stringify({
            error: 'Endpoint not found',
            available_endpoints: ['/api/health', '/api/premium/content']
        }));
    });

    server.listen(port, 'localhost', () => {
        currentPort = port;
        console.log('🎉 SERVER SUCCESSFULLY STARTED');
        console.log('📍 Port:', port);
        console.log('🌐 Health Check: http://localhost:' + port + '/api/health');
        console.log('💎 Premium Content: http://localhost:' + port + '/api/premium/content');
    });

    server.on('error', (error) => {
        if (error.code === 'EADDRINUSE') {
            console.log('⚠️  Port', port, 'is busy, trying next port...');
            if (portIndex < PORT_OPTIONS.length - 1) {
                startServer(portIndex + 1);
            } else {
                console.log('❌ All ports are busy. Please free up a port.');
                process.exit(1);
            }
        } else {
            console.log('🚨 Server error:', error.message);
            process.exit(1);
        }
    });
}

// Start the server with port fallback
console.log('🚀 Starting Omnipotent-Suite Server...');
console.log('🔄 Trying ports:', PORT_OPTIONS.join(', '));
startServer();
