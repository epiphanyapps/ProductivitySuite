//
//  TodoTableViewController.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 3/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ProductivitySuite
import CoreData
import Crashlytics

class TodoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Todos"
        Todo.fetchTodos { (success) in
            print("success \(success)")
        }
        
        let crashButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(TodoTableViewController.crashButtonTapped(_:)))
        navigationItem.rightBarButtonItem = crashButton
    }
    
    @objc func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withTodo: todo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    func configureCell(_ cell: UITableViewCell, withTodo todo: Todo) {
        cell.textLabel?.text = todo.text
        cell.detailTextLabel?.text = dateFormatter.string(from: todo.updatedAt)
    }

    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Todo> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Todo>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withTodo: anObject as! Todo)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

}
