//
//  AppState.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import Foundation

enum AppError: Error {
    case register
    case login
}

enum Route: Hashable {
    case login
    case register
    case home
    case profile
    case test
    case address
    
}

class AppState: ObservableObject{
    @Published var routes: [Route] = []
    @Published var errorWrapper: ErrorWrapper?
}
