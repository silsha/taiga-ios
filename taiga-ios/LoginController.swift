//
//  ViewController.swift
//  taiga-ios
//
//  Created by Rhonan Carneiro on 08/10/15.
//  Copyright © 2015 Taiga. All rights reserved.
//

import UIKit
import Alamofire
import JLToast

class LoginController: UIViewController {


    
    @IBOutlet weak var lblHost: UITextField!
    @IBOutlet weak var lblUsername: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogin(sender: AnyObject) {
        let LOGIN_URL = lblHost.text! + "/api/v1/auth"
        if(lblUsername.hasText() && lblPassword.hasText()){
            loading.startAnimating()
            self.view.userInteractionEnabled = false
            Alamofire.request(.POST, LOGIN_URL, parameters : ["type": "normal", "username": lblUsername.text!, "password": lblPassword.text!], encoding: .JSON).responseObject { (response: Response<User, NSError>) in
                if let value = response.result.value {
                    let user: User = value
                    if user.authToken != nil {
                        let view: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("main") as! MainController
                        (view as! MainController).setUser(user)
                        (view as! MainController).setServerHost(self.lblHost.text!)
                        self.presentViewController(view, animated:true, completion:nil)
                    } else {
                        JLToast.makeText("Login failed").show()
                    }
                    
                } else {
                    JLToast.makeText("Connection problem").show()
                }
                self.view.userInteractionEnabled = true
                self.loading.stopAnimating()
            }
        }
    }

}

