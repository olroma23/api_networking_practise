//
//  SignInViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 13.07.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    
    lazy var continueButton: UIButton = {
        let cButton = UIButton()
        cButton.frame = CGRect(x: 32, y: view.frame.height - 200, width: view.frame.width - 64, height: 40)
        cButton.backgroundColor = .blue
        cButton.setTitle("Continue", for: .normal)
        cButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cButton.setTitleColor(.white, for: .normal)
        cButton.layer.cornerRadius = 4
        cButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return cButton
    }()
    
    @IBOutlet weak var signInTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tFConfiguration(textField: signInTF)
        tFConfiguration(textField: passwordTF)
        
        view.addSubview(continueButton)
        
        enableButton(false)
        
        signInTF.addTarget(self, action: #selector(tfChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(tfChanged), for: .editingChanged)
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 39, height: 39)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = continueButton.center
        
        view.addSubview(activityIndicator)
        

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func tFConfiguration(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 4, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        
    }
    
    private func enableButton(_ state: Bool) {
        if state == true {
            continueButton.alpha = 0.5
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.1
            continueButton.isEnabled = false
        }
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityIndicator.center = continueButton.center
    }
    
    @objc private func tfChanged() {
        
        guard let email = signInTF.text, let password = passwordTF.text else { return }
        let state = !(email.isEmpty) && !(password.isEmpty)
        enableButton(state)
    }
    
    @objc private func handleLogin() {
        
        enableButton(false)
        continueButton.setTitle(" ", for: .normal)
        activityIndicator.startAnimating()
        
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
