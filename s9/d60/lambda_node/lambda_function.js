exports.handler = async (event, context) => {
    console.log('Event:', JSON.stringify(event,null,2));
    const response = {
        statusCode: 200,
        headers:{
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            message: '¡Hola desde Node.js Lambda!',
            input: event,
            timestamp: new Date().toISOString(),
            nodeVersion: process.version
        })
    };

    console.log('Response:',JSON.stringify(response,null,2));
    return response;
};