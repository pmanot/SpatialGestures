//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

protocol PlatformViewRepresentable: PlatformViewRepresentableType {
    func makeView(context: Context) -> PlatformView
    func updateView(_ view: PlatformView, context: Context)
}

#if os(macOS)

import AppKit

typealias PlatformImage = NSImage
typealias PlatformView = NSView
typealias PlatformViewController = NSViewController
typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
typealias PlatformViewControllerType = NSViewController
typealias PlatformViewRepresentableType = NSViewRepresentable

extension PlatformViewRepresentable {
    func makeNSView(context: Context) -> PlatformView {
        makeView(context: context)
    }
    
    func updateNSView(_ nsView: PlatformView, context: Context) {
        updateView(nsView, context: context)
    }
}

#else

import UIKit

typealias PlatformImage = UIImage
typealias PlatformView = UIView
typealias PlatformViewController = UIViewController
typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
typealias PlatformViewControllerType = UIViewController
typealias PlatformViewRepresentableType = UIViewRepresentable

extension PlatformViewRepresentable {
    func makeUIView(context: Context) -> PlatformView {
        makeView(context: context)
    }
    
    func updateUIView(_ uiView: PlatformView, context: Context) {
        updateView(uiView, context: context)
    }
}

#endif

#if os(macOS)
extension PlatformImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: .zero)
    }
}
#endif

extension Image {
    init(image: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: image)
        #else
        self.init(uiImage: image)
        #endif
    }
}
