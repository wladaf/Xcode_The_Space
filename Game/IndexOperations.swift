//
//  IndexOperations.swift
//  Game
//
//  Created by Владислав Афанасьев on 18/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation

func StepLeft(var index: Int, n: Int) -> Int
{
    index = (index+n-1)%n
    return index
}

func StepRight(var index: Int, n: Int) -> Int
{
    index = (index+1)%n
    return index
}