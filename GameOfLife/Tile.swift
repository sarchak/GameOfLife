//
//  Tile.swift
//  GameOfLife
//
//  Created by Shrikar Archak on 6/12/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit
import SpriteKit
class Tile: SKSpriteNode {
    var isAlive:Bool = false {
        didSet {
            self.hidden = !isAlive
        }
    }
    var numLivingNeighbors = 0
}
