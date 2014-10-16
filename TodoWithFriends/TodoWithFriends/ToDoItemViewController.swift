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

protocol ToDoItemDelegate {
    func didSaveItem(text : String, userId : String)
}

class ToDoItemViewController: UIViewController, UINavigationBarDelegate,  UIBarPositioningDelegate, UITextFieldDelegate,
    UITableViewDataSource {
    
    @IBOutlet var NavBar : UINavigationBar!
    @IBOutlet var text : UITextField!
    @IBOutlet var tableView: UITableView!
    var client : MSClient?
    var todoStore : TodoStore?
    var friends = NSArray()
    var userService: UserService?
    
    var delegate : ToDoItemDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.NavBar.delegate = self
        self.text.delegate = self
        self.text.becomeFirstResponder()
        self.tableView.dataSource = self
        self.userService = UserService(client:self.client!)
        self.userService?.fetchAllUsers(self.todoStore!.currentUser.id, completion: { (users, count, error) in
            self.friends = users as NSArray
            self.tableView.reloadData()
        })
    }
    
    @IBAction func cancelPressed(sender : UIBarButtonItem) {
        self.text.resignFirstResponder()
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        saveItem()
        self.text.resignFirstResponder()
    }
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition
    {
        return UIBarPosition.TopAttached
    }
    
    // Textfield
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        saveItem()
        
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = self.friends[indexPath.row] as NSDictionary
        var cell =  UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")!
        cell.textLabel!.text = user["name"] as? String
        return cell
    }
    
    // Delegate
    
    func saveItem()
    {
        var index = self.tableView.indexPathForSelectedRow()
        var userId = self.todoStore?.currentUser.id
        
        if(index != nil)
        {
            let user = User.DictionaryToUser(self.friends[index!.row] as NSDictionary)
            userId = user.id
        }
        let text = self.text.text
        self.delegate?.didSaveItem(text, userId: userId!)
    }
}