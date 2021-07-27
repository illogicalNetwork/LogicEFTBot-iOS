//
//  PriceFormatter.swift
//  LogicEFT
//
//  Created by James Sayer on 7/12/21.
//

import Foundation

class PriceFormatter {
    /// The shared singleton instance
    static let shared = PriceFormatter()
    
    /// The number formatter object to format non-string price values to string objects
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 0
        
        return formatter
    }()
}
