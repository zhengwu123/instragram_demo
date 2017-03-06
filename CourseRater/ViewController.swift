//
//  ViewController.swift
//  CourseRater
//
//  Created by New on 2/18/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//
import Parse
import UIKit

class ViewController: UIViewController {

    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var usernameLabel: UITextField!
    @IBOutlet var singupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "insta.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    singupButton.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
    loginButton.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignUp(_ sender: AnyObject) {
        var user = PFUser()
        if(usernameLabel.text != "")&&(passwordLabel.text != ""){
            
            user.username = usernameLabel.text
            user.password = passwordLabel.text
            // other fields can be set just like with PFObject
            
            
            user.signUpInBackground {
                (succeeded: Bool, error: Error?) -> Void in
                if let error = error {
                   // let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    print(error.localizedDescription)
                } else {
                    // Hooray! Let them use the app now.
                    self.performSegue(withIdentifier: "toChat", sender: self)
                }
            }
        }
        else{
            let alertController = UIAlertController(title: "error", message:
                "invalid username and password!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
 
        
    }
    
    
    
    
  
    @IBAction func onLogin(_ sender: AnyObject) {
        
        if(usernameLabel.text != "")&&(passwordLabel.text != ""){
            let username = usernameLabel.text
            let password = passwordLabel.text
            
            
            PFUser.logInWithUsername(inBackground: username!, password:password!) {
                (user: PFUser?, error: Error?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    print("login success!")
                    self.performSegue(withIdentifier: "toChat", sender: self)
                    
                } else {
                    // The login failed. Check error to see why.
                }
            }
        }
        else{
            let alertController = UIAlertController(title: "error", message:
                "invalid username and password!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }

        
    }
    


}

