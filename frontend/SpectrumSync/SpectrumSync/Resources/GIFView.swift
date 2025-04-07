//
// GIFView.swift
// SpectrumSync
//
// Created by Hamidat Bello on 2025-01-12.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper to display a GIF using `UIImageView`.
/// This view uses `UIViewRepresentable` to bridge UIKit with SwiftUI.
struct GIFView: UIViewRepresentable {
    // The name of the GIF file (without the .gif extension).
    let gifName: String

    /// Creates the `UIImageView` to display the GIF.
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Maintain aspect ratio of the GIF
        imageView.loadGif(name: gifName) // Load the GIF
        return imageView
    }

    /// Updates the view when there are changes in SwiftUI.
    /// Not used in this implementation, but required by the protocol.
    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

//
// MARK: - UIImageView Extension for Loading GIFs
//
extension UIImageView {
    /// Loads a GIF from the app bundle and displays it in the `UIImageView`.
    /// - Parameter name: The name of the GIF file (without the .gif extension).
    func loadGif(name: String) {
        // Get the path to the GIF file in the app bundle.
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)

        // Load the GIF data from the file.
        guard let data = try? Data(contentsOf: url) else { return }

        // Create an animated image from the GIF data.
        let gif = UIImage.animatedImage(
            with: UIImage.gifImages(data: data),
            duration: UIImage.gifDuration(data: data)
        )
        self.image = gif
    }
}

//
// MARK: - UIImage Extension for Handling GIF Data
//
extension UIImage {
    /// Extracts individual frames from the GIF data.
    /// - Parameter data: The data of the GIF file.
    /// - Returns: An array of `UIImage` representing the frames of the GIF.
    static func gifImages(data: Data) -> [UIImage] {
        // Create a source from the GIF data.
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return [] }

        var images: [UIImage] = []
        // Loop through each frame in the GIF.
        for i in 0..<CGImageSourceGetCount(source) {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }

    /// Calculates the total duration of the GIF.
    /// - Parameter data: The data of the GIF file.
    /// - Returns: The total duration in seconds for the GIF to play once.
    static func gifDuration(data: Data) -> TimeInterval {
        // Create a source from the GIF data.
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return 0 }

        var duration: TimeInterval = 0
        // Loop through each frame to calculate the total duration.
        for i in 0..<CGImageSourceGetCount(source) {
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let frameDuration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval {
                duration += frameDuration
            }
        }
        return duration
    }
}
