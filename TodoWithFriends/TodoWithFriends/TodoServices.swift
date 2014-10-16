//
//  CCHWebServices.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/18/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class TodoServices {
    private var client:MSClient
    let todoTable:MSTable
    
    init(client:MSClient){
        self.client = client
        todoTable = client.tableWithName("TodoItem")
    }
    
    func fetchTodoItems(userId:String, completion:MSReadQueryBlock){
        let todoItemsPredicate = NSPredicate(format: "userId == %@ && complete == NO", userId);
        let query:MSQuery = todoTable.queryWithPredicate(todoItemsPredicate);
        query.readWithCompletion(completion);
    }
    
    func updateTodoItem(todoItem:TodoItem, completion:MSItemBlock){
        let dictionary = TodoItem.todoItemToDictionary(todoItem);
        todoTable.update(dictionary, completion: completion);
    }
    
    func deleteTodoItem(todoItem:TodoItem, completion:MSDeleteBlock){
        todoTable.deleteWithId(todoItem.id, completion: completion);
    }
}
