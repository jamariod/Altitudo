//
//  GradientView.swift
//  Altitudo
//
//  Created by Jamario Davis on 7/10/19.
//  Copyright © 2019 KAYCAM. All rights reserved.
//

import UIKit

class GradientView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    private func setupView() {
        backgroundColor = .clear
    }
    func setupGradient() {
        let gradientLayer           = CAGradientLayer()
        gradientLayer.frame         = frame
        gradientLayer.colors        = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations     = [0.0, 1.0]
        gradientLayer.startPoint    = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint      = CGPoint(x: 1.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

