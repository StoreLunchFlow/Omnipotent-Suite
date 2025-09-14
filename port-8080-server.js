// SERVER ON PORT 8080 - AVOIDING POTENTIAL CONFLICTS
const http = require('http');
const port = 8080;

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ 
        status: 'SUCCESS', 
        message: 'Server is finally working!',
        port: port
    }));
});

server.listen(port, () => {
    console.log('🎉 SERVER SUCCESSFULLY STARTED ON PORT ' + port);
    console.log('🌐 Test: curl http://localhost:8080');
});
