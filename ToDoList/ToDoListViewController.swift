//
//  ViewController.swift
//  ToDoList
//
//  Created by 黎光宸 on 2019/2/11.
//  Copyright © 2019年 黎光宸. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = [item]()
    let defaults=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem=item()
        newItem.title="Walk"
        itemArray.append(newItem)
        let newItem2=item()
        newItem2.title="Go"
        itemArray.append(newItem2)
        let newItem3=item()
        newItem3.title="Run"
        itemArray.append(newItem3)
     
        if let items=defaults.array(forKey: "ToDoListArray")as?[item]{
            itemArray=items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
//        if itemArray[indexPath.row].done==true{
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].done==false {
            itemArray[indexPath.row].done=true
        }
        else{
            itemArray[indexPath.row].done=false
        }
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert=UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem=item()
            newItem.title=textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "Create new item"
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
}

