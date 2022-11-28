//
//  DateExtensions.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/27/22.
//

import Foundation

extension Date {
    
    func apiReadyString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func timestampDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: self)
    }
    
    func displayReadyString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: self)
    }
}
