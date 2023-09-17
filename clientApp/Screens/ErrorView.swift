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
        HStack {
            Image(systemName: "circle.hexagongrid.fill")
                .symbolRenderingMode(.multicolor)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Oops!! An Error has occurred")
                .font(.headline)
               // .padding([.bottom], 10)
        }
        .padding([.bottom], 10)
        //Text(errorWrapper.error.localizedDescription)
        Text(errorWrapper.guidance)
            .font(.title3)
            .bold()
    }.padding()
}
}


enum SampleError: Error {
    case operationFailed
}
#Preview {
    ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation has failed. Please try again later."))
}
