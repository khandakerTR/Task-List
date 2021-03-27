//
//  CategoryTableViewController.swift
//  Task List
//
//  Created by Tushar Khandaker on 3/25/21.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController, UITextFieldDelegate {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        showalert()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    // MARK: - Table view delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TaskListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCatagory = categories[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
       
        
    }
    
    func showalert (){
        
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
                    var newCategory = Category(context: self.context)
                    newCategory.name = textField
                    self.categories.append(newCategory)
                    self.saveCatagory()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
        }
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func saveCatagory () {
        
        do {
            try context.save()
        }catch {
            print("Error Saving Category \(error)")
        }
        
        self.tableView.reloadData()
    }
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try  context.fetch(request )
        }catch{
            print("Eorrr Loading Data from Category:\(error)")
        }
        tableView.reloadData()
    }
    

}
