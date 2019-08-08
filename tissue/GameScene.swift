//
//  GameScene.swift
//  tissue
//
//  Created by 山口航輝 on 2019/07/20.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //tissueノード
    var tissue=SKSpriteNode()
    //tissueノードの位置
    var tissueY=CGFloat()
    
    
    override func didMove(to view: SKView) {
        
        
        makeUnderBox()
        makeFirstView()
        makeTissue()
        makeAboveBox()
        
       
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if self.atPoint(location).name == "tissue"{
            
            let newPosition = touch.location(in: self)
            
            let oldPosition = touch.previousLocation(in: self)
            let xTranslation = newPosition.y - oldPosition.y
            
            
            tissueY=tissue.position.y
            tissueY += xTranslation
            
            //blockNodeを動かすアニメーション
            let tissueAnimation=SKAction.moveTo(y: tissueY, duration: 0.0)
            tissue.run(tissueAnimation, withKey: "block anime")
            }
            
        }
        
    }
    
    func makeFirstView(){
        let backgroundImgView=SKSpriteNode(imageNamed: "background")
        backgroundImgView.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundImgView.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        self.addChild(backgroundImgView)
    }
    
    func makeUnderBox(){
        let UnderBox=SKSpriteNode(imageNamed: "box")
        UnderBox.size=CGSize(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.width * 0.573)
        UnderBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.width
        * 0.6)
        UnderBox.zPosition=0.6
        self.addChild(UnderBox)
    }
    
    func makeTissue(){
        tissue=SKSpriteNode(imageNamed: "tissue")
        tissue.size=CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.5)
        tissue.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.45)
        tissue.zPosition=0.8
        tissue.name="tissue"
        self.addChild(tissue)
    }
    
    func makeAboveBox(){
        let AboveBox=SKSpriteNode(imageNamed: "aboveBox")
        AboveBox.size=CGSize(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.width * 0.573)
        AboveBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.width
            * 0.6)
        AboveBox.zPosition=1
        self.addChild(AboveBox)
    }

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
