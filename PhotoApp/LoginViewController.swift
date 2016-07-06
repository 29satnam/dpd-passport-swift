//
//  LoginViewController.swift
//  PhotoApp
//
//  Created by Satnam Sync on 1/18/16.
//  Copyright © 2016 Satnam Sync. All rights reserved.
//

let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var bgImage: UIImageView!
    
    var navBar: UINavigationBar!
    let navItem = UINavigationItem()
    var webView: UIWebView!
    var progressView: UIProgressView!
    
    @IBOutlet var loginTF: UITextField!
    @IBOutlet var passTF: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    
    @IBOutlet var signupLabel: UILabel!
    @IBOutlet var usrNameTF: UITextField!
    @IBOutlet var fullNameTF: UITextField!
    
    @IBOutlet var signinLabel: UILabel!
    @IBOutlet var orsignupBtn: UIButton!
    
    @IBOutlet var fbBtn: UIButton!
    @IBOutlet var twitterBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    
    @IBOutlet var closeBtn: UIButton!
    
    var theBool: Bool!
    var myTimer: NSTimer!
    var timeOut: NSTimer!
        
    var callbackString: String = String()
    
    //email tf constraints
    @IBOutlet var kTopGuideTF: NSLayoutConstraint!
    @IBOutlet var kBtmGuideTF1: NSLayoutConstraint!
    @IBOutlet var kBtmGuideTF2: NSLayoutConstraint!
    
    
    //pass tf constraints
    @IBOutlet var iTopGuideTF: NSLayoutConstraint!
    @IBOutlet var iBtmGuideTF1: NSLayoutConstraint!
    @IBOutlet var iBtmGuideTF2: NSLayoutConstraint!
    
    //login btn constraints
    @IBOutlet var zTopGuideTF: NSLayoutConstraint!
    @IBOutlet var zBtmGuideTF1: NSLayoutConstraint!
    @IBOutlet var zBtmGuideTF2: NSLayoutConstraint!
    
    //stack view contraints
    @IBOutlet var wBtmGuideSV1: NSLayoutConstraint!
    @IBOutlet var wBtmGuideSV2: NSLayoutConstraint!
    @IBOutlet var wTopGuideTF: NSLayoutConstraint!
    
    
    
    @IBOutlet var nVerSpacing: NSLayoutConstraint!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        self.loginTF.delegate = self
        self.loginBtn.layer.borderWidth = 0.0
        self.loginBtn.layer.cornerRadius = 4
        
        
        
        //username tf
        self.usrNameTF.layer.borderWidth = 0.0
        self.usrNameTF.borderStyle = UITextBorderStyle.None
        self.usrNameTF.layer.cornerRadius = 4
        self.usrNameTF.backgroundColor = UIColor.whiteColor()
        let paddingView0 = UIView(frame: CGRectMake(0, 0, 10, self.usrNameTF.frame.height))
        self.usrNameTF.leftView = paddingView0
        self.usrNameTF.leftViewMode = UITextFieldViewMode.Always

        //fullname tf
        self.fullNameTF.layer.borderWidth = 0.0
        self.fullNameTF.borderStyle = UITextBorderStyle.None
        self.fullNameTF.layer.cornerRadius = 4
        self.fullNameTF.backgroundColor = UIColor.whiteColor()
        let paddingView3 = UIView(frame: CGRectMake(0, 0, 10, self.fullNameTF.frame.height))
        self.fullNameTF.leftView = paddingView3
        self.fullNameTF.leftViewMode = UITextFieldViewMode.Always

        //login tf
        self.loginTF.layer.borderWidth = 0.0
        self.loginTF.borderStyle = UITextBorderStyle.None
        self.loginTF.layer.cornerRadius = 4
        self.loginTF.backgroundColor = UIColor.whiteColor()
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, self.loginTF.frame.height))
        self.loginTF.leftView = paddingView
        self.loginTF.leftViewMode = UITextFieldViewMode.Always

        //pass tf
        
        self.passTF.layer.borderWidth = 0.0
        self.passTF.borderStyle = UITextBorderStyle.None
        self.passTF.layer.cornerRadius = 4
        self.passTF.backgroundColor = UIColor.whiteColor()
        
        let paddingView2 = UIView(frame: CGRectMake(0, 0, 10, self.passTF.frame.height))
        self.passTF.leftView = paddingView2
        self.passTF.leftViewMode = UITextFieldViewMode.Always
        
        
        self.fbBtn.layer.cornerRadius = 4
        self.twitterBtn.layer.cornerRadius = 4
        self.googleBtn.layer.cornerRadius = 4
        
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
        self.webView.scrollView.bounces = false
        self.navBar.items = [self.navItem]
        
        // Create Progress View Control
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        progressView.trackTintColor = UIColor.redColor()
        progressView = UIProgressView(frame: CGRectMake(0, navBar.frame.size.height - 1.9, self.view.frame.size.width, 5))
        
        let paddingViewj = UIView(frame: CGRectMake(0, 0, 10, self.loginTF.frame.height))
        self.passTF.leftView = paddingViewj
        self.passTF.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    
    
    // TextField Delegate function
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    var blurEffectView: UIVisualEffectView!

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
                
        
        UIApplication.sharedApplication().statusBarHidden=true
        
        kBtmGuideTF1.active = false
        kBtmGuideTF2.active = false
        kTopGuideTF.active = true // altering
        
        iBtmGuideTF1.active = false
        iBtmGuideTF2.active = false
        iTopGuideTF.active = true // altering
        
        zBtmGuideTF1.active = false
        zBtmGuideTF2.active = false
        zTopGuideTF.active = false //altering
        
        wBtmGuideSV1.active = false
        wBtmGuideSV1.active = false
        wTopGuideTF.active = false
        
        signinLabel.hidden = false
        orsignupBtn.hidden = false
        closeBtn.hidden = false
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            //self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            
           // UIView.transitionWithView(self.view, duration: 0.25, options: UIViewAnimationOptions.CurveEaseInOut,
           //     animations: {self.view.addSubview(blurEffectView)}, completion: nil)
            
            self.view.addSubview(blurEffectView)
            
        }
        else {
            self.view.backgroundColor = UIColor.clearColor()
        }
        print(kTopGuideTF?.constant, iTopGuideTF?.constant)
        
                self.kTopGuideTF?.constant = 65
                self.iTopGuideTF?.constant = 160 //vertical spacing const is there
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.passTF.hidden = false
                    self.loginBtn.hidden = false
                })

        
        
        
         UIView.transitionWithView(self.view, duration: 0.15, options: UIViewAnimationOptions.CurveEaseInOut,
             animations: {self.view.layoutIfNeeded()}, completion: nil)
        
        
        self.view.bringSubviewToFront(self.passTF)
        
        self.loginTF.delegate = nil
        
        self.view.bringSubviewToFront(self.closeBtn)
        self.view.bringSubviewToFront(self.signinLabel)
        self.view.bringSubviewToFront(self.loginTF)
        self.view.bringSubviewToFront(self.loginBtn)
        self.view.bringSubviewToFront(self.orsignupBtn)
        
        


        return true
    }
    
    
    
    
    @IBAction func signinClose(sender: UIButton) {
        
        view.endEditing(true)
        
        //reverse it
        
        self.view.sendSubviewToBack(self.closeBtn)
        self.view.sendSubviewToBack(self.signinLabel)
       //                                                                              self.view.sendSubviewToBack(self.loginTF)
        self.view.sendSubviewToBack(self.loginBtn)
        self.view.sendSubviewToBack(self.orsignupBtn)
        
        
        
        UIApplication.sharedApplication().statusBarHidden=false

        kBtmGuideTF1.active = true
        kBtmGuideTF2.active = true
        kTopGuideTF.active = true // altering
        
        iBtmGuideTF1.active = true
        iBtmGuideTF2.active = true
        iTopGuideTF.active = true // altering
        
        zBtmGuideTF1.active = true
        zBtmGuideTF2.active = true
        zTopGuideTF.active = true //altering
        
        wBtmGuideSV1.active = true
        wBtmGuideSV1.active = true
        wTopGuideTF.active = true
        
        signinLabel.hidden = true
        orsignupBtn.hidden = true
        closeBtn.hidden = true
        
        self.kTopGuideTF?.constant = 350
        self.iTopGuideTF?.constant = 630 //vertical spacing const is there
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.passTF.hidden = true
            self.loginBtn.hidden = true
        })
        
        
        
        
        UIView.transitionWithView(self.view, duration: 0.15, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {self.view.layoutIfNeeded()}, completion: nil)
        
        
      //  self.view.bringSubviewToFront(self.passTF)
        
        self.loginTF.delegate = self
        

        
        
        
        blurEffectView.removeFromSuperview()


        

        

        
    }
    
    
    @IBAction func orsignupActBtn(sender: UIButton) {
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            print(self.nVerSpacing.constant, self.kTopGuideTF?.constant, self.iTopGuideTF?.constant)
            
            self.kTopGuideTF?.constant = 135
            
            print(self.nVerSpacing.constant, self.kTopGuideTF?.constant, self.iTopGuideTF?.constant)
        })

        UIView.transitionWithView(self.view, duration: 0.15, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {self.view.layoutIfNeeded()}, completion: nil)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.usrNameTF.hidden = false
            self.fullNameTF.hidden = false
            self.signupLabel.hidden = false
        
            self.view.bringSubviewToFront(self.usrNameTF)
            self.view.bringSubviewToFront(self.fullNameTF)
            self.view.bringSubviewToFront(self.signupLabel)
            
        })

        
    }
    
    //Mark: UINavigation Button action
    func cancelFunc() {
        
       // self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
        
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.webView.removeFromSuperview()
            self.navBar.removeFromSuperview()
        })
    }
    
    func refreshFunc() {
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/auth/login")!)
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
        
        self.navBar.addSubview(progressView!)
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.webView)
    }
    
    
    //Mark: Social Network Buttons
    @IBAction func twitterLogin(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            self.callbackString = "http://my.vigasdeep.com:2403/auth/twitter/callback"
            self.navItem.title = "Twitter Login"
            
            self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/auth/twitter")!))
            attachWebView()
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            
        }
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
        self.callbackString = "http://my.vigasdeep.com:2403/auth/facebook/callback"
        self.navItem.title = "Facebook Login"
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/auth/facebook")!))
        attachWebView()
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
            
        }
        
    }
    
    @IBAction func googleLogin(sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
        self.callbackString = "http://my.vigasdeep.com:2403/auth/google/callback"
        self.navItem.title = "Google Login"
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://my.vigasdeep.com:2403/auth/google")!))
        attachWebView()
        } else {
            
            let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        }
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
        self.timeOut.invalidate()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        dispatch_async(dispatch_get_main_queue(), {
            self.progressView.hidden = true
        })
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        dispatch_async(dispatch_get_main_queue(), {
            self.progressView.hidden = false
        })
        
        self.progressView.progress = 0.0
        
        
        self.theBool = false
        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
        
        self.timeOut = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: "cancelWeb", userInfo: nil, repeats: false)
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.timeOut.invalidate()
        
        self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"cancel\").style.display='none';")

        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.theBool = true
        dispatch_async(dispatch_get_main_queue(), {
        self.progressView.hidden = true
        })
    }
    
    func cancelWeb() {
        dispatch_async(dispatch_get_main_queue(), {
            self.webView.removeFromSuperview()
            self.navBar.removeFromSuperview()
        })
        
        dispatch_async(dispatch_get_main_queue(), {
        let alertController = UIAlertController(title: "Server error", message: "No Ranging Response received - T3 time-out.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
            
        })
    }
    
    func timerCallback() {
        if (self.theBool != nil) {
            if self.progressView.progress >= 1 {
                self.progressView.hidden = true
                self.myTimer.invalidate()
            } else {
                self.progressView.progress += 0.1
            }
        } else {
            self.progressView.progress += 0.05
            if self.progressView.progress >= 0.95 {
                self.progressView.progress = 0.95
            }
        }
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

}