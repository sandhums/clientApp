//
//  AppModel.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 16/09/23.
//

import Foundation

class AppModel: ObservableObject {
    
    let httpClient = HTTPClient()
    
    func register(email: String, password: String) async throws -> RegisterResponseDTO {
        
        // MARK: TODO - create a separate model/struct for register/logindata request
        let registerData = ["email": email, "password": password]
        let resource = try Resource(url: Constants.Urls.register, method: .post(JSONEncoder().encode(registerData)), modelType: RegisterResponseDTO.self)
        let registerResponseDTO = try await httpClient.load(resource)
        return registerResponseDTO
    }
    
    func login(email: String, password: String) async throws -> LoginResponseDTO {
        
        let loginPostData = ["email": email, "password": password]
        
        // resource
        let resource = try Resource(url: Constants.Urls.login, method: .post(JSONEncoder().encode(loginPostData)), modelType: LoginResponseDTO.self)
        
        let loginResponseDTO = try await httpClient.load(resource)
        
        if !loginResponseDTO.error && loginResponseDTO.token != nil && loginResponseDTO.userId != nil {
            // save the token in user defaults
            let defaults = UserDefaults.standard
            defaults.set(loginResponseDTO.token!, forKey: "authToken")
            defaults.set(loginResponseDTO.userId!.uuidString, forKey: "userId")
        }
        
        return loginResponseDTO
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "authToken")
    }
}
