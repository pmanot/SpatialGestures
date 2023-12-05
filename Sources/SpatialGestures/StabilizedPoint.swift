//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

@propertyWrapper
public struct StabilizedPoint: DynamicProperty, Hashable, Equatable {
    let frameCountThreshold: Int = 10
    let movementThreshold: CGFloat = 5

    var previousPoints: [CGPoint] = []
    private var value: CGPoint?

    public var wrappedValue: CGPoint? {
        get { value }
        set { setValue(newValue) }
    }

    public init(wrappedValue: CGPoint?) {
        self.value = wrappedValue
    }

    mutating private func setValue(_ newValue: CGPoint?) {
        let previousValue = value

        guard let newValue = newValue else { value = newValue; return }
        guard let oldValue = previousValue else { value = newValue; return }

        if previousPoints.count < frameCountThreshold {
            previousPoints.append(newValue)
        } else {
            previousPoints = []
            previousPoints.append(newValue)
        }

        let averagePoint = previousPoints.reduce(.zero, +) / CGFloat(previousPoints.count)

        if abs(oldValue.distance(from: newValue)) > movementThreshold {
            previousPoints = [newValue]
            print("NEW VALUE \(newValue)")
            value = newValue
        } else {
            value = averagePoint
        }
    }
}
