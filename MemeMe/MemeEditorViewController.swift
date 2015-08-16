//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/16/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import UIKit
import CoreData

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var memeToEdit: MemeItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        if (memeToEdit != nil) {
            imageView.image = UIImage(data: memeToEdit!.originalImage)
            topTextField.text = memeToEdit!.topLabel
            bottomTextField.text = memeToEdit!.bottomLabel
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func takePictureFromCamera(sender: UIBarButtonItem) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoFromLibrary(sender: UIBarButtonItem) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func shouldMoveViewAboveKeyboard(kbHeight: CGFloat) -> Bool {
        // Find the first responder
        var firstResponder: UIView?
        for view in self.view.subviews {
            if (view.isFirstResponder()) {
                firstResponder = (view as! UIView)
                break
            }
        }
        
        if (firstResponder != nil && firstResponder is UITextField) {
            var testRect = self.view.frame
            testRect.size.height -= kbHeight
            
            var endFrame = CGPointMake(firstResponder!.frame.origin.x + firstResponder!.frame.size.width, firstResponder!.frame.origin.y + firstResponder!.frame.size.height)
            
            if (CGRectContainsPoint(testRect, endFrame)) {
                return false
            } else {
                return true
            }
        }
        
        return false
    }
    
    func moveView(up: Bool, kbHeight: CGFloat) {
        var movement = (up ? -kbHeight : kbHeight)
        
        if (((movement < 0 && self.view.frame.origin.y == 0) || (movement > 0 && self.view.frame.origin.y < 0)) && shouldMoveViewAboveKeyboard(kbHeight)) {
            UIView.animateWithDuration(0.25, animations: {
                self.view.frame = CGRectOffset(self.view.frame, 0, movement)
            })
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info: NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var keyboardHeight: CGFloat = keyboardSize.height
        
        moveView(true, kbHeight: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info: NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var keyboardHeight: CGFloat = keyboardSize.height
        
        moveView(false, kbHeight: keyboardHeight)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("MemeItem", inManagedObjectContext: managedContext)
        var meme = memeToEdit
        if (meme == nil) {
            meme = (NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! MemeItem)
        }
        
        meme!.setValue(topTextField.text, forKey: "topLabel")
        meme!.setValue(bottomTextField.text, forKey: "bottomLabel")
        meme!.setValue(UIImageJPEGRepresentation(imageView.image, 0.9), forKey: "originalImage")
        
        imageView.addSubview(topTextField)
        imageView.addSubview(bottomTextField)
        
        let memeImage = createMemeImage()
        meme!.setValue(UIImageJPEGRepresentation(memeImage, 0.9), forKey: "image")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save meme: \(error), \(error?.userInfo)")
            let alert = UIAlertView(title: "Save Error", message: "Sorry, we encountered an error while trying to save your meme.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
        var activityView = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityView, animated: true, completion: nil)
    }
    
    func createMemeImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        imageView.layer.renderInContext(context)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memeImage
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let editedImage = editingInfo[UIImagePickerControllerEditedImage] as! UIImage?
        
        if (editedImage == nil) {
            imageView.image = image
        } else {
            imageView.image = editedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == topTextField && textField.text == "") {
            textField.text = "TOP"
        } else if (textField == bottomTextField && textField.text == "") {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
