exports.get = function(request, response) {
    response.send(statusCodes.OK, { message : 'You got yourself some cocoa beans' });
};