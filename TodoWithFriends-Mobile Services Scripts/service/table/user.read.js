function read(query, user, request) {

    console.log("looking for users for user :" + JSON.stringify(user) + " with query " + JSON.stringify(query));
    request.execute();

}