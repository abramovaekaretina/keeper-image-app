//
//  ViewController.swift
//  keeperImage
//
//  Created by Ekaterina Abramova on 12.12.2020.
//

//swiftlint:disable all

import UIKit
import SwiftyKeychainKit

class ViewController: UIViewController {

    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var loginTextField: UITextField!
    private var passwordTextField: UITextField!

    private let login = "lala"
    private let password = "1234"

    let keychain = Keychain(service: "adadadd.keeperImage")
    var passwords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        activityIndicator.alpha = 0
//        do {
//            let pass = try self.keychain.get(self.passwordKey)
//            print()
//            print(pass)
//            print()
//        } catch {
//            print(error)
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurEffectView.alpha = 0
        showAuthorizationAlert()

    }
    
    func showAuthorizationAlert() {
        let login = self.loginTextField?.text ?? ""
        let password = self.passwordTextField?.text ?? ""
        let keychainKey = KeychainKey<String>(key: login)
        
        let alert = UIAlertController(title: "Hello", message: "Enter or Registration", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if (try? self.keychain.get(keychainKey)) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nameController = String(describing: KeeperViewController.self)
                let viewController = storyboard.instantiateViewController(identifier: nameController) as KeeperViewController
                viewController.login = self.loginTextField?.text
                UserDefaults.standard.setValue(self.loginTextField?.text, forKey: "Login")
                UIView.animate(withDuration: 1.5, delay: 0) {
                    self.activityIndicator.alpha = 1
                    self.activityIndicator.startAnimating()
                } completion: { (_) in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.pushViewController(viewController,
                                                                  animated: true)
                }
            } else {
                self.showWrongLogAlert()
            }
        }
        
        let registrationAction = UIAlertAction(title: "Registration", style: .default) { (_) in
            if (try? self.keychain.get(keychainKey)) != nil {
                self.showErrorAlert()
            } else {
                try? self.keychain.set(password, for: keychainKey)
                print("User saved")
                 self.showSignInAlert()
            }
        }
        
        alert.addTextField { (login) in
            login.placeholder = "Enter login"
            self.loginTextField = login
        }
        alert.addTextField { (password) in
            password.placeholder = "Enter password"
            password.isSecureTextEntry = true
            self.passwordTextField = password
        }
        
        alert.addAction(enterAction)
        alert.addAction(registrationAction)
        present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.showAuthorizationAlert()
        }
        alert.addAction(enterAction)
        present(alert, animated: true)
    }
    
    func showWrongLogAlert() {
        let alert = UIAlertController(title: "Error", message: "Wrong login or password", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.showSignInAlert()
        }
        
        alert.addAction(enterAction)
        present(alert, animated: true)
    }
    
    func showSignInAlert() {
        let login = self.loginTextField?.text ?? ""
        let password = self.passwordTextField?.text ?? ""
        let keychainKey = KeychainKey<String>(key: login)
        
        let alert = UIAlertController(title: "Enter", message: "Enter login and password", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if (try? self.keychain.get(keychainKey)) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nameController = String(describing: KeeperViewController.self)
                let viewController = storyboard.instantiateViewController(identifier: nameController) as KeeperViewController
                viewController.login = self.loginTextField?.text
                UserDefaults.standard.setValue(self.loginTextField?.text, forKey: "Login")
                UIView.animate(withDuration: 1.5, delay: 0) {
                    self.activityIndicator.alpha = 1
                    self.activityIndicator.startAnimating()
                } completion: { (_) in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.pushViewController(viewController,
                                                                  animated: true)
                }
            } else {
                self.showWrongLogAlert()
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.showAuthorizationAlert()
        }
        
        alert.addTextField { (login) in
            login.placeholder = "Enter login"
            self.loginTextField = login
        }
        alert.addTextField { (password) in
            password.placeholder = "Enter password"
            password.isSecureTextEntry = true
            self.passwordTextField = password
        }
        
        alert.addAction(enterAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func showKeeperViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nameController = String(describing: KeeperViewController.self)
        let viewController = storyboard.instantiateViewController(identifier: nameController) as KeeperViewController
        UIView.animate(withDuration: 1.5, delay: 0) {
            self.activityIndicator.alpha = 1
            self.activityIndicator.startAnimating()
        } completion: { (_) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.navigationController?.pushViewController(viewController,
                                                          animated: true)
        }
    }
}
