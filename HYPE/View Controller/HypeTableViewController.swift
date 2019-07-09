//
//  HypeTableViewController.swift
//  HYPE
//
//  Created by Madison Kaori Shino on 7/9/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit
import CloudKit

class HypeTableViewController: UITableViewController, UITextFieldDelegate {

    var refresh: UIRefreshControl = UIRefreshControl()
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
        
        loadData()
    }
    
    //ACTIONS
    @IBAction func addButtonTapped(_ sender: Any) {
        presentHypeAlert()
    }
    
    //HELPER FUNCTIONS
    @objc func loadData() {
        HypeController.sharedInstance.fetchHype { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
        }
    }
    
    func presentHypeAlert() {
        let alertController = UIAlertController(title: "New Hype", message: "What's on your mind?", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Hype has a limit of 45 characters."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            textField.delegate = self
        }
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let hypeText = alertController.textFields?.first?.text else {return}
            if hypeText != "" {
                HypeController.sharedInstance.saveHype(text: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive)
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    //TABLE VIEW
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.sharedInstance.hypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        //hype to display in cell
        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        cell.textLabel?.text = hype.hypeText
        cell.detailTextLabel?.text = hype.timeStamp.formatDate()
        return cell
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
