//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI
import Vision

public struct Joint: Equatable, Identifiable, Hashable, Sendable {
    public let id: VNHumanHandPoseObservation.JointName
    public let name: VNHumanHandPoseObservation.JointName
    let location: CGPoint
    
    init(name: VNHumanHandPoseObservation.JointName, location: CGPoint) {
        self.id = name
        self.name = name
        self.location = location
    }
    
    public func position(in proxy: GeometryProxy, coordinateSpace: CoordinateSpace = .global) -> CGPoint {
        return self.location.projectNormalizedToGeometry(in: proxy, coordinateSpace: coordinateSpace)
    }
    
    public func position(in frame: CGRect) -> CGPoint {
        return self.location.projectNormalizedToRect(in: frame)
    }
}
