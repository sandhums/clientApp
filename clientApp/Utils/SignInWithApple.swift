//
//  SignInWithApple.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

// 1 You subclass UIViewRepresentable when you need to wrap a UIView. was a class, crashed changed to struct
struct SignInWithApple: UIViewRepresentable {
  // 2 makeUIView should always return a specific type of UIView.
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    // 3 Since you’re not performing any customization, you return the Sign In with Apple object directly.
      return ASAuthorizationAppleIDButton(type: .continue, style: .white)
  }
  
  // 4 Since the view’s state never changes, leave an empty implementation
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}
