//
//  GameScene.swift
//  GameOfLife
//
//  Created by Shrikar Archak on 6/11/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let _gridWidth = 400
    let _gridHeight = 300
    let _numRows = 8
    let _numCols = 10
    let _gridLowerLeftCorner:CGPoint = CGPoint(x:158,y:10)
    let _populationLabel:SKLabelNode = SKLabelNode(text:"Population")
    let _generationLabel:SKLabelNode = SKLabelNode(text:"Generation")
    let _populationValueLabel:SKLabelNode = SKLabelNode(text:"0")
    let _generationValueLabel:SKLabelNode = SKLabelNode(text:"0")
    let _playButton:Tile = Tile(imageNamed: "play.png")
    let _pauseButton:Tile = Tile(imageNamed: "pause.png")
    
    var _isPlaying = false
    var _tiles: Tile[][]=[]
    var _margin = 4
    var _prevTime:CFTimeInterval = 0
    var _timeCounter:CFTimeInterval = 0
    var _population:Int = 0 {
        didSet {
            _populationValueLabel.text = "\(_population)"
        }
    }
    var _generation:Int = 0 {
        didSet {
            _generationValueLabel.text = "\(_generation)"
        }
    }

    func countLivingNeighbors()
    {
        for r in 0.._numRows {
            for c in 0.._numCols
            {
                var numLivingNeighbors:Int = 0
                for i in (r-1)...(r+1) {
                    for j in (c-1)...(c+1)
                    {
                        if ( !((r == i) && (c == j)) && isValidTile(row: i, col: j)) {
                            if _tiles[i][j].isAlive {
                                numLivingNeighbors++
                            }
                        }
                    }
                }
                _tiles[r][c].numLivingNeighbors = numLivingNeighbors
            }
        }
    }
    
    func updateCreatures()
    {
        var numAlive = 0
        for r in 0.._numRows {
            for c in 0.._numCols
            {
                var tile:Tile = _tiles[r][c]
                if tile.numLivingNeighbors == 3 {
                    tile.isAlive = true
                } else if tile.numLivingNeighbors < 2 || tile.numLivingNeighbors > 3 {
                    tile.isAlive = false
                }
                if tile.isAlive {
                    numAlive++
                }
            }
        }
        _population = numAlive
    }
    
    func timeStep()
    {
        countLivingNeighbors()
        updateCreatures()
        _generation++
    }
    
    override func update(currentTime : CFTimeInterval){
        if _prevTime == 0 {
            _prevTime = currentTime
        }
        if _isPlaying {
            _timeCounter += currentTime - _prevTime
            if _timeCounter > 0.5 {
                _timeCounter = 0
                timeStep()
            }
            
        }
        _prevTime = currentTime
    }
    
    func playButtonPressed() {
        _isPlaying = true
    }
    
    func pauseButtonPressed() {
        _isPlaying = false
    }
    
    func calculateTileSize() -> CGSize {
        let _tileWidth = _gridWidth/_numCols - _margin
        let _tileHeight = _gridHeight/_numRows - _margin
        return CGSize(width:_tileWidth,height:_tileHeight)
    }
    
    func getTilePosition(row r:Int , col c:Int) -> CGPoint {
        let tileSize = calculateTileSize()
        let x = Int(_gridLowerLeftCorner.x)+_margin+(c*(Int(tileSize.width)+_margin))
        let y = Int(_gridLowerLeftCorner.y)+_margin+(r*(Int(tileSize.height)+_margin));
        return CGPoint(x:x,y:y)
    }
    
    func isValidTile(row r:Int , col c:Int) -> Bool {
        return r >= 0 && r < _numRows && c>=0 && c < _numCols
    }
    
    func getTileAtPosition(xPos x: Int, yPos y: Int) -> Tile? {
        let r:Int = Int( CGFloat(y - (Int(_gridLowerLeftCorner.y) + _margin)) / CGFloat(_gridHeight) * CGFloat(_numRows))
        let c:Int = Int( CGFloat(x - (Int(_gridLowerLeftCorner.x) + _margin)) / CGFloat(_gridWidth) * CGFloat(_numCols))
        if isValidTile(row: r, col: c) {
            return _tiles[r][c]
        } else {
            return nil
        }
    }
    
    override func didMoveToView(view: SKView) {
        let background = Tile(imageNamed: "background.png")
        background.anchorPoint = CGPoint(x:0,y:0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
        
        let gridBackground = Tile(imageNamed: "grid.png")
        gridBackground.size = CGSize(width:_gridWidth,height:_gridHeight)
        gridBackground.zPosition = -1
        gridBackground.anchorPoint = CGPoint(x:0,y:0)
        gridBackground.position = _gridLowerLeftCorner
        self.addChild(gridBackground)
        
        _playButton.position = CGPoint(x:79,y:290)
        _playButton.setScale(0.5)
        self.addChild(_playButton)
        
        _pauseButton.position = CGPoint(x:79,y:250)
        _pauseButton.setScale(0.5)
        self.addChild(_pauseButton)
        
        let balloon = Tile(imageNamed: "balloon.png")
        balloon.position = CGPoint(x:79,y:170)
        balloon.setScale(0.5)
        self.addChild(balloon)
        
        let microscope = Tile(imageNamed: "microscope.png")
        microscope.position = CGPoint(x:79,y:70)
        microscope.setScale(0.3)
        self.addChild(microscope)
        
        _populationLabel.position = CGPoint(x:79,y:190)
        _populationLabel.fontName = "Courier"
        _populationLabel.fontSize = 12
        _populationLabel.fontColor = UIColor(red:0,green:0.2,blue:0,alpha:1)
        self.addChild(_populationLabel)
        
        _populationValueLabel.position = CGPoint(x:79,y:175)
        _populationValueLabel.fontName = "Courier"
        _populationValueLabel.fontSize = 12
        _populationValueLabel.fontColor = UIColor(red:0,green:0.2,blue:0,alpha:1)
        self.addChild(_populationValueLabel)
        
        _generationLabel.position = CGPoint(x:79,y:160)
        _generationLabel.fontName = "Courier"
        _generationLabel.fontSize = 12
        _generationLabel.fontColor = UIColor(red:0,green:0.2,blue:0,alpha:1)
        self.addChild(_generationLabel)
        
        _generationValueLabel.position = CGPoint(x:79,y:145)
        _generationValueLabel.fontName = "Courier"
        _generationValueLabel.fontSize = 12
        _generationValueLabel.fontColor = UIColor(red:0,green:0.2,blue:0,alpha:1)
        self.addChild(_generationValueLabel)
        
        /* Code for adding all the tiles */
        let tileSize = calculateTileSize()
        for r in 0.._numRows {
            var tileRows:Tile[] = []
            for c in 0.._numCols {
                let tile = Tile(imageNamed: "bubble.png")
                tile.isAlive = false
                tile.size = CGSize(width: tileSize.width, height: tileSize.height)
                tile.position = getTilePosition(row: r, col: c)
                tile.anchorPoint = CGPoint(x:0,y:0)
                self.addChild(tile)
                tileRows.append(tile)
            }
            _tiles.append(tileRows)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            var selectedTile:Tile? = getTileAtPosition(xPos: Int(touch.locationInNode(self).x), yPos: Int(touch.locationInNode(self).y))
            if let tile = selectedTile {
                tile.isAlive = !tile.isAlive
                if tile.isAlive {
                    _population++
                } else {
                    _population--
                }
            }
            if CGRectContainsPoint(_playButton.frame, touch.locationInNode(self)) {
                playButtonPressed()
            }
            if CGRectContainsPoint(_pauseButton.frame, touch.locationInNode(self)) {
                pauseButtonPressed()
            }
        }
 
    }
   
}
