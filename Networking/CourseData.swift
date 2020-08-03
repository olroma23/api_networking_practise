//
//  CourseData.swift
//  Networking
//
//  Created by Roman Oliinyk on 22.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

struct CourseData: Codable {
    
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let number_of_lessons: Int?
    let number_of_tests: Int?
    
    init?(json: [String: Any]) {
        
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let number_of_lessons = json["number_of_lessons"] as? Int
        let number_of_tests = json["number_of_tests"] as? Int
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.number_of_lessons = number_of_lessons
        self.number_of_tests = number_of_tests
    }
    
    static func getArray(from jsonArray: Any) -> [CourseData]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var courses = [CourseData]()
        for jsonObject in jsonArray {
            if let course = CourseData(json: jsonObject) {
                courses.append(course)
            }
        }
        return courses
    } 
    
}



