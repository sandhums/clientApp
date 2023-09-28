//
//  LoginScreen.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    private var isValid: Bool {
        email.isValidEmail && !password.isEmptyOrWhitespace && (password.count >= 6 && password.count <= 12)
    }
    private func login() async {
        do {
            let loginResponseDTO =  try await model.login(email: email, password: password)
            if loginResponseDTO.error {
                //errorMessage = loginResponseDTO.reason ?? ""
                appState.errorWrapper = ErrorWrapper(error: AppError.login, guidance: loginResponseDTO.reason ?? "")
            } else {
                appState.routes.append(.home)
            }
        } catch {
           // errorMessage = error.localizedDescription
            appState.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
           SecureField("Password", text: $password)
            
            HStack {
                Button("Login"){
                    Task {
                        await login()
                    }
                }.buttonStyle(.borderless)
                    .disabled(!isValid)
                Spacer()
                Button("Register"){
                    appState.routes.append(.register)
                }.buttonStyle(.borderless)
            }
           // Text(errorMessage)
        }
        .navigationTitle("Login")
        .navigationBarBackButtonHidden(true)
        .sheet(item: $appState.errorWrapper) { errorWrapper in
            ErrorView(errorWrapper: errorWrapper)
                .presentationDetents([.fraction(0.25)])
        }
    }
}
struct LoginContainerView: View {
    @StateObject private var model = AppModel()
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack(path: $appState.routes){
            LoginScreen()
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
 LoginContainerView()
}
