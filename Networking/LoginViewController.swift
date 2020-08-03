//
//  LoginViewController.swift
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


class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
    lazy var googleLoginButton: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 100, width: view.frame.width - 64, height: 40)
        return loginButton
    }()
    
    lazy var emailLoginButton: UIButton = {
        let emailButton = UIButton()
        emailButton.frame = CGRect(x: 32, y: 230, width: view.frame.width - 64, height: 40)
        emailButton.backgroundColor = .blue
        emailButton.setTitle("Email login", for: .normal)
        emailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        emailButton.setTitleColor(.white, for: .normal)
        emailButton.layer.cornerRadius = 4
        emailButton.addTarget(self, action: #selector(openEmailLogin), for: .touchUpInside)
        return emailButton
    }()
    
    lazy var customGoogleLoginButton: UIButton = {
        let googleButton = UIButton()
        googleButton.frame = CGRect(x: 32, y: 295, width: view.frame.width - 64, height: 40)
        googleButton.backgroundColor = .gray
        googleButton.setTitle("Google login", for: .normal)
        googleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        googleButton.setTitleColor(.white, for: .normal)
        googleButton.layer.cornerRadius = 4
        googleButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        return googleButton
    }()
    
    lazy var fbLoginButton: FBLoginButton = {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.frame = CGRect(x: 32, y: 165, width: view.frame.width - 64, height: 40)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        view.addSubview(fbLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(customGoogleLoginButton)
    }
    
    @objc private func openEmailLogin() {
        performSegue(withIdentifier: "ShowEmailLogin", sender: self)
    }
    
    @objc private func signInGoogle() {
        GIDSignIn.sharedInstance()?.signIn()
     }
    
}

// MARK: Facebook SDK

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error as Any)
            return
        }
        
        guard AccessToken.isCurrentAccessTokenActive else { return }
        
        signIntoFirebase()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out from facebook")
    }
    
    private func openMainViewController() {
        dismiss(animated: true)
    }
    
    private func signIntoFirebase() {
        
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            
            if let error = error {
                print("Smth wrong with fb, \(error)")
            }
            
            print("Successfully logged in Firebase")
            self.fetchFBUserData()
        }
    }
    
    
    private func fetchFBUserData() {
        
        GraphRequest(graphPath: "me", parameters: ["fields":"email, name, id, gender, devices"]).start { (_, result, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let userData = result as? [String:Any] {
                self.userProfile = UserProfile(data: userData)
                print(self.userProfile?.name ?? " nthn ")
                self.saveIntoFirebase()
            }
        }
    }
    
    private func saveIntoFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        let values = [uid: userData]
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
            print("Successfully saved into firebase")
        }
        openMainViewController()
    }
}



// MARK: GOOGLE SDK


extension LoginViewController: GIDSignInDelegate  {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to login (Google) \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credentials) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self.openMainViewController()
            print("Successfully logged in with Google")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userData = ["name": user.profile.name, "email": user.profile.email]
            self.userProfile = UserProfile(data: userData)
            let values = [uid: userData]
            Database.database().reference().child("users").updateChildValues(values) { (error, _) in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Successfully saved into firebase")
            }
        }
    }
}
