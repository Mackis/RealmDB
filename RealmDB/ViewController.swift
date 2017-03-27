//
//  ViewController.swift
//  RealmDB
//
//  Created by Malcolm Kumwenda on 2017/03/27.
//  Copyright © 2017 ByteOrbit. All rights reserved.
//

import UIKit
import RealmSwift

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
        let alertController = DOAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
        
        alertController.addTextField { (UITextField) in
            
        }
        
        let cancel_action = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel_action)
        
        let add_action = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> () in
            let textField_todo = (alertController.textFields?.first)! as UITextField
            print("You entered \(textField_todo.text)")
            let todoItem = TodoItem()
            todoItem.detail = textField_todo.text!
            todoItem.status = 0
            try! self.realm.write {
                self.realm.add(todoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
            }
        }
        alertController.addAction(add_action)
        present(alertController, animated: true, completion: nil)
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = todoList[indexPath.row]
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
        let item = todoList[indexPath.row]
        try! self.realm.write {
            if (item.status == 0){
                item.status = 1
            }else {
                item.status = 0
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let item = todoList[indexPath.row]
            try! self.realm.write {
                self.realm.delete(item)
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
