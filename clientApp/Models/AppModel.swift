//
//  AppModel.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 16/09/23.
//

import Foundation
import SwiftUI
import HISSharedDTO

@MainActor
class AppModel: ObservableObject {
    
    @Published var userProfile: UserUpdateDTO?
    @Published var userAddress: UserAddressDTO?
    @Published var uiImage: UIImage?
    private static let cache = NSCache<NSString, UIImage>()
    
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
    func populateUserProfile() async throws {
        
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = Resource(url: Constants.Urls.getUserProfile(userId: userId), modelType: UserUpdateDTO.self)
        print(resource.url.absoluteString)
        
        userProfile = try await httpClient.load(resource)
    }
    
    func updateUserProfile(_ userUpdateDTO: UserUpdateDTO) async throws {
        
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = try Resource(url: Constants.Urls.updateUserFor(userId: userId), method: .patch(JSONEncoder().encode(userUpdateDTO)), modelType: UserUpdateDTO.self)
        
        _ = try await httpClient.load(resource)
        // add new grocery to the list
        
    }
    func getUserAddress() async throws {
        
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = Resource(url: Constants.Urls.getUserAddress(userId: userId), modelType: UserAddressDTO.self)
        print(resource.url.absoluteString)
        
        userAddress = try await httpClient.load(resource)
    }
    func saveUserAddress(_ userAddressDTO: UserAddressDTO) async throws {
        
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = try Resource(url: Constants.Urls.getUserAddress(userId: userId), method: .post(JSONEncoder().encode(userAddressDTO)), modelType: UserAddressDTO.self)
        print(resource.url.absoluteString)
        
        _ = try await httpClient.load(resource)
    }
    func updateUserAddress(_ userAddressDTO: UserAddressDTO) async throws {
        
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = try Resource(url: Constants.Urls.getUserAddress(userId: userId), method: .put(JSONEncoder().encode(userAddressDTO)), modelType: UserAddressDTO.self)
        print(resource.url.absoluteString)
        
        _ = try await httpClient.load(resource)
    }
}
