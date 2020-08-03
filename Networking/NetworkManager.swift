//
//  NetworkManager.swift
//  Networking
//
//  Created by Roman Oliinyk on 29.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func get(url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    static func post(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let userData = ["Course": "Networking", "School": "Swiftbook.ru"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func downloadImage(imageURL: String, completionHandel: @escaping (_ image: UIImage) -> ()) {
        let urlString = "https://images.hdqwalls.com/wallpapers/gunna-4k-62.jpg"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completionHandel(image)
            }
        }
        task.resume()
    }
    
    
    static func fetchCoursesData(url: String, completion: @escaping (_ courses: [CourseData]) -> ()) {
        guard let url = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let courses = try decoder.decode([CourseData].self, from: data)
                completion(courses)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    static func uploadImage(url: String) {
        
        let image = UIImage(named: "43747.jpg")!
        guard let imageProperties = ImageProperties(with: image, forkey: "image") else { return }
        
        
        guard let url = URL(string: url) else { return }
        
        let httpHeaders = ["Authorization": "Client-ID 7f7ccddf39301a2"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response else { return }
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
    
    
}

