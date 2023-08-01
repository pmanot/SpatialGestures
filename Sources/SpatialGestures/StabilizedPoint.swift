//
// Copyright (c) Purav Manot
//

import Foundation
import SwiftUI

@propertyWrapper
public struct StabilizedPoint {
    /// Maximum number of values to average out.
    private let sampleSize: Int = 5
    /// Minimum delta required to clear the average and set a new value.
    private let minimumDelta: CGFloat = 2

    private var previousPoints: [CGPoint] = []
    private var value: CGPoint?
    
    public var wrappedValue: CGPoint? {
        get {
            value
        } set {
            updateValue(oldValue: value, newValue: newValue)
        }
    }
    
    public init(wrappedValue: CGPoint?) {
        self.value = wrappedValue
    }
    
    private mutating func updateValue(
        oldValue: CGPoint?,
        newValue: CGPoint?
    ) {
        guard let newValue = newValue else {
            value = nil
            
            return
        }
        
        guard let oldValue else {
            value = newValue
            
            return
        }
        
        if previousPoints.count < sampleSize {
            previousPoints.append(newValue)
        }
        
        let averagePoint = previousPoints.reduce(.zero, +) / CGFloat(previousPoints.count)
        
        if abs(oldValue.distance(from: newValue)) > minimumDelta {
            previousPoints = [newValue]
            
            value = newValue
        } else {
            value = averagePoint
        }
    }
}

extension StabilizedPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sampleSize)
        hasher.combine(minimumDelta)
        
        previousPoints.forEach {
            $0.x.hash(into: &hasher)
            $0.y.hash(into: &hasher)
        }
        
        hasher.combine(value?.x)
        hasher.combine(value?.y)
    }
}
