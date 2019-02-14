//
//  ViewController.swift
//  ToDoList
//
//  Created by 黎光宸 on 2019/2/11.
//  Copyright © 2019年 黎光宸. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory:Category?{
        didSet{
            loadItem()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
        
     
//        if let items=defaults.array(forKey: "ToDoListArray")as?[item]{
//            itemArray=items
//        }
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
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //        if itemArray[indexPath.row].done==false {
//            itemArray[indexPath.row].done=true
//        }
//        else{
//            itemArray[indexPath.row].done=false
//        }
        savaData()
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert=UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add item", style: .default) { (action) in
        
            let newItem=Item(context:self.context)
            newItem.title=textField.text!
            newItem.done=false
            newItem.parentCategory=self.selectedCategory
            self.itemArray.append(newItem)
          self.savaData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "Create new item"
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func savaData(){
       
        do{
            
          try  context.save()
        }
        catch{
           print("Error saving context,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadItem(with request:NSFetchRequest<Item>=Item.fetchRequest(),predicate:NSPredicate?=nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else{
            request.predicate=categoryPredicate
        }
      
        do{
            itemArray=try context.fetch(request)
        }
        catch{
            print("error fetching,\(error)")
        }
         tableView.reloadData()
    }
 
}
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        let predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with : request,predicate: predicate)

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


