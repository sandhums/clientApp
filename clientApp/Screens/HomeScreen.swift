//
//  HomeScreen.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle("Home")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        model.logout()
                        appState.routes.append(.login)
                    }
                    
                }
            }
    }
}

struct HomeContainerView: View {
    @StateObject private var model = AppModel()
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack(path: $appState.routes){
            HomeScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .register:
                        RegistrationScreen()
                    case .login:
                        LoginScreen()
                    case .home:
                        HomeScreen()
                    }
                }
        }
        .environmentObject(AppModel())
        .environmentObject(AppState())
    }
}

#Preview {
   HomeContainerView()
}
