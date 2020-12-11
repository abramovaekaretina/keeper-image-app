//
//  ViewController.swift
//  keeperImage
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    private var loginTextField: UITextField!
    private var passwordTextField: UITextField!
    private let login = "lala"
    private let password = "1234"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.toolbar.isHidden = true
        blurEffectView.alpha = 0
        let alert = UIAlertController(title: "Log in", message: "Enter login and password, please", preferredStyle: .alert)
        alert.addTextField { (loginTextField) in
            loginTextField.placeholder = "Enter login"
            self.loginTextField = loginTextField
        }
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Enter password"
            passwordTextField.isSecureTextEntry = true
            self.passwordTextField = passwordTextField
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if (self.loginTextField.text == self.login) && (self.passwordTextField.text == self.password) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: String(describing: KeeperViewController.self)) as! KeeperViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                let wrongLogAlert = UIAlertController(title: "Sorry :(", message: "Incorrect login or password. Try again", preferredStyle: .alert)
                wrongLogAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    alert.textFields?.first.map{ $0.text = "" }
                    alert.textFields?.last.map{ $0.text = "" }
                    self.present(alert, animated: true)
                
                }))
                self.present(wrongLogAlert, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            UIView.animate(withDuration: 1, delay: 0) {
                self.blurEffectView.alpha = 0
            }

        }))
        UIView.animate(withDuration: 1, delay: 0) {
            self.blurEffectView.alpha = 1
            self.present(alert, animated: true)
        }

    }
    
    
}



