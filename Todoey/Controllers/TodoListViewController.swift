//
//  ViewController.swift
//  Todoey
//
//  Created by Cooper Bossert on 4/22/19.
//  Copyright © 2019 Cooper Bossert. All rights reserved.
//

import UIKit
import CoreData
//Since we inherited UITableViewController, it is main class not subclass. So we don't need to add delegates, datasource, hook up IBOutlets, it's automated by Xcode
class TodoListViewController: UITableViewController {
    
    //Var = mutable, let = immutable
    
    //NSCoder converts array of items into a plist that we can save and retreive from
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //Tapping into UIApplication class, getting shared singleton object which corrosponds to the current app as an object, tapping into it's delegate, casting it into our class AppDelegate. We now has access to our app delegate as an object, and can tap into it's property called persistentContainer, and grab the viewContext of that
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Do any additional setup after loading the view.
        //Load prior data
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    //Create empty cells based on size of array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Reuse existing cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        //Populate cells with text from the itemArray
        cell.textLabel?.text = item.title
        
        //Ternary operator ->
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView delegate methods
    
    //Tells the specified row that it is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        //Removing the data from our permanent stores
        //        context.delete(itemArray[indexPath.row])
        //        //Removing current item from item array which is used to load the tableView datasource
        //        itemArray.remove(at: indexPath.row)
        
        //Give selected cell a checkmark as an accessory
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //Flash grey then go back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user clicks the 'Add Item' button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //Save new itemArray
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //Extending scope of alertTextField here by creating the local variable above, making it accessable within entire method
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        //Reload tableview data
        self.tableView.reloadData()
    }
    
    // = Item.fetchRequest() is default value if no arguements passed in when calling
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        //Fetch request, which is everything inside our persistent container
        do {
            //This output will be an array of items inside our persistent container
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

//Advantage of this is that we can split up the functionality of our view controller to have specific parts be responsible for specific things
//Modular design
//Better organized code + easier to debug + MARKS section
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //When we hit search button, whatever is entered in the search bar will replace the %@ below
        //[cd] will make the search feature non case sensitive and non diacritic
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort by title in alphabetical order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    //Reset view after search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //If text in searchbar has changed but gone to zero
        //Not called on open because there was no change
        if searchBar.text?.count == 0 {
            loadItems()
            //Assign projects to different threads
            DispatchQueue.main.async {
                //Relinquish status as first responder
                searchBar.resignFirstResponder()
            }
        }
    }
}
