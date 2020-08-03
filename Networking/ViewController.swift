//
//  ViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 18.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let imageURL = "https://images.hdqwalls.com/wallpapers/gunna-4k-62.jpg"
    let largeImageURL = "https://wallpaperaccess.com/full/709225.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        completionLabel.isHidden = true
        progressView.isHidden = true
    }
    
    
    func fetchImage() {
            
        NetworkManager.downloadImage(imageURL: imageURL) { (image) in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchDataWithAlamofire() {
                
        AF.request(imageURL).validate().responseData { (responseData) in
            
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.activityIndicator.startAnimating()
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchLargeImage() {
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.completionLabel.text = completed
        }
        
        AlamofireNetworkRequest.downloadImageWithProgress(largeImageURL: largeImageURL) { (image) in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            self.completionLabel.isHidden = true
            self.progressView.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.completionLabel.isHidden = false
            self.progressView.isHidden = false
        }
    }
}

