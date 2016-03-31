//
//  CombineUIImages.swift
//  Game
//
//  Created by Владислав Афанасьев on 30/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation
import UIKit

func combine(images: UIImage...) -> UIImage {
    var contextSize = CGSizeZero
    
    for image in images {
        contextSize.width = max(contextSize.width, image.size.width)
        contextSize.height = max(contextSize.height, image.size.height)
    }
    
    UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.mainScreen().scale)
    
    for image in images {
        let originX = (contextSize.width - image.size.width) / 2
        let originY = (contextSize.height - image.size.height) / 2
        
        image.drawInRect(CGRectMake(originX, originY, image.size.width, image.size.height))
    }
    
    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return combinedImage
}