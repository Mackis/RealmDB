//
//  ViewController.swift
//  RealmDB
//
//  Created by Malcolm Kumwenda on 2017/03/27.
//  Copyright © 2017 ByteOrbit. All rights reserved.
//

import UIKit
import RealmSwift
import ZWAlertController

class ViewController: UIViewController {

    // Mark: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // Mark: - Properties
    let realm = try! Realm()
    var todoList: Results<TodoItem> {
        get {
            return realm.objects(TodoItem.self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addNew(_ sender: Any) {
        let alertController = ZWAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
        alertController.addTextFieldWithConfigurationHandler{(UITextField) in
            
        }
        
        let add_action = ZWAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> () in
            let textField_todo = (alertController.textFields?.first)! as! UITextField
            print("You entered \(textField_todo.text)")
            let todoItem = TodoItem()
            todoItem.detail = textField_todo.text!
            todoItem.status = "⚠️"
            try! self.realm.write {
                self.realm.add(todoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            }
        }
        alertController.addAction(add_action)
        
        
        let cancel_action = ZWAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel_action)
        
        present(alertController, animated: true, completion: nil)
       
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = todoList[(todoList.count-1) - indexPath.row]
        cell.textLabel?.text = item.detail
        cell.detailTextLabel?.text = "\(item.status)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoList[(todoList.count-1) - indexPath.row]
        try! self.realm.write {
            if (item.status == "⚠️"){
                item.status = "✅"
            }else {
                item.status = "⚠️"
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let item = todoList[(todoList.count-1) - indexPath.row]
            try! self.realm.write {
                self.realm.delete(item)
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
