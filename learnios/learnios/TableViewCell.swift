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
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    
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
        
        //add a pan gesture recognizer to custom table view cell nad sets the cell itself as the recognizer's delegate. Any pan events will be sent to handlePan
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
//    Here you add a CAGradientLayer property and create a four-step gradient within the init method. Notice that the gradient is a transparent white at the very top, and a transparent black at the very bottom. This will be overlaid on top of the existing color background, lightening the top and darkening the bottom, to create a neat bevel effect simulating a light source shining down from the top.
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            //when the gesture beins, record the current center location
            originalCenter = center
        }
        
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            deleteOnDragRelease = frame.origin.x < frame.size.width / 2.0
        }
        
        if recognizer.state == .ended {
            //the frame this cell has before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            //the user might have dragged the cell more than halfway and then dragged it back, which is not seen as a selete operation
            if !deleteOnDragRelease {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    //This delegate method allows you to cancel the recognition of a gesture before it has begun. In this case, you determine whether the pan that is about to be initiated is horizontal or vertical. If it is vertical, you cancel the gesture recognizer, since you don't want to handle any vertical pans.
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
