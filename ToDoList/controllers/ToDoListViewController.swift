//
//  ViewController.swift
//  ToDoList
//
//  Created by 黎光宸 on 2019/2/11.
//  Copyright © 2019年 黎光宸. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {
    var toDoItems:Results<item>?
    let realm = try!Realm()
    var selectedCategory:Category?{
        didSet{
            loadItem()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
        
     
//        if let items=defaults.array(forKey: "ToDoListArray")as?[item]{
//            toDoItems=items
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row]{
            
        cell.textLabel?.text=item.title
        cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text="NO Items Added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
            
                    item.done = !item.done
                }
            }catch{
                print("Error saving data \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert=UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add item", style: .default) { (action) in
        
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem=item()
                        newItem.title=textField.text!
                        newItem.dateCreated=Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error,\(error)")
                }
               
               
            }
            
            self.tableView.reloadData()
          
       
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "Create new item"
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
  
    func loadItem(){
        
        toDoItems=selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

         tableView.reloadData()
    }

}
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
          tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItem()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }

        }

}

}
