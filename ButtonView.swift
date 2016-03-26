//
//  ButtonView.swift
//  Game
//
//  Created by Владислав Афанасьев on 20/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation

import UIKit

class Button: UIView{
    
    var isPressed: Bool = false
    var text: String = ""
    var action: Void->Void = {}

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func drawRect(rect: CGRect) {
        drawButton(frame: self.bounds, text: text, isPressed: isPressed)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isPressed = true
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isPressed = false
        action()
        self.setNeedsDisplay()
    }
    
    func SetText(text: String)
    {
        self.text = text
        self.setNeedsDisplay()
    }
    
    func SetAction(action: Void->Void)
    {
        self.action = action
    }
    
    func drawButton(frame frame: CGRect = CGRectMake(0, 0, 240, 120), text: String = "OK", isPressed: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let strokeColorNP = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let backColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let strokeColorP = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.000)
        var strokeColor = UIColor()
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(frame.minX + 9, frame.minY + 9, frame.width - 18, frame.height - 17)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 24)
        backColor.setFill()
        if(!isPressed)
        {
            strokeColor = strokeColorNP
        }
        else
        {
            strokeColor = strokeColorP
        }
        strokeColor.setStroke()
        rectanglePath.fill()
        rectanglePath.lineWidth = 7
        rectanglePath.stroke()
        let rectangleStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        rectangleStyle.alignment = .Center
        
        let rectangleFontAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 46)!, NSForegroundColorAttributeName: strokeColor, NSParagraphStyleAttributeName: rectangleStyle]
        
        let rectangleTextHeight: CGFloat = NSString(string: text).boundingRectWithSize(CGSizeMake(rectangleRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: rectangleFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, rectangleRect);
        NSString(string: text).drawInRect(CGRectMake(rectangleRect.minX, rectangleRect.minY + (rectangleRect.height - rectangleTextHeight) / 2, rectangleRect.width, rectangleTextHeight), withAttributes: rectangleFontAttributes)
        CGContextRestoreGState(context)
    }
    
}