//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Roman Oliinyk on 02.07.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?
    
    static func sendRequest(url: String, completion: @escaping (_ courses: [CourseData]) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                var courses = [CourseData]()
                courses = CourseData.getArray(from: value)!
                completion(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseData(url: String) {
        
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let value):
                guard let string = String(data: value, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseString(url: String) {
        
        AF.request(url).responseString { (responseString) in
            switch responseString.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func response(url: String) {
        AF.request(url).response { (response) in
            guard let data = response.data,
                let string = String(data: data, encoding: .utf8)
                else { return }
            print(string)
        }
    }
    
    static func downloadImageWithProgress(largeImageURL: String,
                                          completion: @escaping (_ image: UIImage) -> ()) {
        
        guard let url = URL(string: largeImageURL) else { return }
        print(url)
        
        AF.request(url).validate().downloadProgress { progress in
            print("totalUnitCount: \(progress.totalUnitCount)")
            print("completedUnitCount: \(progress.completedUnitCount)")
            print("fractionCompleted: \(progress.fractionCompleted)")
            print("localizedDescription: \(String(describing: progress.localizedDescription))")
            print("----------------------------------------------")
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }.response { (response) in
            guard let data = response.data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    static func postRequest(url: String,
                            completion: @escaping (_ courses: [CourseData]) -> ()) {
        guard let url = URL(string: url) else { return }
        let userData: [String: Any]  = ["id":2,
                                        "name":"Framework SpriteKit for game development",
                                        "link":"https://swiftbook.ru/contents/spritekit-full-game-dev/",
                                        "imageUrl":"https://swiftbook.ru/wp-content/uploads/2018/03/13-courselogo.jpg",
                                        "number_of_lessons":45,
                                        "number_of_tests":0 ]
        
        AF.request(url, method: .post, parameters: userData).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            print(statusCode)
            
            switch response.result {
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                    let course = CourseData(json: jsonObject) else { return }
                var courses = [CourseData]()
                courses.append(course)
                completion(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
}




