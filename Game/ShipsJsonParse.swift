//
//  JsonParse.swift
//  Game
//
//  Created by Владислав Афанасьев on 18/03/16.
//  Copyright © 2016 Владислав Афанасьев. All rights reserved.
//

import Foundation

func GetShipParameters() -> Array<Dictionary<String, String>>
{
    let path = NSBundle.mainBundle().pathForResource("Ships", ofType: "json")
    let jsonData = NSData(contentsOfFile:path!)
    let json = JSON(data: jsonData!)
    var ships = [[String: String]]()
    
    for _ in 0..<json.count
    {
        ships.append([:])
    }
    for (index, subJson):(String, JSON) in json{
        for (key, subJson1):(String, JSON) in subJson{
            ships[Int(index)!][key]=subJson1.stringValue
        }
    }
    //        for x in ships
    //        {
    //            for (key, value) in x
    //            {
    //                print("\(key):\(value)")
    //            }
    //        }
    return ships
}

func GetJsonCount()->Int
{
    let path = NSBundle.mainBundle().pathForResource("Ships", ofType: "json")
    let jsonData = NSData(contentsOfFile:path!)
    let json = JSON(data: jsonData!)
    return json.count
}
