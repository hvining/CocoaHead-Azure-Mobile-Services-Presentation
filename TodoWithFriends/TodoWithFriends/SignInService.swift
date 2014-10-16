//
//  SignInService.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/19/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class SignInService
{
    private var client:MSClient
    
    init(client:MSClient)
    {
        self.client = client;
    }
    
    func signIntoFacebook(viewController: UIViewController, completion: MSClientLoginBlock)
    {
        client.loginWithProvider("facebook", controller: viewController, animated: true, completion: completion);
    }
    
    func signIntoFacebookWithToken(token:[NSObject: AnyObject]!, completion:MSClientLoginBlock)
    {
        client.loginWithProvider("facebook", token: token, completion: completion);
    }
    
    func registerUserIfNeeded(completion:MSAPIBlock)
    {
        client.invokeAPI("signInUser", body: NSDictionary(), HTTPMethod: "POST", parameters: nil, headers: nil, completion: completion);
    }
}