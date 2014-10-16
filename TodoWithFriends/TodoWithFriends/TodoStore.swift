//
//  TodoStore.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/25/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class TodoStore {
    var currentUser:User;
    var todoItems: [TodoItem];
    
    init()
    {
        currentUser = User();
        todoItems = [TodoItem]();
    }
}