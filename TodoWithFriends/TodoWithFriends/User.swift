//
//  User.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/25/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class User {
    var id:String = "";
    var name:String = "";
    var profileImage: String? = "";
    var profileImageData: NSData = NSData();
    
    class func UserToDictionary(user:User) -> NSDictionary
    {
        var dictionary = [NSObject:AnyObject]();
        dictionary["name"] = user.name;
        //dictionary["profileImage"] = user.profileImage;
        return dictionary;
    }
    
    class func DictionaryToUser(dictionary:NSDictionary) -> User
    {
        var user = User();
        user.id = dictionary["id"] as String;
        user.name = dictionary["name"] as String;
        //user.profileImage = dictionary["profileImage"] as? String;
        
        if(user.profileImage != nil)
        {
            user.profileImageData = NSData(base64EncodedString: user.profileImage!, options: NSDataBase64DecodingOptions(0))!;
        }
        return user;
    }
}