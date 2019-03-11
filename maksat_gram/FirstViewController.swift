//
//  FirstViewController.swift
//  maksat_gram
//
//  Created by Maksat Zhazbayev on 3/10/19.
//  Copyright © 2019 Maksat Zhazbayev. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController
{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any)
    {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        {
            (user, error) in
            if user != nil
            {
            self.performSegue(withIdentifier: "loginPerform", sender: nil)
            }
            else
            {
                print("Error occured: \(error?.localizedDescription)")
            }
        }
    }
    @IBAction func signupButton(_ sender: Any)
    {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground { (success, error) in
            if success
            {
                self.performSegue(withIdentifier: "loginPerform", sender: nil)
            }
            else
            {
                print("Error occured: \(error?.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
