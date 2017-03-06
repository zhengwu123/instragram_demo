//
//  AddphotoViewController.swift
//  CourseRater
//
//  Created by New on 2/27/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//

import UIKit
import Parse

class AddphotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var captionText: UITextField!
    @IBOutlet var imagePost: UIImageView!
    var activityIndicator = UIActivityIndicatorView()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismiss(animated: true, completion: nil)
        imagePost.image = image
    }
    
    func go(){
    self.performSegue(withIdentifier: "posttotable", sender: self)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Onalbum(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }

    @IBAction func OnCamera(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
        
    }
    
    @IBAction func onPost(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.6)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "zhengPost")
        
        post["message"] = captionText.text
        
        post["userId"] = PFUser.current()!.objectId!
        post["username"] = PFUser.current()?.username
        
        let imageData = UIImagePNGRepresentation(resize(imagePost.image!, newSize: CGSize(width: 300,height: 300)))
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground{(success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                
                self.imagePost.image = UIImage(named: "image_file-1.png")
                
                self.captionText.text = ""
             let vc = self.storyboard!.instantiateViewController(withIdentifier: "tap")
                self.show(vc as UIViewController, sender: vc)
                
            } else {
                
                self.displayAlert("Could not post image", message: "Please try again later")
                
            }
            
        }

    }
    
    
    @IBAction func onTap(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            
        })))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func resize(_ image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool{
        captionText.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
