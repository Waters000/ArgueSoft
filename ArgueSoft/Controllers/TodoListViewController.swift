//
//  TodoListViewController.swift
//  ArgueSoft
//
//  Created by Chris waters on 11/30/22.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework



class TodoListViewController: UITableViewController {
    
    // array from mdoel group Item
    var itemArray = [Item]()
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    func firstLaunch(){
        if launchedBefore  {
            print("Not first launch.")
            
        
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let newItem = Item(context: self.context)
            newItem.title = ConfigValues.get().Tip1.title
            newItem.done = false
            // adds item to the array
            self.itemArray.append(newItem)
            
            let newItem2 = Item(context: self.context)
            newItem2.title = ConfigValues.get().Tip2.title
            newItem2.done = false
            // adds item to the array
            self.itemArray.append(newItem2)
            
           let newItem3 = Item(context: self.context)
            newItem3.title = ConfigValues.get().Tip3.title
            newItem3.done = false
            // adds item to the array
            self.itemArray.append(newItem3)
            
            saveItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // hard coded array
   //var orignItems = ["Say I Love you", "Say Sorry", "Speak softly"]
    
    // this is for user defaults...only limited data such as the defaults for a user
   // let defaults = UserDefaults.standard
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        firstLaunch()
        
        
        
        
     //   print("title1 is: \(ConfigValues.get().Tip1.title)")
     //   print("done1 is: \(ConfigValues.get().Tip1.done)")
        
     //   print("title2 is: \(ConfigValues.get().Tip2.title)")
     //   print("done2 is: \(ConfigValues.get().Tip2.done)")
        
      //  print("title3 is: \(ConfigValues.get().Tip3.title)")
      //  print("done3 is: \(ConfigValues.get().Tip3.done)")
        
       // print("title is: \(ConfigValues.get().title)")
        //print("Done is: \(ConfigValues.get().done)")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        
        //print(dataFilePath)
        
       // title = "Tips to Stop Arguing"

        
       loadItems()
        //changes the height of the row so trash icon fits.
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        // comment out the hard coded array to use the Data Model Item.swift
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return itemArray.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        // Configure the cell...
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
        
        
        //random color
       // cell.backgroundColor = UIColor.randomFlat()
        cell.backgroundColor  = FlatSkyBlue().darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(itemArray.count)))
            // must be after cell.background color to not break app.
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
      //  print("version 1: \(CGFloat(indexPath.row / itemArray.count))")
      //  print("version 2: \(CGFloat(indexPath.row) / CGFloat(itemArray.count))")
        
        
        // ternaray if statement
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
 
        // deletes an item on select.
//        context.delete(itemArray[indexPath.row]) // must call this first so it deletes from context first
//        itemArray.remove(at: indexPath.row) // must call this second
       
        
        
        // sets opposite of boolean instead of if/else statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new Items button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Argument Item", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
                 // Called when user taps outside
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks add item button
            //print("button clicked to add")
           // print(textField.text)
        
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            // adds item to the array
            self.itemArray.append(newItem)
            
            // adds items to a local storage.
           // below line works for User defaults storage
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
       
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    
    func saveItems() {
        
        
        
        
        do {
           try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    // this function is the read in CRUD with CoreData.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error fetfching data from context \(error)")
        }
    }

}

//Mark: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
           
               let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
               
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
               
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("error fetfching data from context \(error)")
        }
        
        tableView.reloadData()
        
        
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("this is cleared")
            print(loadItems())
            tableView.reloadData()
               
            DispatchQueue.main.async {
                         searchBar.resignFirstResponder()
                     }
             
           }
       }
    
    
    
}

//Mark: Swip Cell Delegate Methods.
extension TodoListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            self.context.delete(self.itemArray[indexPath.row]) // must call this first so it deletes from context first
            self.itemArray.remove(at: indexPath.row)
            
            do {
                try self.context.save()
               //removed line below so the destructive delegate works
                // tableView.reloadData()
            } catch {
                print("error saving context, \(error)")
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
       // options.transitionStyle = .border
        return options
    }
    
    
}
