//
//  WhackSlot.swift
//  project14
//
//  Created by kimihito on 2016/08/24.
//  Copyright © 2016年 minotake. All rights reserved.
//

import SpriteKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    func configureAtPosition(pos: CGPoint) {
        position = pos
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
}
