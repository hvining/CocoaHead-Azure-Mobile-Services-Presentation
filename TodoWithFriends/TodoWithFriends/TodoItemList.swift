//
//  TodoItemList.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/19/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class TodoItemList {
    
    var id:String! = "";
    var userId:String! = "";
    var title:String = "";
    var todoItems = [TodoItem]();
    
    class func todoItemListToDictionary(todoItemList:TodoItemList) -> NSDictionary
    {
        var dictionary = [NSObject:AnyObject]();
        dictionary["id"] = todoItemList.id;
        dictionary["userId"] = todoItemList.userId;
        dictionary["title"] = todoItemList.title;
        return dictionary;
    }
    
    class func dictionaryToTodoItemList(dictionary:NSDictionary) -> TodoItemList
    {
        var todoItemList = TodoItemList();
        todoItemList.id = dictionary["id"] as String;
        todoItemList.userId = dictionary["userId"] as String;
        todoItemList.title = dictionary["title"] as String;
        todoItemList.todoItems = dictionary["todoItems"] as [TodoItem];
        return todoItemList;
    }
}
