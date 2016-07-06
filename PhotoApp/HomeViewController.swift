//
//  ViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/17/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var usernameLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
            
            let token = prefs.valueForKey("SESSIONID") as? String
            
            let session = NSURLSession.sharedSession()
            
            let url = NSURL(string: "http://my.vigasdeep.com:2403/users/me")
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.setValue( "Bearer \(token!)", forHTTPHeaderField: "Authorization")
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if (data != nil) {
                    let res = response as! NSHTTPURLResponse!;
                    if 200..<300 ~= res.statusCode {
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                            let username:String = jsonData.valueForKey("username") as! String
                            print(username)
                        } catch _ as NSError {
                            
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}