//
//  ViewController.swift
//  Todoey
//
//  Created by Cooper Bossert on 4/22/19.
//  Copyright © 2019 Cooper Bossert. All rights reserved.
//

import UIKit
//Since we inherited UITableViewController, it is main class not subclass. So we don't need to add delegates, datasource, hook up IBOutlets, it's automated by Xcode
class TodoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Tableview Datasource Methods
    
    //Create empty cells based on size of array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Reuse existing cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //Populate cells with text from the itemArray
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView delegate methods
    
    //Tells the specified row that it is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //Give selected cell a checkmark as an accessory
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            //Uncheck
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            //Check
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //Flash grey then go back to white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

