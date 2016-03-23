//
//  IndexOperations.swift
//  Game
//
//  Created by Владислав Афанасьев on 18/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation

func StepLeft(index: Int, n: Int) -> Int
{
    return (index+n-1)%n
}

func StepRight(index: Int, n: Int) -> Int
{
    return (index+1)%n
}