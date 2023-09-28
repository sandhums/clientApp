//
//  UIImage+extensions.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 24/09/23.
//

import Foundation
import SwiftUI

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(100)
        resizedImage.jpegData(compressionQuality: 0.7) // Add this line
        
        return resizedImage
    }
}
