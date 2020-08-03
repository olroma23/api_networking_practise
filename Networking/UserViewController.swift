//
//  UserViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 08.07.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn


class UserViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32,
                              y: view.frame.height - 172,
                              width: view.frame.width - 64,
                              height: 50)
        button.backgroundColor = .blue
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    private var provider: String?
    private var currentUser: CurrentUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoutButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        nameLabel.isHidden = true
        fetchUserData()
    }
    
}

extension UserViewController {
    
    //    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    //        if error != nil {
    //            print(error as Any)
    //            return
    //        }
    //    }
    //
    //    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    //        openLoginViewController()
    //    }
    
    private func openLoginViewController() {
        
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                return
            }
        } catch let error as NSError {
            print("Failed to sign out", error.localizedDescription)
        }
    }
    
    private func fetchUserData() {
        
        guard Auth.auth().currentUser != nil else { return }
        
        if let userName = Auth.auth().currentUser?.displayName {
            activityIndicator.stopAnimating()
            nameLabel.isHidden = false
            nameLabel.text = userName
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let userData = snapshot.value as? [String: Any] else { return }
                    self.currentUser = CurrentUser(uid: uid, data: userData)
                    self.nameLabel.text = self.getProviderData()
                    self.nameLabel.isHidden = false
                    self.activityIndicator.stopAnimating()  
                    
                }) { (error) in
                    print(error.localizedDescription)
            }
        }
        
    }
    
    @objc private func signOut() {
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    LoginManager().logOut()
                    print("Logged out from FB")
                    openLoginViewController()
                case "google.com":
                    GIDSignIn.sharedInstance()?.signOut()
                    print("Logged out from Google")
                    openLoginViewController()
                case "password":
                    try! Auth.auth().signOut()
                    print("User signed out")
                    openLoginViewController()
                default:
                    print("User is signed in with \(userInfo.providerID)" )
                    break;
                }
            }
        }
    }
    
    
    private func getProviderData() -> String {
        var string = " "
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                default:
                    break;
                }
            }
        }
        
        string = "\(currentUser?.name ?? "noname") logged in with \(provider!)"
        return string
    }
    
}


