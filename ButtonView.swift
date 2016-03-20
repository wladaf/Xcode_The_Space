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
        let backColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let strokeColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        let pressedColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.297)
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(frame.minX + 9, frame.minY + 9, frame.width - 18, frame.height - 17)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 24)
        backColor.setFill()
        rectanglePath.fill()
        strokeColor.setStroke()
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
        
        
        if (isPressed) {
            //// Rectangle 2 Drawing
            let rectangle2Path = UIBezierPath(roundedRect: CGRectMake(frame.minX + floor((frame.width - 8.5) * 0.04104) + 0.5, frame.minY + 8.5, frame.width - 9 - floor((frame.width - 8.5) * 0.04104), floor((frame.height - 8.5) * 0.92377 + 0.5)), cornerRadius: 24)
            pressedColor.setFill()
            rectangle2Path.fill()
        }
    }
    
}