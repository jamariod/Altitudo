//
//  Double+Ext.swift
//  Altitudo
//
//  Created by Jamario Davis on 7/10/19.
//  Copyright © 2019 KAYCAM. All rights reserved.
//

import Foundation

extension Double {
    
    func rounded(toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
