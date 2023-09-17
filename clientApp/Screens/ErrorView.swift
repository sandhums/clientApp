//
//  ErrorView.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 17/09/23.
//

import SwiftUI

struct ErrorView: View {

let errorWrapper: ErrorWrapper

var body: some View {
    VStack {
        Text("Error has occured in the application.")
            .font(.headline)
            .padding([.bottom], 10)
        Text(errorWrapper.error.localizedDescription)
        Text(errorWrapper.guidance)
            .font(.caption)
    }.padding()
}
}


enum SampleError: Error {
    case operationFailed
}
#Preview {
    ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation has failed. Please try again later."))
}
