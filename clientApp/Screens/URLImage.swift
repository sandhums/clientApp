//
//  URLImage.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 26/09/23.
//

import Foundation
import SwiftUI

struct URLImage: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    let url: URL?
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        VStack {
            if let uiImage = imageLoader.uiImage {
                Image(uiImage: uiImage)
            } else {
                ProgressView("Loading...")
            }
        }.task {
            await downloadImage()
        }
    }
    
    private func downloadImage() async {
        do {
            try await imageLoader.fetchImage(url)
        } catch {
            print(error)
        }
    }
    
}


