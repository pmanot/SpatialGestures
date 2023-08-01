//
// Copyright (c) Purav Manot
//

import Foundation
import Vision

extension VNHumanHandPoseObservation.JointName: ExpressibleByStringLiteral, CustomStringConvertible {
    public init(stringLiteral value: String) {
        switch value {
            case "wrist": self = .wrist
            case "thumbCMC": self = .thumbCMC
            case "thumbMP": self = .thumbMP
            case "thumbIP": self = .thumbIP
            case "thumbTip": self = .thumbTip
            case "indexMCP": self = .indexMCP
            case "indexPIP": self = .indexPIP
            case "indexDIP": self = .indexDIP
            case "indexTip": self = .indexTip
            case "middleMCP": self = .middleMCP
            case "middlePIP": self = .middlePIP
            case "middleDIP": self = .middleDIP
            case "middleTip": self = .middleTip
            case "ringMCP": self = .ringMCP
            case "ringPIP": self = .ringPIP
            case "ringDIP": self = .ringDIP
            case "ringTip": self = .ringTip
            case "littleMCP": self = .littleMCP
            case "littlePIP": self = .littlePIP
            case "littleDIP": self = .littleDIP
            case "littleTip": self = .littleTip
            default: self.init(rawValue: .init(rawValue: value))
        }
    }
    
    public var description: String {
        switch self {
            case .wrist: return "wrist"
            case .thumbCMC: return "thumbCMC"
            case .thumbMP: return "thumbMP"
            case .thumbIP: return "thumbIP"
            case .thumbTip: return "thumbTip"
            case .indexMCP: return "indexMCP"
            case .indexPIP: return "indexPIP"
            case .indexDIP: return "indexDIP"
            case .indexTip: return "indexTip"
            case .middleMCP: return "middleMCP"
            case .middlePIP: return "middlePIP"
            case .middleDIP: return "middleDIP"
            case .middleTip: return "middleTip"
            case .ringMCP: return "ringMCP"
            case .ringPIP: return "ringPIP"
            case .ringDIP: return "ringDIP"
            case .ringTip: return "ringTip"
            case .littleMCP: return "littleMCP"
            case .littlePIP: return "littlePIP"
            case .littleDIP: return "littleDIP"
            case .littleTip: return "littleTip"
            default: return self.rawValue.rawValue
        }
    }
}

extension VNHumanHandPoseObservation.JointsGroupName: ExpressibleByStringLiteral, CustomStringConvertible {
    public init(stringLiteral value: String) {
        switch value {
            case "thumb": self = .thumb
            case "indexFinger": self = .indexFinger
            case "middleFinger": self = .middleFinger
            case "ringFinger": self = .ringFinger
            case "littleFinger": self = .littleFinger
            case "all": self = .all
            default: self.init(rawValue: .init(rawValue: value))
        }
    }
    
    public var description: String {
        switch self {
            case .thumb: return "thumb"
            case .indexFinger: return "indexFinger"
            case .middleFinger: return "middleFinger"
            case .ringFinger: return "ringFinger"
            case .littleFinger: return "littleFinger"
            case .all: return "all"
            default: return self.rawValue.rawValue
        }
    }
}
