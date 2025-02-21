//
//  GaugeDescriptor.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//

import SwiftUI

struct GaugeDescriptor {
    let maxNumber: Int
    let segments: [GaugeSegment]
    
    init(maxNumber: Int, segments: [GaugeSegment]) {
        let total = segments.reduce(0) { $0 + $1.lengthInHours }
        assert(total == maxNumber, "Gauge segments must sum up to \(maxNumber), but got \(total)")
        self.maxNumber = maxNumber
        self.segments = segments
    }
    
    var gaugeTrim: CGFloat {
        CGFloat(maxNumber) / 16.0
    }
    
    var maxSize: Double = 0.8
    
    func trimRange(for segment: GaugeSegment) -> (start: CGFloat, end: CGFloat) {
        let totalHours = segments.reduce(0) { $0 + $1.lengthInHours }
        assert(totalHours == maxNumber, "Gauge segments must sum up to \(maxNumber), but got \(totalHours)")
        
        var currentTotal = 0
        for s in segments {
            if s.name == segment.name {
                let start = (CGFloat(currentTotal) / CGFloat(maxNumber)) * CGFloat(maxSize)
                let end = (CGFloat(currentTotal + s.lengthInHours) / CGFloat(maxNumber)) * CGFloat(maxSize)
                return (start, end)
            }
            currentTotal += s.lengthInHours
        }
        return (0, 0)
    }
}
