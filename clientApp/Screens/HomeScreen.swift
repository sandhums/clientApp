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
    var image: Image?
    
   
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
            appState.routes.append(.test)
        } label: {
            Image(systemName: "person.badge.plus")
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Logout") {
                    model.logout()
                    appState.routes.append(.login)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            appState.routes.append(.profile)
                        } label: {
                            Image(systemName: "person.badge.plus")
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
                    case .profile:
                        UpdateProfileView()
                    case .address:
                        UpdateAddressView()
                    case .test:
                        Test()
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
