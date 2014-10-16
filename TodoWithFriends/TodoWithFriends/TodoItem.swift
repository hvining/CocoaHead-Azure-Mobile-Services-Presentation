//
//  TodoItem.swift
//  TodoWithFriends
//
//  Created by Howard Vining on 9/18/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

import Foundation

class TodoItem {
    var id:String! = "";
    var text:String! = "";
    var userId:String! = "";
    var completed:Bool = false;
    
    class func todoItemToDictionary(todoItem:TodoItem) -> NSDictionary
    {
        var dictionary = [NSObject:AnyObject]();
        dictionary["id"] = todoItem.id;
        dictionary["text"] = todoItem.text;
        dictionary["userId"] = todoItem.userId;
        dictionary["completed"] = NSNumber(bool: todoItem.completed);
        return dictionary;
    }
    
    class func dictionaryToTodoItem(dictionary:NSDictionary) -> TodoItem{
        var todoItem = TodoItem();
        todoItem.id = dictionary["id"] as String;
        todoItem.text = dictionary["text"] as String;
        todoItem.userId = dictionary["userId"] as String;
        todoItem.completed = dictionary["completed"] as Bool;
        return todoItem;
    }
}