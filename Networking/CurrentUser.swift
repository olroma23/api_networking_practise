//
//  CurrentUser.swift
//  Networking
//
//  Created by Roman Oliinyk on 11.07.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import Foundation

struct CurrentUser {
    
    let uid: String?
    let name: String?
    let email: String?
    
    init?(uid: String, data: [String: Any]) {
        
        guard let name = data["name"] as? String,
            let email = data["email"] as? String
            else { return nil }
        
        self.uid = uid
        self.name = name
        self.email = email
    }
}
