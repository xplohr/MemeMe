//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/25/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MemeDetailDelegate {
    
    var savedMemes: [NSManagedObject]?
    
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        savedMemes = appDelegate.fetchMemes()
        collectionView?.reloadData()
    }
    
    func deleteMeme(indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.deleteMeme(savedMemes!, indexPath: indexPath)
        savedMemes = appDelegate.fetchMemes()
        collectionView?.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (savedMemes != nil) {
            return savedMemes!.count
        } else {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let memeRecord = savedMemes![indexPath.row] as! MemeItem
        
        cell.backgroundColor = UIColor.blackColor()
        cell.imageView.image = UIImage(data: memeRecord.image)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "presentMemeDetail") {
            var controller = segue.destinationViewController as! MemeDetailViewController
            let cell = sender as! MemeCollectionCell
            let selectedCell = collectionView?.indexPathsForSelectedItems()
            
            controller.memeImage = cell.imageView?.image
            controller.memeIndex = (selectedCell![0] as! NSIndexPath)
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
