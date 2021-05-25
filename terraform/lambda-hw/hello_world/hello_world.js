const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10'});
 
exports.handler = (event, context, callback) => {
    console.log(event);
    dynamodb.putItem({
        TableName: process.env.TABLE_NAME,
        Item: {
            "requestId": {
                S: event.requestContext.requestId
            },
            "requestTime": {
                S: event.requestContext.requestTime
            }
        }
    }, function(err, data) {
        if (err) {
            console.log(err, err.stack);
            callback(null, {
                statusCode: '500',
                body: err
            });
        } else {
            callback(null, {
                statusCode: '200',
                headers: {"content-type": "text/plain"},
                body: 'Hello, your request has been saved for Sandbox ID ' + process.env.SANDBOX_ID + '. Request ID is ' + event.requestContext.requestId
            });
        }
    })
};