//
//  UserServices.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 10/8/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class UserService {
    private var client:MSClient?
    private let userTable:MSTable
    
    init(client:MSClient)
    {
        self.client = client;
        self.userTable = client.tableWithName("user")
    }
    
    func fetchAllUsers(userId: String, completion:MSReadQueryBlock)
    {
        let usersPredicate = NSPredicate(format: "id != %@", userId);
        let query:MSQuery = userTable.queryWithPredicate(usersPredicate);
        query.readWithCompletion(completion)
    }
}