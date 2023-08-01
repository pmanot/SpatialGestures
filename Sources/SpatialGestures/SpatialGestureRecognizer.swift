//
// Copyright (c) Purav Manot
//

import AVFoundation
import Foundation
import SwiftUI

@MainActor
final public class SpatialGestureRecognizer: ObservableObject {
    private var cameraModel: CameraViewModel
    private var poseDetector: HandPoseDetector
    
    @Published public private(set) var detectionStarted: Bool = false
    
    @Published public var handPair: HandPair = HandPair()
    @Published public var fingertips: [Hand.Fingertips] = []
    @Published public var leftStabilizedPointPair = StabilizedPointPair()
    @Published public var rightStabilizedPointPair = StabilizedPointPair()
    
    @Published public var image: Image? = nil
    @Published public var gesture: SpatialGestureRecognizer.Value?
    
    public init() {
        self.cameraModel = CameraViewModel()
        self.poseDetector = HandPoseDetector()
        self.pinchThreshold = 0.1
        self.dragThreshold = 0.01
    }
    
    public var leftPinched: Bool = false
    public var rightPinched: Bool = false
    
    // MARK: - Other Properties
    @Published public var center: CGPoint = .zero
    @Published public var distance: CGFloat = .zero
    
    private var pinchThreshold: CGFloat
    private var dragThreshold: CGFloat
    private var scaleReference: CGFloat = 0
    private var rotationReference: CGFloat = 0
    private var dragStart: CGPoint?
    private var dragEnd: CGPoint?
    private var scaleOngoing: Bool = false
    private var leftTapStarted: Bool = false
    private var rightTapStarted: Bool = false
    
    // MARK: - Public Methods
    public func startDetection(proxy: GeometryProxy) {
        self.detectionStarted = true
        cameraModel.startFeed()
        setCameraOutputHandler(proxy: proxy)
    }
    
    @MainActor
    public func stopDetection() {
        self.detectionStarted = false
        stopCameraFeed()
    }
    
    // MARK: - Private Methods
    private func setCameraOutputHandler(proxy: GeometryProxy) {
        self.cameraModel.outputHandler = { pixelBuffer in
            Task { @MainActor in
                do {
                    let fingertips = try await self.poseDetector.detectFingertips(from: pixelBuffer)
                    self.detect(with: fingertips, in: proxy)
                    var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                    ciImage = ciImage.oriented(.upMirrored)
                    let context: CIContext = CIContext.init(options: nil)
                    let cgImage: CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
                    self.image = Image(image: PlatformImage(cgImage: cgImage))
                } catch {
                    // Handle error
                }
            }
        }
    }
    
    @MainActor
    private func stopCameraFeed() {
        self.cameraModel.stopFeed()
        self.cameraModel.outputHandler = nil
    }
    
    @MainActor
    private func detect(with fingertips: [Hand.Fingertips], in proxy: GeometryProxy, deltaTime: TimeInterval? = nil) {
        self.fingertips = fingertips
        for fingers in fingertips {
            switch fingers.chirality {
                case .left:
                    self.leftStabilizedPointPair.update(fingers, for: (\Hand.Fingertips.index, \Hand.Fingertips.thumb), in: proxy)
                case .right:
                    self.rightStabilizedPointPair.update(fingers, for: (\Hand.Fingertips.index, \Hand.Fingertips.thumb), in: proxy)
                default:
                    return
            }
        }
        
        
        self.leftPinched = leftStabilizedPointPair.isPinched(threshold: pinchThreshold)
        self.rightPinched = rightStabilizedPointPair.isPinched(threshold: pinchThreshold)
        
        if let leftPosition = self.leftStabilizedPointPair.position, let rightPosition = self.rightStabilizedPointPair.position {
            self.distance = abs(leftPosition.distance(from: rightPosition))
            self.center = (leftPosition + rightPosition) / 2
        }
        
        switch gesture {
            case .scale(_, _):
                handleScaleGesture()
            default:
                handleTapGesture()
        }
    }
    
    private func handleScaleGesture() {
        switch (self.leftPinched, self.rightPinched) {
            case (false, false):
                self.gesture = nil
            default:
                var angle: Double = 0
                if let leftPosition = self.leftStabilizedPointPair.position, let rightPosition = self.rightStabilizedPointPair.position {
                    angle = calculateAngle(leftPosition, rightPosition)
                }
                self.gesture = .scale(scale: distance/scaleReference, rotation: angle - rotationReference)
                self.rightTapStarted = false
                self.leftTapStarted = false
        }
    }
    
    
    
    private func handleTapGesture() {
        switch (self.leftPinched, self.rightPinched) {
            case (true, false):
                self.leftTapStarted = true
                //self.gesture = .leftTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
                if rightTapStarted {
                    self.gesture = .rightTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
                    self.rightTapStarted = false
                }
            case (false, true):
                self.rightTapStarted = true
                if self.leftTapStarted {
                    self.gesture = .leftTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
                    self.leftTapStarted = false
                }
                //self.gesture = .rightTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
            case (true, true):
                self.scaleReference = self.distance
                var angle: Double = 0
                if let leftPosition = self.leftStabilizedPointPair.position, let rightPosition = self.rightStabilizedPointPair.position {
                    angle = calculateAngle(leftPosition, rightPosition)
                    self.rotationReference = angle
                }
                self.gesture = .scale(scale: 1.0, rotation: 0)
            default:
                self.gesture = nil
                
                if rightTapStarted {
                    self.gesture = .rightTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
                    self.rightTapStarted = false
                }
                
                if self.leftTapStarted {
                    self.gesture = .leftTap(left: self.leftStabilizedPointPair.position, right: self.rightStabilizedPointPair.position)
                    self.leftTapStarted = false
                }
        }
    }
}

extension SpatialGestureRecognizer {
    public enum Value: Equatable {
        case leftTap(left: CGPoint?, right: CGPoint?)
        case rightTap(left: CGPoint?, right: CGPoint?)
        case dualTap(left: CGPoint?, right: CGPoint?)
        case scale(scale: CGFloat, rotation: Double)
        case drag(startPoint: CGPoint, endPoint: CGPoint)
        
        public var description: String {
            switch self {
                case .leftTap(_, _):
                    return ("left tap")
                case .rightTap(_, _):
                    return ("right tap")
                case .dualTap(_, _):
                    return ("dual tap")
                case .scale(let scale, _):
                    return ("scale \(scale)")
                default:
                    return ""
            }
        }
    }
    
    public enum _Value: Equatable {
        case tapStarted(data: TapData)
        case tapEnded(data: TapData)
        case dragStarted(data: DragData)
        case dragOngoing(data: DragData)
        case dragEnded(data: DragData)
        case scaleStarted(data: ScaleData)
        case scaleOngoing(data: ScaleData)
        case scaleEnded(data: ScaleData)
    }
    
    public enum GestureType: Equatable {
        case drag
        case tap
        case scale
        case hold
    }
    
    public struct TapData: Equatable {
        public var chirality: Chirality
        public var location: CGPoint
    }
    
    public struct DragData: Equatable {
        public var chirality: Chirality
        public var location: CGPoint
    }
    
    public struct ScaleData: Equatable {
        public var location: CGPoint
        public var rotation: CGFloat
        public var scale: CGFloat
    }
    
    public enum Chirality: Equatable {
        case left
        case right
    }
}
