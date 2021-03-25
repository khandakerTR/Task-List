//
//  ViewController.swift
//  Task List
//
//  Created by Tushar Khandaker on 3/24/21.
//

import UIKit
import CoreData
class TaskListViewController: UITableViewController, UITextFieldDelegate {
    
    var itemArray = [Item]()
    //NSCoder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        loadItem()
    }
    
    //data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: " ListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        if item.done == false {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    //delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //delete Sqlite
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        saveItem()
    }
    
    // add new item
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        showAlert()
        
    }
    
    func  showAlert() {
        
        let alert = UIAlertController(title: "Add Task", message: "Enter Your Task Here", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter  emails"
            textField.delegate = self
        }
        let save = UIAlertAction(title: "Save", style: .default) { saveAction in
            guard let textField = alert.textFields?[0].text else { return }
            
            if !textField.isEmpty{
                if !textField.trimmingCharacters(in: .whitespaces).isEmpty {
                    print(textField)
                    
                    
                    var newItem = Item(context: self.context)
                    newItem.title = textField
                    newItem.done = false
                    self.itemArray.append(newItem)
                    self.saveItem()
                }  
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
        }
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
    //save data
    func saveItem () {
        
        do {
            try context.save()
        }catch {
            print("Error Saving Context \(error)")
        }
        
        self.tableView.reloadData()
    }
    // load data
    func loadItem() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try  context.fetch(request )
        }catch{
            print("Eorrr Loading Data:\(error)")
        }
    }
}
