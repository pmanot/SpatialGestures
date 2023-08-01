//
// Copyright (c) Purav Manot
//

import AVFoundation
import Foundation
import SwiftUI
import Vision

public struct StabilizedPointPair: Hashable, Equatable {
    @StabilizedPoint
    public var a: CGPoint?
    @StabilizedPoint
    public var b: CGPoint?
    
    public var distance: CGFloat? {
        guard let a = self.a, let b = self.b else {
            return nil
        }
        
        return a.distance(from: b)
    }
    
    public var position: CGPoint? {
        guard let a = self.a else { return b }
        guard let b = self.b else { return a }
        return (a + b)/2
    }
    
    init(_ hand: Hand?, for groups: (VNHumanHandPoseObservation.JointsGroupName, VNHumanHandPoseObservation.JointsGroupName), in proxy: GeometryProxy) {
        self.a = hand?.fingers[groups.0]?.tip?.location.projectNormalizedToGeometry(in: proxy)
        self.b = hand?.fingers[groups.1]?.tip?.location.projectNormalizedToGeometry(in: proxy)
    }
    
    mutating func update(_ hand: Hand?, for groups: (VNHumanHandPoseObservation.JointsGroupName, VNHumanHandPoseObservation.JointsGroupName), fallback: (VNHumanHandPoseObservation.JointsGroupName, VNHumanHandPoseObservation.JointsGroupName)?, in proxy: GeometryProxy) {
        self.a = hand?.fingers[groups.0]?.tip?.location
        self.b = hand?.fingers[groups.1]?.tip?.location
    }
    
    mutating func update(_ fingertips: Hand.Fingertips?, for fingers: (WritableKeyPath<Hand.Fingertips, Joint?>, WritableKeyPath<Hand.Fingertips, Joint?>), in proxy: GeometryProxy) {
        self.a = fingertips?[keyPath: fingers.0]?.location
        self.b = fingertips?[keyPath: fingers.1]?.location
    }
    
    init() {
        self.a = nil
        self.b = nil
    }
    
    func isPinched(threshold: CGFloat) -> Bool {
        guard let distance = self.distance else {
            //return !(a == nil && b == nil)
            return false
        }
        return (distance < threshold)
    }
}
