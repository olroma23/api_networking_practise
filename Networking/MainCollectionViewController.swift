//
//  MainCollectionViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 29.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UserNotifications
import UIKit
import FBSDKLoginKit
import FirebaseAuth

// with CaseIterable, it's possible to create array with enums cases

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download image"
    case get = "Get"
    case post = "Post"
    case ourCourses = "Our courses"
    case uploadImage = "Upload image"
    case downloadFile = "Download file"
    case ourCoursesAlamofire = "Our courses Alamofire"
    case downloadImageByAlamofire = "Download image by Alamofire"
    case responseData = "Resonse data"
    case responseString = "Response string"
    case largeImageDownload = "Downloading large image"
    case postAlamofire = "Post request with alamofire"
    case putRequest = "Put request with alamofire"
    case uploadImageWithAlamofire = "Upload image with alamofire"
    
}

private let reuseIdentifier = "Button"

class MainCollectionViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let uploadURL = "https://api.imgur.com/3/image"
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    private var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfLogged()
        
        registerForNotification()
        
        dataProvider.fileLocation = { location in
            // save file for future using
            print("Donwloading is finished: \(location.absoluteString)" )
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: true, completion: nil)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view as Any,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dataProvider.stopDownload()
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width/2 - size.width/2,
                                y: self.alert.view.frame.height/2 - size.height/2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 45, width: self.alert.view.frame.width, height: 1))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let action = actions[indexPath.row]
        cell.label.text = action.rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let action = actions[indexPath.row]
        cell.label.text = action.rawValue
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.get(url: url)
        case .post:
            NetworkManager.post(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadURL)
        case .downloadFile:
            showAlert()
            dataProvider.startDownloading()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamofire", sender: self)
        case .downloadImageByAlamofire:
            performSegue(withIdentifier: "ShowImageByAlamofire", sender: self)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: url)
        case .responseData:
            AlamofireNetworkRequest.responseData(url: url)
        case .largeImageDownload:
            performSegue(withIdentifier: "ShowLargeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "PostWithAlamofire", sender: self)
        case .putRequest:
            performSegue(withIdentifier: "PutRequest", sender: self)
        case .uploadImageWithAlamofire:
            break;
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let coursesVC = segue.destination as? CoursesTableViewController
        let imageVC = segue.destination as? ViewController
        
        switch segue.identifier {
        case "OurCourses":
            coursesVC?.fetchData()
        case "OurCoursesWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "ShowImage":
            imageVC?.fetchImage()
        case "ShowImageByAlamofire":
            imageVC?.fetchDataWithAlamofire()
        case "ShowLargeImage":
            imageVC?.fetchLargeImage()
        case "PostWithAlamofire":
            coursesVC?.postRequestAlamofire()
        default:
            break;
        }
    }
}

// MARK: UICollectionViewDelegate

extension MainCollectionViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Downloading is finished"
        content.body = "Your background transfer is completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferCompleted", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension MainCollectionViewController {
    private func checkIfLogged() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                return
            }
        }
        
        //        if let token = AccessToken.current,
        //            token.isExpired {
        //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //                self.present(loginViewController, animated: true)
        //                return
        //
        //        }
    }
}


