//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import Vision

public struct Joint: Equatable, Identifiable, Sendable {
    public let id: VNHumanHandPoseObservation.JointName
    public let name: VNHumanHandPoseObservation.JointName
    public let location: CGPoint
    
    init(name: VNHumanHandPoseObservation.JointName, location: CGPoint) {
        self.id = name
        self.name = name
        self.location = location
    }
}
