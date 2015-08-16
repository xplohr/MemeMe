//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/23/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit

protocol MemeDetailDelegate {
    func deleteMemeFromDetail(sender: MemeDetailViewController)
    func editMemeFromDetail(sender: MemeDetailViewController)
}

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memeImage: UIImage?
    var memeIndex: NSIndexPath?
    var delegate: MemeDetailDelegate?
    
    override func viewDidLoad() {
        if (memeImage != nil) {
            imageView.image = memeImage
        }
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        // For some reason, the unwind segues aren't getting called in the simulator. Therefore, had to go back to old method.
        if (delegate != nil) {
            delegate?.deleteMemeFromDetail(self)
        }
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        // For some reason, the unwind segues aren't getting called in the simulator. Therefore, had to go back to old method.
        if (delegate != nil) {
            delegate?.editMemeFromDetail(self)
        }
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let activityView = UIActivityViewController(activityItems: [memeImage!], applicationActivities: nil)
        presentViewController(activityView, animated: true, completion: nil)
    }
}