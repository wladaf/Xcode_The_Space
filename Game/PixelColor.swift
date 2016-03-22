//
//  PixelColor.swift
//  Game
//
//  Created by Владислав Афанасьев on 22/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

func GetPixelColor(k: CGFloat, color: SKTexture)->UIColor
{
    let imageDataProvider = CGImageGetDataProvider(color.CGImage())
    let pixelData = CGDataProviderCopyData(imageDataProvider);
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData);
    
    let x: Int = Int(k*99)
    let pixelInfo = 4 * x;
    
    let red: UInt8 = data[pixelInfo];
    let green: UInt8 = data[(pixelInfo + 1)];
    let blue: UInt8 = data[pixelInfo + 2];
    let alpha: UInt8 = data[pixelInfo + 3];
    
    return UIColor.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
}