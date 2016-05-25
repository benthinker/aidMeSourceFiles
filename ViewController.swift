//
//  ViewController.swift
//  AidMe
//
//  Created by Ben Siso on 03/02/2016.
//  Copyright © 2016 Ben Siso. All rights reserved.
//

import UIKit

class ViewController: UIViewController , FBSDKLoginButtonDelegate  {

    var userLoggedAlready : FAuthData?
    var ref : Firebase?
    @IBOutlet weak var loginButtonReal: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().hidden = true
        
        ref = Firebase(url: "https://blinding-fire-5374.firebaseio.com")
        if FBSDKAccessToken.currentAccessToken() == nil {
                print("not log in ")
            
        } else {
            print("logged in")
        }
        
        loginButtonReal.readPermissions = ["public_profile","email","user_friends"]
        loginButtonReal.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - facebook login
   
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print ("_facebook login complate")
            // login to Firebase
                            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                            self.ref!.authWithOAuthProvider("facebook", token: accessToken,
                                withCompletionBlock: { error, authData in
                                    if error != nil {
                                        print("__firebase Login failed.-->> \(error)")
                                    } else {
                                        let email = authData.providerData["email"] as? String
                                        let displayName = authData.providerData["displayName"] as? String
                                        let profilePhotoUrl = authData.providerData["profileImageURL"] as? String
                                        let newUserRef = self.ref!.childByAppendingPath("users")
                                        newUserRef.childByAppendingPath(authData.uid).updateChildValues(["firstName" : displayName! , "email" : email! , "profileURLPhoto" : profilePhotoUrl! ])
                                    }
            
                            })
                performSegueWithIdentifier("newUser", sender: self)
            
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user Log Out")
    }

}





