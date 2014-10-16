function insert(item, user, request) {

    request.execute();
    setTimeout(function() {
        push.apns.send(null, {
            alert: "Alert: " + item.text,
            payload: {
                inAppMessage: "Hey, listen: '" + item.text + "'"
            }
        });
    }, 2500);

}