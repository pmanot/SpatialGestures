//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import Vision

extension Hand {
    @dynamicMemberLookup
    public struct Finger: Equatable, Identifiable, Sendable {
        public let id: VNHumanHandPoseObservation.JointsGroupName
        public let name: VNHumanHandPoseObservation.JointsGroupName
        public let joints: [VNHumanHandPoseObservation.JointName: Joint]
        
        init(name: VNHumanHandPoseObservation.JointsGroupName, joints: [VNHumanHandPoseObservation.JointName: Joint]) {
            self.id = name
            self.name = name
            self.joints = joints
        }
        
        // Allow subscript access to joints
        subscript(jointName: VNHumanHandPoseObservation.JointName) -> Joint? {
            return joints[jointName]
        }
        
        // Allow dynamic member lookup for joints
        subscript(dynamicMember value: VNHumanHandPoseObservation.JointName) -> Joint? {
            return self.joints[value]
        }
    }
    
    public struct Fingertips: Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let chirality: VNChirality
        public let confidence: VNConfidence
        
        public var thumb: Joint?
        public var index: Joint?
        public var middle: Joint?
        public var ring: Joint?
        public var little: Joint?
    }
}
