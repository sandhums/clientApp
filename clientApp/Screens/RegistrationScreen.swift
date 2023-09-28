//
//  RegistrationScreen.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 16/09/23.
//

import SwiftUI
import AuthenticationServices

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
                appState.errorWrapper = ErrorWrapper(error: AppError.register, guidance: registerResponseDTO.reason ?? "")
                //errorMessage = registerResponseDTO.reason ?? ""
            }
        } catch {
           //errorMessage = error.localizedDescription
            appState.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
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
           // Text(errorMessage)
        }
        SignInWithApple()
          .frame(width: 280, height: 60)
          .onTapGesture(perform: showAppleLogin)

        .navigationTitle("Register")
        .sheet(item: $appState.errorWrapper) { errorWrapper in
                ErrorView(errorWrapper: errorWrapper)
                    .presentationDetents([.fraction(0.25)])
            }
    }
    // You should request only user data which you need. Apple generates a user ID for you. So, if your only purpose in grabbing an email is to have a unique identifier, you don’t truly need it — so don’t ask for it
    private func showAppleLogin() {
      // 1 All sign in requests need an ASAuthorizationAppleIDRequest
      let request = ASAuthorizationAppleIDProvider().createRequest()

      // 2 Specify the type of end user data you need to know.
      request.requestedScopes = [.fullName, .email]

      // 3 Generate the controller which will display the sign in dialog.
//      let controller = ASAuthorizationController(authorizationRequests: [request])
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
    NavigationStack {
       RegistrationContainerView()
    }
}
