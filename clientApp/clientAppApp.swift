//
//  clientAppApp.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 15/09/23.
//

import SwiftUI
import Firebase

@main
struct clientAppApp: App {
   
    @StateObject private var model = AppModel()
    @StateObject private var appState = AppState()
    init() {
    FirebaseApp.configure()
    }
    
    var body: some Scene {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "authToken")
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                Group {
                    if token == nil {
                        RegistrationScreen()
                    } else {
                        HomeScreen()
                    }
                }
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            LoginScreen()
                        case .register:
                            RegistrationScreen()
                        case .home:
                            HomeScreen()
                        case .profile:
                            UpdateProfileView()
                        case .address:
                            UpdateAddressView()
                        case .test:
                            Test()
                        }
                    }
            }
            .environmentObject(model)
            .environmentObject(appState)
        }
    }
}
