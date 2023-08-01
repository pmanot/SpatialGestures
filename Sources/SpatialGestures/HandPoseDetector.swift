//
// Copyright (c) Purav Manot
//

import AVFoundation
import Foundation
import Combine
import SwiftUI
import Vision

class HandPoseDetector: @unchecked Sendable {
    init() {
        
    }
    
    func detect(from image: CIImage, maximumHandCount: Int = 2) async throws -> [Hand] {
        let request = VNDetectHumanHandPoseRequest()
        request.revision = VNDetectHumanHandPoseRequestRevision1
        request.maximumHandCount = maximumHandCount
        
        return try await performDetection(request: request, image: image)
    }
    
    func detect(from image: CIImage, maximumHandCount: Int = 2) throws -> [Hand] {
        let request = VNDetectHumanHandPoseRequest()
        request.revision = VNDetectHumanHandPoseRequestRevision1
        request.maximumHandCount = maximumHandCount
        
        return try performDetection(request: request, image: image)
    }
    
    func detect(from image: CGImage, maximumHandCount: Int = 2) async throws -> [Hand] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try await performDetection(request: request, image: image)
    }
    
    func detect(from pixelBuffer: CVImageBuffer, maximumHandCount: Int = 2) async throws -> [Hand] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try await performDetection(request: request, pixelBuffer: pixelBuffer)
    }
    
    func detect(from pixelBuffer: CVImageBuffer, maximumHandCount: Int = 2) throws -> [Hand] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try performDetection(request: request, pixelBuffer: pixelBuffer)
    }
    
    private func performDetection(request: VNDetectHumanHandPoseRequest, pixelBuffer: CVImageBuffer) async throws -> [Hand] {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let hands = try await processResults(results)
        
        return hands
    }
    
    private func performDetection(request: VNDetectHumanHandPoseRequest, pixelBuffer: CVImageBuffer) throws -> [Hand] {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let hands = try processResults(results)
        
        return hands
    }
    
    private func performDetection(request: VNDetectHumanHandPoseRequest, image: CIImage) async throws -> [Hand] {
        let handler = VNImageRequestHandler(ciImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let hands = try await processResults(results)
        
        return hands
    }
    
    private func performDetection(request: VNDetectHumanHandPoseRequest, image: CIImage) throws -> [Hand] {
        let handler = VNImageRequestHandler(ciImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let hands = try processResults(results)
        
        return hands
    }
    
    private func performDetection(request: VNDetectHumanHandPoseRequest, image: CGImage) async throws -> [Hand] {
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let hands = try await processResults(results)
        
        return hands
    }
    
    private func processResults(_ results: [VNHumanHandPoseObservation]) async throws -> [Hand] {
        var hands: [Hand] = []
        
        await withTaskGroup(of: Hand.self) { taskGroup in
            for result in results {
                if result.confidence > 0.5 {
                    taskGroup.addTask {
                        return self.createHand(from: result)
                    }
                }
            }
            
            for await hand in taskGroup {
                hands.append(hand)
            }
        }
        
        return hands
    }
    
    private func processResults(_ results: [VNHumanHandPoseObservation]) throws -> [Hand] {
        var hands: [Hand] = []
        
        for result in results {
            hands.append(self.createHand(from: result))
        }
        
        return hands
    }
    
    private func createHand(from result: VNHumanHandPoseObservation) -> Hand {
        let chirality = result.chirality
        
        let fingers = result.availableJointsGroupNames.compactMap { jointsGroupName -> (VNHumanHandPoseObservation.JointsGroupName, Hand.Finger)? in
            guard let dict = try? result.recognizedPoints(jointsGroupName) else { return nil }
            
            let joints = dict.compactMap { (key, value) -> (VNHumanHandPoseObservation.JointName, Joint)? in
                guard value.confidence > 0.5 else { return nil }
                return (key, Joint(name: key, location: value.location))
            }
            
            return (jointsGroupName, Hand.Finger(name: jointsGroupName, joints: Dictionary(uniqueKeysWithValues: joints)))
        }
        
        return Hand(chirality: chirality, fingers: Dictionary(uniqueKeysWithValues: fingers))
    }
}

extension HandPoseDetector {
    func detectFingertips(from image: CIImage, maximumHandCount: Int = 2) async throws -> [Hand.Fingertips] {
        let request = VNDetectHumanHandPoseRequest()
        request.revision = VNDetectHumanHandPoseRequestRevision1
        request.maximumHandCount = maximumHandCount
        
        return try await performFingertipsDetection(request: request, image: image)
    }
    
    func detectFingertips(from image: CIImage, maximumHandCount: Int = 2) throws -> [Hand.Fingertips] {
        let request = VNDetectHumanHandPoseRequest()
        request.revision = VNDetectHumanHandPoseRequestRevision1
        request.maximumHandCount = maximumHandCount
        
        return try performFingertipsDetection(request: request, image: image)
    }
    
    func detectFingertips(from image: CGImage, maximumHandCount: Int = 2) async throws -> [Hand.Fingertips] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try await performFingertipsDetection(request: request, image: image)
    }
    
        func detectFingertips(from pixelBuffer: CVImageBuffer, maximumHandCount: Int = 2) async throws -> [Hand.Fingertips] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try await performFingertipsDetection(request: request, pixelBuffer: pixelBuffer)
    }
    
    func detectFingertips(from pixelBuffer: CVImageBuffer, maximumHandCount: Int = 2) throws -> [Hand.Fingertips] {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = maximumHandCount
        
        return try performFingertipsDetection(request: request, pixelBuffer: pixelBuffer)
    }
    
    private func performFingertipsDetection(request: VNDetectHumanHandPoseRequest, pixelBuffer: CVImageBuffer) async throws -> [Hand.Fingertips] {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let fingertips = try await processFingertipsResults(results)
        
        return fingertips
    }
    
    private func performFingertipsDetection(request: VNDetectHumanHandPoseRequest, pixelBuffer: CVImageBuffer) throws -> [Hand.Fingertips] {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let fingertips = try processFingertipsResults(results)
        
        return fingertips
    }
    
    private func performFingertipsDetection(request: VNDetectHumanHandPoseRequest, image: CIImage) async throws -> [Hand.Fingertips] {
        let handler = VNImageRequestHandler(ciImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let fingertips = try await processFingertipsResults(results)
        
        return fingertips
    }
    
    private func performFingertipsDetection(request: VNDetectHumanHandPoseRequest, image: CIImage) throws -> [Hand.Fingertips] {
        let handler = VNImageRequestHandler(ciImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let fingertips = try processFingertipsResults(results)
        
        return fingertips
    }
    
    private func performFingertipsDetection(request: VNDetectHumanHandPoseRequest, image: CGImage) async throws -> [Hand.Fingertips] {
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
        try handler.perform([request])
        
        guard let results = request.results else { return [] }
        
        let fingertips = try await processFingertipsResults(results)
        
        return fingertips
    }
    
    private func processFingertipsResults(_ results: [VNHumanHandPoseObservation]) async throws -> [Hand.Fingertips] {
        var fingertips: [Hand.Fingertips] = []
        
        await withTaskGroup(of: Hand.Fingertips.self) { taskGroup in
            for result in results {
                if result.confidence > 0.5 {
                    taskGroup.addTask {
                        return self.createFingertips(from: result)
                    }
                }
            }
            
            for await fingertip in taskGroup {
                fingertips.append(fingertip)
            }
        }
        
        return fingertips
    }
    
    private func processFingertipsResults(_ results: [VNHumanHandPoseObservation]) throws -> [Hand.Fingertips] {
        var fingertips: [Hand.Fingertips] = []
        
        for result in results {
            fingertips.append(self.createFingertips(from: result))
        }
        
        return fingertips
    }
    
    private func createFingertips(from result: VNHumanHandPoseObservation) -> Hand.Fingertips {
        let chirality = result.chirality
        
        var fingertips = Hand.Fingertips(chirality: chirality)
        
        if result.confidence > 0.5 {
            if let thumbPoint = try? result.recognizedPoint(.thumbTip) {
                fingertips.thumb = Joint(name: .thumbTip, location: thumbPoint.location)
            }
            
            if let indexPoint = try? result.recognizedPoint(.indexTip) {
                fingertips.index = Joint(name: .indexTip, location: indexPoint.location)
            }
            
            if let middlePoint = try? result.recognizedPoint(.middleTip) {
                fingertips.middle = Joint(name: .middleTip, location: middlePoint.location)
            }
            
            if let ringPoint = try? result.recognizedPoint(.ringTip) {
                fingertips.ring = Joint(name: .ringTip, location: ringPoint.location)
            }
            
            if let littlePoint = try? result.recognizedPoint(.littleTip) {
                fingertips.little = Joint(name: .littleTip, location: littlePoint.location)
            }
        }
        
        return fingertips
    }
}


public extension VNRecognizedPoint {
    func convertToCGPoint(in proxy: GeometryProxy) -> CGPoint {
        var transformedPoint = CGPoint(x: self.location.x * proxy.frame(in: .global).width,
                                       y: (1 - self.location.y) * proxy.frame(in: .global).height)
        
        transformedPoint.x = proxy.frame(in: .global).maxX - transformedPoint.x
        
        
        return transformedPoint
    }
}

public extension CGPoint {
    func projectNormalizedToGeometry(in proxy: GeometryProxy, mirrored: Bool = true) -> CGPoint {
        //let point = CGPoint(x: self.x.modulate(fromRange: 0.1...0.9, toRange: 0...1), y: self.y.modulate(fromRange: 0.1...0.9, toRange: 0...1))
        let point = self
        
        if mirrored {
            return CGPoint(x: (1 - point.x) * proxy.frame(in: .global).width,
                           y: (1 - point.y) * proxy.frame(in: .global).height)
        } else {
            return CGPoint(x: point.x * proxy.frame(in: .global).width,
                           y: (1 - point.y) * proxy.frame(in: .global).height)
        }
    }
}

public extension CGFloat {
    func modulate(fromRange: ClosedRange<CGFloat>, toRange: ClosedRange<CGFloat>) -> CGFloat {
        let fromMin = fromRange.lowerBound
        let fromMax = fromRange.upperBound
        let toMin = toRange.lowerBound
        let toMax = toRange.upperBound
        
        let normalizedValue = (self - fromMin) / (fromMax - fromMin)
        let modulatedValue = (normalizedValue * (toMax - toMin)) + toMin
        
        return modulatedValue.clamped(to: toRange)
    }
}

public extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

