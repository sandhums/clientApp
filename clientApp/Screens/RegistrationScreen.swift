//
//  RegistrationScreen.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 16/09/23.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    private var isValid: Bool {
        email.isValidEmail && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 12)
    }
    
    private func register() async {
        do {
           let registerResponseDTO = try await model.register(email: email, password: password)
            if !registerResponseDTO.error {
                appState.routes.append(.login)
            } else {
                errorMessage = registerResponseDTO.reason ?? ""
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
           SecureField("Password", text: $password)
            
            HStack {
                Button("Register"){
                    Task {
                        await register()
                    }
                }.buttonStyle(.borderless)
                    .disabled(!isValid)
                Spacer()
                Button("Login") {
                    appState.routes.append(.login)
                }.buttonStyle(.borderless)
            }
            Text(errorMessage)
        }.navigationTitle("Register")
    }
}

struct RegistrationContainerView: View {
    @StateObject private var model = AppModel()
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack(path: $appState.routes){
            RegistrationScreen()
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
    NavigationStack {
       RegistrationContainerView()
    }
}
