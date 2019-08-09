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
    var tissueX=CGFloat()
    //タッチ判定ノード
    var touchNode=SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        
        makeUnderBox()
        makeFirstView()
        makeTissue()
        makeAboveBox()
        makeTouch()
        
        print(UIScreen.main.bounds.height)
        
       
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if self.atPoint(location).name == "touch"{
            
            let newPosition = touch.location(in: self)
            
            let oldPosition = touch.previousLocation(in: self)
            let yTranslation = newPosition.y - oldPosition.y
            let xTranslation = newPosition.x - oldPosition.x
            
            
            tissueY=tissue.position.y
            tissueY += yTranslation
                
            tissueX=tissue.position.x
            tissueX+=xTranslation
                
                
            //tissueを動かすアニメーション
            let tissueAnimation=SKAction.move(to: CGPoint(x: tissueX, y: tissueY), duration: 0.0)
            let tissueReAnimation=SKAction.moveTo(y: UIScreen.main.bounds.height * 0.45, duration: 0.0)
                if tissue.position.y>UIScreen.main.bounds.height * 0.449{
            tissue.run(tissueAnimation, withKey: "tissue anime")
                }
                
                if tissue.position.y<UIScreen.main.bounds.height * 0.449{
                    tissue.run(tissueReAnimation)
                }
            }
            
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if self.atPoint(location).name == "touch"{
            
                if touch.location(in: self).x<UIScreen.main.bounds.width*0.2{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x-600, y: touch.location(in: self).y+600), duration: 0.2)
                    tissue.run(tissueRemoveAnimation)
                    print("patern1")
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.2 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.4{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x-300, y: touch.location(in: self).y+600), duration: 0.2)
                    tissue.run(tissueRemoveAnimation)
                    print("patern2")
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.4 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.6{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y+600), duration: 0.2)
                    tissue.run(tissueRemoveAnimation)
                    print("patern3")
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.6 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.8{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x+300, y: touch.location(in: self).y+600), duration: 0.2)
                    tissue.run(tissueRemoveAnimation)
                    print("patern4")
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.8 && touch.location(in: self).x<UIScreen.main.bounds.width{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x+600, y: touch.location(in: self).y+600), duration: 0.2)
                    tissue.run(tissueRemoveAnimation)
                    print("patern5")
                }
                
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
    
    func makeTouch(){
        touchNode=SKSpriteNode()
        touchNode.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.6)
        touchNode.position=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.75)
        touchNode.zPosition=1
        touchNode.name="touch"
        self.addChild(touchNode)
    }
    
    func makeAboveBox(){
        let AboveBox=SKSpriteNode(imageNamed: "aboveBox")
        AboveBox.size=CGSize(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.width * 0.573)
        AboveBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.width
            * 0.6)
        AboveBox.zPosition=1
        self.addChild(AboveBox)
    }
    
    func removeTissue(){
        if tissue.position.y <= UIScreen.main.bounds.height / 2{
            let tissueRemoveAnimation=SKAction.moveTo(y: UIScreen.main.bounds.height, duration: 1)
            tissue.run(tissueRemoveAnimation)
        }
    }

    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
