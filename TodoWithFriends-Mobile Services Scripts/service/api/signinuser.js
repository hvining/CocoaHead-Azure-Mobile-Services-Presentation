exports.post = function(request, response) {
    var http = require('request');
    var serv = require('http');
    // Use "request.service" to access features of your mobile service, e.g.:
    //   var tables = request.service.tables;
    //   var push = request.service.push;
    var loginTokenURL;
    var loginToken;
    var oauth;
    console.log("User to register: " + JSON.stringify(request.user));
    var idComponents = request.user.userId.split(":");
    var userId = idComponents[1];
//var userQuery = "SELECT * FROM FactOrFiction.OAuthAccount WHERE IdentityProviderUserId = ? AND UserAccountId IS NOT NULL";
request.service.tables.getTable("User").where({id:userId}).read({success:function(users)
{
    if(users.length == 0)
        {
            console.log("New User logging in");
            //Get extended User Identites if user does not exist
            request.user.getIdentities({success: function(identities)
            {
                console.log("User's Identities: " + identities);
                if(identities === undefined)
                {
                    console.log("No Identity found");
                    response.send(404, "No Identity Information Found");
                }
                
                if(identities.facebook)
                {
                    loginToken = identities.facebook.accessToken;
                    loginTokenURL = 'https://graph.facebook.com/me?fields=id,name,birthday,hometown,email&access_token=';
                } 
                
                //Create true login token url
                loginTokenURL = loginTokenURL + loginToken;
                
                console.log("Login Token URL:" + loginTokenURL);
                
                var firstName, lastName, email, photoUri;
                var reqParams = { uri: loginTokenURL, headers: { Accept: 'application/json' } };
                if(oauth)
                {
                    reqParams.oauth = oauth;
                }
                
                http.get(reqParams, function (err, resp, body) {
                    var userData = JSON.parse(body);
                    console.log(userData);
                    console.log(JSON.stringify(request.service.user));
                    
                    if (identities.facebook)
                    {
                        var photoUrl = "https://graph.facebook.com/";
                        var photoParams = "?fields=picture.type(large)";
                        photoUrl = photoUrl + userData.id + photoParams;
                        
                        var facebookUser = { id:userId,
                                            name: userData.name,
                                            email: userData.email,
                                            //accessToken: userData.accessToken,
                                            //refreshToken: userData.refreshToken,
                                };
                                
                        //Write userdata into the user table
                        request.service.tables.getTable("User").insert(facebookUser, {success: function(users)
                        {
                            console.log(users);
                            //Return to the client the userdata from facebook
                            response.send(200, users);
                        }});
                        
                        /*
                        http.get(photoUrl, function(err1, resp1, body1)
                        {
                            console.log(err1);
                            if(body1 === undefined)
                            {
                                //Handle user does not exist error
                                    
                            }
                            
                            var photoData = JSON.parse(body1);
                            console.log("Image " + body1);
                            if(photoData === undefined) return;
                            
                            //Get user's profile picture
                            http.get({url:photoData.picture.data.url, encoding: null}, function(err2, resp2, body2)
                            {
                                var facebookImageData = body2.toString('base64');
                                
                                var facebookUser = { id:"",
                                                    name: userData.name,
                                                    email: email,
                                                    profileImage: facebookImageData,
                                                    accessToken: userData.accessToken,
                                                    refreshToken: userData.refreshToken,
                                };
                                
                                //Write userdata into the user table
                                request.tables.getTable("User").insert(facebookUser);
                                
                                //Return to the client the userdata from facebook
                                response.send(200, facebookUser);
                            });
                        });*/
                    }
                });
            }});
        } else
        {
            //Handle if user is in table check if user account associated,
            //if so then user is registered
            //if not user partically completed the registration process
            var user = users[0];
            console.log("User is in the system returning to the client: ", JSON.stringify(user));
            response.send(200, JSON.stringify(user));
            
            /*
            var user = request.service.tables.getTable("User");
            user.where({id:users[0].UserAccountId})
            .read({success: function(userAccounts)
            {
                if(userAccounts.length == 0) 
                {
                    response.send(404, "Could not find user account for registered user");
                    return;
                }
                
                var userAccount = userAccounts[0];
                response.send(200, JSON.stringify(userAccount));
            }})
            */
        }
}});
};