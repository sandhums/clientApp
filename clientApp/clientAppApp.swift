//
//  clientAppApp.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 15/09/23.
//

import SwiftUI

@main
struct clientAppApp: App {
    
    @StateObject private var model = AppModel()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                RegistrationScreen()
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
                        }
                    }
            }
            .environmentObject(model)
            .environmentObject(appState)
        }
    }
}
