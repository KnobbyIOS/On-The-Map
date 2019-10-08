//
//  LogonViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/12/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit

class LogonViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = UIApplication.shared.delegate as! AppDelegate
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        loadingIndicator.isHidden = true
        userNameTextField.text = defaults.string(forKey: "username")
    }
    
    
    @IBAction func logonButton(_ sender: Any) {
        
        
        let username = userNameTextField.text
        let password = passwordTextField.text
        
        if username != "" && password != "" {
            loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            
            //navigationToTabBarController()
            userLoginRequest(username: username!, password: password!)
            defaults.set(username, forKey: "username")
            dismissKeyboard()
            print("Can log in")
        } else {
            print("Please type in a username or password")
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func signUpButton(_ sender: Any) {
        openLink(Constants.Udacity.SignUp)
    }
    
// prepare and present tab bar controller
    
    private func navigationToTabBarController() {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainTabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else {
            return
        }
        
        present(mainTabBarVC, animated: true, completion: nil)
    }
    
    private func userLoginRequest(username : String, password : String) {
        
        DataClient.sharedInstance().authenticateUser(username: username, password: password) {(success, error) in
            DispatchQueue.main.async {
                if success {
                performUIUpdatesOnMain {
                    self.userNameTextField.text = ""
                    self.passwordTextField.text = ""
                }
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                performUIUpdatesOnMain {
                    self.showInfo(withTitle: "Login Error", withMessage: error ?? "Error while performing login.")
                    self.loadingIndicator.isHidden = true
                    print(error ?? Constants.ErrorMessages.loginError)
                }
            }
            }
            performUIUpdatesOnMain {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
    

