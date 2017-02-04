//
//  Levels.swift
//  Breakout
//
//  Created by Yulia Vasenina on 05/01/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import Foundation

open class Levels {
    
    static let levels = [levelOne, levelTwo, levelThree, levelFour]
    
    static let levelOne: [[Int]] = [
        [1,0,1,0,1,0],
        [0,1,0,1,0,1],
        [1,0,1,0,1,0],
        [0,1,0,1,0,1],
        [1,0,1,0,1,0],
        [0,1,0,1,0,1],
        [1,0,1,0,1,0]
    ]
    
    static let levelTwo: [[Int]]  = [
        [1,1,1,1,1,1,1],
        [1,1,1,1],
        [1,1,1],
        [1,1,1,1],
        [1,1,1,1,1,1,1]
    ]
    
    static let levelThree: [[Int]] = [
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1],
        [1,1,1,1,1,1]
    ]
    
    static let levelFour: [[Int]] = [
        [1,1,0,1,1,0],
        [1,0,1,1,0,1],
        [0,1,1,0,1,1],
        [1,1,0,1,1,0],
        [1,0,1,1,0,1],
        [0,1,1,0,1,1],
        [1,1,0,1,1,0]
    ]
}
