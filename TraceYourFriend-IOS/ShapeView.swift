//
//  ShapeView.swift
//  ShapesTutorial
//
//  Created by Aniss on 14/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//

import UIKit

class ShapeView: UIView{
    
    let size: CGFloat = 150
    let lineWidth: CGFloat = 3
    var fillColor: UIColor!
    var path: UIBezierPath!
    
    func randomColor() -> UIColor {
        let hue:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
    }
    
    func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPointMake(radius * cos(angle) + offset.x, radius * sin(angle) + offset.y)
    }
    
    func regularPolygonInRect(rect:CGRect) -> UIBezierPath {
        let degree = arc4random() % 10 + 3
        
        let path = UIBezierPath()
        
        let center = CGPointMake(rect.width / 2.0, rect.height / 2.0)
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
        let radius = rect.width / 2.0
        
        path.moveToPoint(pointFrom(angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            path.addLineToPoint(pointFrom(angle, radius: radius, offset: center))
        }
        
        path.closePath()
        
        return path
    }
    
    func starPathInRect(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let starExtrusion:CGFloat = 30.0
        
        let center = CGPointMake(rect.width / 2.0, rect.height / 2.0)
        
        let pointsOnStar = 5 + arc4random() % 10
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.moveToPoint(point)
            }
            
            path.addLineToPoint(midPoint)
            path.addLineToPoint(nextPoint)
            
            angle += angleIncrement
        }
        
        path.closePath()
        
        
        return path
    }
    
    
    func trianglePathInRect(rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(rect.width / 2.0, rect.origin.y))
        path.addLineToPoint(CGPointMake(rect.width,rect.height))
        path.addLineToPoint(CGPointMake(rect.origin.x,rect.height))
        path.closePath()
        
        
        return path
    }
    
    func randomPath() -> UIBezierPath {
        
        let insetRect = CGRectInset(self.bounds,lineWidth,lineWidth)
        
        
        let shapeType = arc4random() % 5
        
        if shapeType == 0 {
            return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
        }
        
        if shapeType == 1 {
            return UIBezierPath(ovalInRect: insetRect)
        }
        
        if (shapeType == 2) {
            return trianglePathInRect(insetRect)
        }
        
        if (shapeType == 3) {
            return regularPolygonInRect(insetRect)
        }
        
        return starPathInRect(insetRect)
        
    }
    
    init(origin: CGPoint) {
        
        super.init(frame: CGRectMake(0.0, 0.0, size, size))
        
        self.fillColor = randomColor()
        self.path = randomPath()
        
        
        self.path = randomPath()
        
        self.center = origin
        
        self.backgroundColor = UIColor.clearColor()
        
        initGestureRecognizers()
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(ShapeView.didPan(_:)))
        addGestureRecognizer(panGR)
        
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(ShapeView.didPinch(_:)))
        addGestureRecognizer(pinchGR)
        
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(ShapeView.didRotate(_:)))
        addGestureRecognizer(rotationGR)
    }
    
    func didPan(panGR: UIPanGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        var translation = panGR.translationInView(self)
        
        translation = CGPointApplyAffineTransform(translation, self.transform)
        
        self.center.x += translation.x
        self.center.y += translation.y
        
        panGR.setTranslation(CGPointZero, inView: self)
    }
    
    func didPinch(pinchGR: UIPinchGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        let scale = pinchGR.scale
        
        self.transform = CGAffineTransformScale(self.transform, scale, scale)
        
        pinchGR.scale = 1.0
    }
    
    func didRotate(rotationGR: UIRotationGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        let rotation = rotationGR.rotation
        
        self.transform = CGAffineTransformRotate(self.transform, rotation)
        
        rotationGR.rotation = 0.0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        self.fillColor.setFill()
        
        self.path.fill()
        
        var name = "hatch"
        if arc4random() % 2 == 0 {
            name = "cross-hatch"
        }
        
        let color = UIColor(patternImage: UIImage(named: name)!)
        
        color.setFill()
        
        if arc4random() % 2 == 0 {
            path.fill()
        }
        
        UIColor.blackColor().setStroke()
        
        path.lineWidth = self.lineWidth
        
        path.stroke()
    }
    
}
