//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/18/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

import UIKit
import Alamofire

class LoginViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    var navBar: UINavigationBar!
    let navItem = UINavigationItem()
    var webView: UIWebView!
    
    var callbackString: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Mark: Remove UIWebView Login Cookies
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }

        self.navBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 54))
        self.webView = UIWebView(frame: CGRectMake(0, 54, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        self.navBar.backgroundColor = UIColor.whiteColor()
        
        let rightButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelFunc")
        self.navItem.rightBarButtonItem = rightButton

        let leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshFunc")
        self.navItem.leftBarButtonItem = leftButton

        self.webView.delegate = self
        self.navBar.items = [self.navItem]
    }
    
    //Mark: UINavigation Button action
    func cancelFunc() {
        dispatch_async(dispatch_get_main_queue(), {
            self.webView.removeFromSuperview()
            self.navBar.removeFromSuperview()
        })
    }
    
    func refreshFunc() {
        dispatch_async(dispatch_get_main_queue(), {
        self.webView.reload()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertController = UIAlertController(title: "Sign in Failed!", message: "Please enter Username and Password", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            
        } else {
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://xxxxxxxxxxxx.com:2403/auth/login")!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let post:NSString = "username=\(username)&password=\(password)"
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postLength:NSString = String( postData.length )
            
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {urlData, response, error -> Void in
                if (urlData != nil) {
                    let res = response as! NSHTTPURLResponse!;
                    if 200..<300 ~= res.statusCode {
                        do {
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                            let sessionId:String = jsonData.valueForKey("id") as! String
                            if(sessionId != "") {
                                
                                prefs.setObject(username, forKey: "USERNAME")
                                prefs.setObject(sessionId, forKey: "SESSIONID")
                                prefs.setInteger(1, forKey: "ISLOGGEDIN")
                                prefs.synchronize()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                
                                /* var error_msg:NSString
                                if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                                } else {
                                error_msg = "Unknown Error"
                                } */
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    let alertController = UIAlertController(title: "Sign in Failed!", message: "Failed to retrieve data", preferredStyle: .Alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                    alertController.addAction(OKAction)
                                    self.presentViewController(alertController, animated: true) { }
                                })
                            }
                        } catch _ as NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                let alertController = UIAlertController(title: "Sign in Failed!", message: "Server error", preferredStyle: .Alert)
                                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                                alertController.addAction(OKAction)
                                self.presentViewController(alertController, animated: true) { }
                            })
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Credentials", preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true) { }
                        })
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: "Sign in Failed!", message: "Check Internet Connection", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) { }
                    })
                }
            })
            task.resume()
        }
    }
    
    
    func attachWebView() {
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.webView)
    }
    
    
    //Mark: Social Network Buttons
    @IBAction func twitterLogin(sender: UIButton) {
        self.callbackString = "http://xxxxxxxxxxxx.com:2403/auth/twitter/callback"
        self.navItem.title = "Twitter Login"
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://xxxxxxxxxxxx.com:2403/auth/twitter")!))
        attachWebView()
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        self.callbackString = "http://xxxxxxxxxxxx.com:2403/auth/facebook/callback"
        self.navItem.title = "Facebook Login"
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://xxxxxxxxxxxx.com:2403/auth/facebook")!))
        attachWebView()
    }
    
    
    @IBAction func googleLogin(sender: UIButton) {
        self.callbackString = "http://xxxxxxxxxxxx.com:2403/auth/google/callback"
        self.navItem.title = "Google Login"
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://xxxxxxxxxxxx.com:2403/auth/google")!))
        attachWebView()
    }
    
    //Mark: Helper Method - Convert String to Dictionary
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    
    //Mark: UIWebView Delegate Methods
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let splitCallbackUrl = request.URL!.absoluteString.characters.split{$0 == "?"}.map(String.init)
        let callbackUrl = splitCallbackUrl[0]
        if callbackUrl  == callbackString {
            
            webView.stopLoading();
            let url = NSURL(string: request.URL!.absoluteString)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let responsedata = self.convertStringToDictionary(datastring as! String);
                
                let userId = responsedata!["uid"]! as! String
                let sessionId = responsedata!["id"]! as! String
                
                if(sessionId != "") {
                    
                    prefs.setObject(userId, forKey: "USERNAME")
                    prefs.setObject(sessionId, forKey: "SESSIONID")
                    prefs.setInteger(1, forKey: "ISLOGGEDIN")
                    prefs.synchronize()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let alertController = UIAlertController(title: "Sign in Failed!", message: "Failed to retrieve data", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true) { }
                    })
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.webView.removeFromSuperview()
                    self.navBar.removeFromSuperview()
                })
            }
            task.resume()
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
