//
//  RegisterViewController.swift
//  KeepInTouch
//
//  Created by Ghassan  albakuaa  on 10/17/20.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
 
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
       
       if let email = emailTextfield.text , let password = passwordTextfield.text
                {
        Auth.auth().createUser(withEmail: email, password: password  )
        { authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                //Navigate to the chatViewController
                //self.performSegue(withIdentifier: "Register2", sender: self)
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
                
            }
            
        }       }
      
    }
    
}
