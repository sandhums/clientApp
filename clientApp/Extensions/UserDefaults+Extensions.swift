//
//  UserDeafaults+Extensions.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 24/09/23.
//


import Foundation

extension UserDefaults {
    
    var userId: UUID? {
        get {
            guard let userIdAsString = string(forKey: "userId") else {
                           return nil
            }
            return UUID(uuidString: userIdAsString)
        }
        
        set {
            set(newValue?.uuidString, forKey: "userId")
        }
    }
    
}
