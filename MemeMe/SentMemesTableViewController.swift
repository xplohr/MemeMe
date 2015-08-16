//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/21/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SentMemesTableViewController: UITableViewController, MemeDetailDelegate {
    
    var savedMemes: [NSManagedObject]?
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        savedMemes = appDelegate.fetchMemes()
        tableView.reloadData()
        
        if (savedMemes?.count < 1) {
            performSegueWithIdentifier("showMemeEditor", sender: self)
        }
    }
    
    func didTapEditButton() {
        tableView.setEditing(true, animated: true)
    }
    
    func didTapCancelButton() {
        tableView.setEditing(false, animated: true)
    }
    
    func deleteMeme(indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deleteMeme(savedMemes!, indexPath: indexPath)
        savedMemes = appDelegate.fetchMemes()
        tableView.reloadData()
    }
    
    // MARK: - Table methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((savedMemes) != nil) {
            return savedMemes!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let memeRecord = savedMemes![indexPath.row] as! MemeItem
        
        cell.textLabel?.text = memeRecord.topLabel
        cell.detailTextLabel?.text = memeRecord.bottomLabel
        cell.imageView?.image = UIImage(data: memeRecord.image)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            deleteMeme(indexPath)
            
        default:
            return
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "presentMemeDetail") {
            var controller = segue.destinationViewController as! MemeDetailViewController
            let cell = sender as! UITableViewCell
            
            controller.memeImage = cell.imageView?.image
            controller.memeIndex = tableView.indexPathForSelectedRow()
            controller.delegate = self
        } else if (segue.identifier == "showMemeEditor") {
            if (sender is NSIndexPath) {
                let memeToEdit = savedMemes![sender!.row] as! MemeItem
                let controller = segue.destinationViewController as! MemeEditorViewController
                
                controller.memeToEdit = memeToEdit
            }
        }
    }
    
    // MARK: - MemeDetailDelegate
    
    func deleteMemeFromDetail(sender: MemeDetailViewController) {
        if (sender.memeIndex != nil) {
            deleteMeme(sender.memeIndex!)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    func editMemeFromDetail(sender: MemeDetailViewController) {
        navigationController?.popViewControllerAnimated(true)
        if (sender.memeIndex != nil) {
            performSegueWithIdentifier("showMemeEditor", sender: sender.memeIndex)
        }
    }
}