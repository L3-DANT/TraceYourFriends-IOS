//
//  ButtonView.swift
//  TraceYourFriends-IOS
//
//  Created by Aniss on 11/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

@IBDesignable

class ButtonView: UIButton {
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.whiteColor().setFill()
        path.fill()
        
        let path2 = UIBezierPath(ovalInRect: rect)
        let scale = CGFloat(0.8)
        path2.applyTransform(CGAffineTransformMakeScale(scale, scale))
        
        let translation = CGSize(width: 3, height: 3)
        path2.applyTransform(CGAffineTransformMakeTranslation(translation.width,
            translation.height))
        
        UIColor.candyBlue().setFill()
        path2.fill()
    }
    
}


