//
//  ErrorWrapper.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}
