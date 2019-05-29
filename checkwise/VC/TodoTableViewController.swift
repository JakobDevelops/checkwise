//
//  TodoTableViewController.swift
//  checkwise
//
//  Created by Jakob Wiemer on 08.05.19.
//  Copyright © 2019 Jakob Wiemer. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    
    //Responsible for updating the table view
    var resultsController: NSFetchedResultsController<Items>!
    let coreDataStack = CoreDataStack();
    var isChecked = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        //show newest items first
        let sortDiscriptors = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDiscriptors]
        
        //Init
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        
        //Fetch data: Daten aus dem persistenen Context laden
        do {
        try resultsController.performFetch()
        } catch {("Perform fetch error: \(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].objects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
    //Swipe actions on the table view
    
    //Delete Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            //Safe context
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true) //something like .apply();
            } catch {
                print("Delete failed: \(error)")
                completion(false)
            }
        }
        
        // Todo
        //action.image
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //Check Swipe
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Check") { (action, view, completion) in
            
            //let _: NSMutableAttributedString =  NSMutableAttributedString(string:"taskLabel")
            
            /*attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: taskLabel.text.count))
            taskLabel.attributedText = attributeString */
            
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true) //something like .apply();
            } catch {
                print("Checking failed: \(error)")
                completion(false)
            }
            
        }
        
        action.backgroundColor = .blue
    
        return UISwipeActionsConfiguration(actions: [action])
    }
    

    /*Tab to check
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todo = self.resultsController.object(at: indexPath)
        self.resultsController.managedObjectContext.refreshAllObjects()
        
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType =  UITableViewCell.AccessoryType.none
                do {
                    try self.resultsController.managedObjectContext.save()
                } catch {
                    print("Check failed: \(error)")
                }
                
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                do {
                    try self.resultsController.managedObjectContext.save()
                } catch {
                    print("Check failed: \(error)")
                }
            }
    }*/
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
    }
    

}

//Update when a new item has been added

extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}


func checkAccessoryType(cell: UITableViewCell, isChecked: Bool){
    if isChecked == true {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
    }
}



