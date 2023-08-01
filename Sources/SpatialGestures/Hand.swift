//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import Vision

@dynamicMemberLookup
public struct Hand: Equatable, Identifiable, Sendable {
    public let id = UUID()
    public let chirality: VNChirality
    public var fingers: [VNHumanHandPoseObservation.JointsGroupName: Finger]
    
    // Allow subscript access to fingers
    subscript(jointsGroupName: VNHumanHandPoseObservation.JointsGroupName) -> Finger? {
        return fingers[jointsGroupName]
    }
    
    // Allow dynamic member lookup for fingers
    subscript(dynamicMember value: VNHumanHandPoseObservation.JointsGroupName) -> Finger? {
        return self.fingers[value]
    }
    
    // Computed properties to access the finger dictionary values directly
    public var thumb: Finger? {
        return fingers[.thumb]
    }
    
    public var indexFinger: Finger? {
        return fingers[.indexFinger]
    }
    
    public var middleFinger: Finger? {
        return fingers[.middleFinger]
    }
    
    public var ringFinger: Finger? {
        return fingers[.ringFinger]
    }
    
    public var littleFinger: Finger? {
        return fingers[.littleFinger]
    }
}

// MARK: - Extensions

extension VNHumanHandPoseObservation.JointsGroupName {
    // Return the tip joint name for each finger group
    var tip: VNHumanHandPoseObservation.JointName {
        switch self {
        case .thumb:
            return .thumbTip
        case .indexFinger:
            return .indexTip
        case .middleFinger:
            return .middleTip
        case .ringFinger:
            return .ringTip
        case .littleFinger:
            return .littleTip
        default:
            return .wrist
        }
    }
}

extension Hand {
    // Computed properties to access the finger tip joints directly
    var thumbTip: Joint? {
        return self[.thumb]?.tip
    }
    
    var indexTip: Joint? {
        return self[.indexFinger]?.tip
    }
    
    var middleTip: Joint? {
        return self[.middleFinger]?.tip
    }
    
    var ringTip: Joint? {
        return self[.ringFinger]?.tip
    }
    
    var littleTip: Joint? {
        return self[.littleFinger]?.tip
    }
}

extension Hand.Finger {
    // Computed property to access the finger's tip joint
    var tip: Joint? {
        return self[self.name.tip]
    }
}

extension HandPair {
    // Convenient properties to access finger tip joints of a hand pair
    var leftThumbTip: Joint? {
        return left?.thumbTip
    }
    
    var rightThumbTip: Joint? {
        return right?.thumbTip
    }
    
    var leftIndexTip: Joint? {
        return left?.indexTip
    }
    
    var rightIndexTip: Joint? {
        return right?.indexTip
    }
    
    var leftMiddleTip: Joint? {
        return left?.middleTip
    }
    
    var rightMiddleTip: Joint? {
        return right?.middleTip
    }
    
    var leftRingTip: Joint? {
        return left?.ringTip
    }
    
    var rightRingTip: Joint? {
        return right?.ringTip
    }
    
    var leftLittleTip: Joint? {
        return left?.littleTip
    }
    
    var rightLittleTip: Joint? {
        return right?.littleTip
    }
}

public struct HandPair: Equatable {
    public var left: Hand?
    public var right: Hand?
    
    public init(_ hands: [Hand] = []) {
        for hand in hands {
            switch hand.chirality {
                case .left:
                    self.left = hand
                case .right:
                    self.right = hand
                case .unknown:
                    self.left = hand
            }
        }
    }
    
    public var hands: [Hand] {
        [self.left, self.right].compactMap { $0 }
    }
    
    public var isEmpty: Bool {
        (self.left == nil && self.right == nil)
    }
}
