// ----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// ----------------------------------------------------------------------------
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import UIKit

class ToDoTableViewController: UITableViewController, ToDoItemDelegate {
    
    var records = NSArray()
    var client = MSClient(applicationURLString: MobileServiceClientUrl, applicationKey: MobileServiceClientKey);
    var table : MSTable?
    var todoStore : TodoStore = TodoStore()
    var todoService: TodoServices!
    var signInService:SignInService!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.todoService = TodoServices(client: self.client)
        self.signInService = SignInService(client: self.client)
        
        self.table = client.tableWithName("TodoItem")!
        self.refreshControl?.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
//        self.refreshControl?.beginRefreshing()
//        self.onRefresh(self.refreshControl)
        self.signInService.signIntoFacebook(self, completion: {(user:MSUser!, error:NSError!) -> Void in
            self.signInService.registerUserIfNeeded({ (userData:AnyObject!, resp:NSHTTPURLResponse!, error:NSError!) -> Void in
                var dictionary = userData as NSDictionary;
                self.todoStore.currentUser = User.DictionaryToUser(dictionary);
                
                self.refreshControl?.beginRefreshing()
                self.onRefresh(self.refreshControl);
            });
        });
    }
    
    func onRefresh(sender: UIRefreshControl!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        todoService.fetchTodoItems(todoStore.currentUser.id) { (todoItems, count, error) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            var items = todoItems as NSArray
            self.records = items as [NSDictionary]
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Table
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String!
    {
        return "Complete"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let record = self.records[indexPath.row] as NSDictionary
        let completedItem = record.mutableCopy() as NSMutableDictionary
        completedItem["complete"] = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.table!.update(completedItem) {
            (result, error) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                println("Error: " + error.description)
                return
            }
            
            var mutable = self.records.mutableCopy() as NSMutableArray
            mutable.removeObjectAtIndex(indexPath.row)
            self.records = mutable.copy() as NSArray
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let item = self.records[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = item["text"] as? String
        cell.textLabel?.textColor = UIColor.blackColor()
        
        return cell
    }
    
    // Navigation
    
    @IBAction func addItem(sender : AnyObject) {
        self.performSegueWithIdentifier("addItem", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "addItem" {
            let todoController = segue.destinationViewController as ToDoItemViewController
            todoController.client = self.client
            todoController.todoStore = self.todoStore
            todoController.delegate = self
        }
    }
    
    
    // ToDoItemDelegate
    
    func didSaveItem(text: String, userId:String)
    {
        if text.isEmpty {
            return
        }
        
        let itemToInsert = ["text": text, "complete": false, "userId":userId]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.table!.insert(itemToInsert) {
            (item, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                println("Error: " + error.description)
            } else {
                
                if(userId == self.todoStore.currentUser.id)
                {
                    var mutable = self.records.mutableCopy() as NSMutableArray
                    mutable.addObject(item)
                    self.records = mutable.copy() as NSArray
                    self.tableView.reloadData()
                }
            }
        }
    }
}
