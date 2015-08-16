//
//  SentMemesTabBarController.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/22/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SentMemesTabBarController: UITabBarController {
    
    @IBAction func addButtonClicked(sender: UIBarButtonItem) {
    }
    
    @IBAction func editButtonClicked(sender: UIBarButtonItem) {
        let controller = self.selectedViewController
        let buttonTitle = sender.title
        
        if (controller is SentMemesTableViewController) {
            let tableController = controller as! SentMemesTableViewController
            
            if (buttonTitle == "Edit") {
                sender.title = "Cancel"
                tableController.didTapEditButton()
            } else if (buttonTitle == "Cancel") {
                sender.title = "Edit"
                tableController.didTapCancelButton()
            }
        }
    }
    
    @IBAction func memeEditorDidCancel(segue: UIStoryboardSegue) {
        
    }
}
