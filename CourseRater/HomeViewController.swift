//
//  HomeViewController.swift
//  CourseRater
//
//  Created by New on 2/27/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var refresher: UIRefreshControl!
    
    @IBAction func onLogOff(_ sender: AnyObject) {
        print("logout")
        PFUser.logOut()

    }
    
    
    @IBOutlet var tableview: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.tableview.addSubview(refresher)
    }
    
    func refresh(){
    
    
    }
    var captions = [String]()
    var usernames = [String]()
    var imagefiles = [PFFile]()
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "zhengPost")
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    self.captions.append(object["message"] as! String)
                    
                    self.imagefiles.append(object["imageFile"] as! PFFile)
                    
                    self.usernames.append(object["username"] as! String)
                    
                    self.tableview.reloadData()
                    
                }
                
            }
            
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")  as! photoCell
        
        imagefiles[indexPath.row].getDataInBackground { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                cell.cellImage.image = downloadedImage
                
            }
            
        }
   cell.captionLabel.text = captions[indexPath.row]
        cell.usernamelabel.text = usernames[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            
        })))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

}
