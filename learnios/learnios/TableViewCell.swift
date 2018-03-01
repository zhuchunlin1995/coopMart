//
//  TableViewCell.swift
//  learnios
//
//  Created by 万琳莉 on 01/03/2018.
//  Copyright © 2018 Linli. All rights reserved.
//  This class is usd to add gtadient effect to each cell so that it's easier to tell the cells apart

import UIKit
import QuartzCore

class TableViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    
    //required init is used when the view is created from the storyboead while override init is used when create the view programmatically
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
//    Here you add a CAGradientLayer property and create a four-step gradient within the init method. Notice that the gradient is a transparent white at the very top, and a transparent black at the very bottom. This will be overlaid on top of the existing color background, lightening the top and darkening the bottom, to create a neat bevel effect simulating a light source shining down from the top.
}
