//
//  MainTableViewController.swift
//  ShoppingList-Assessment2
//
//  Created by Colton Swapp on 7/31/20.
//  Copyright © 2020 Colton Swapp. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ListItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    // MARK: - Actions
    @IBAction func addItemButtonTapped(_ sender: Any) {
        presentAlerController()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return ListItemController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListItemController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell()}
        
        let itemToDisplay = ListItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.listItem = itemToDisplay
        
        // Set the cell's delegate
        cell.delegate = self
        if cell.listItem!.isComplete {
            cell.backgroundColor = UIColor(red: 141/255, green: 158/255, blue: 206/255, alpha: 0.2)
            } else {
            cell.backgroundColor = UIColor(red: 250/255, green: 169/255, blue: 179/255, alpha: 1)
        }
        cell.reloadInputViews()
                            
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemtoDelete = ListItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ListItemController.sharedInstance.remove(listItem: itemtoDelete)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ListItemController.sharedInstance.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Incompleted" : "Completed"
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
             
            header.contentView.backgroundColor = UIColor(red: 3/255, green: 252/255, blue: 186/255, alpha: 1)
            header.textLabel?.textColor = UIColor(red: 34/255, green: 46/255, blue: 80/255, alpha: 1)
            header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: Helper
    func presentAlerController() {
        let alertController = UIAlertController(title: "Add an item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter item"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alertController.textFields?[0].text, !itemName.isEmpty else { return}
            
            ListItemController.sharedInstance.create(for: itemName)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
        
        present(alertController, animated: true)
    }

} // End of MainTableView class

extension MainTableViewController: ListItemTableViewCellDelegate {
    func isCompleteButtonTapped(_ sender: ButtonTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else { return }
        let listItem = ListItemController.sharedInstance.fetchedResultsController.object(at: index)
        
        ListItemController.sharedInstance.updateCompletionStatus(listItem: listItem)
        sender.updateViews()
    }
    
    
}

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}
