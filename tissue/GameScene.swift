//
//  GameScene.swift
//  tissue
//
//  Created by 山口航輝 on 2019/07/20.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //tissueノード
    var tissue=SKSpriteNode()
    //tissueノードの位置
    var tissueY=CGFloat()
    var tissueX=CGFloat()
    //タッチ判定ノード
    var touchNode=SKSpriteNode()
    //当たり判定用のノード
    var topBar=SKSpriteNode()
    var leftBar=SKSpriteNode()
    var rightBar=SKSpriteNode()
    var hitBar=SKSpriteNode()
    
    //tissuenode入れる配列
    var tissueArray=[SKSpriteNode()]
    
    //制限時間
    var count=14
    
    //タイマー
    let timerLabel=SKLabelNode(fontNamed: "Hiragino Kaku Gothic StdN")
    var gameTimer=Timer()
    
    //スコア
    let scoreLabel=SKLabelNode(fontNamed: "Hiragino Kaku Gothic StdN")
    var scoreCount=0
    
    //結果表示用
    var resultLabel=UILabel()
    
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate=self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        makeUnderBox()
        makeFirstView()
        makeTissue()
        makeAboveBox()
        makeTouch()
        makeHitBar()
        makeTimerLabel()
        makeTimer()
        makeScoreLabelNode()
        
        
        
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
            
            if self.atPoint(location).name == "restart"{
                resultLabel.removeFromSuperview()
                let scene = BeforeScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                self.view!.presentScene(scene)
            }
            
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if self.atPoint(location).name == "touch"{
                
                if touch.location(in: self).x<UIScreen.main.bounds.width*0.2{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x-600, y: touch.location(in: self).y+600), duration: 0.4)
                    tissue.run(tissueRemoveAnimation)
                    
                    
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.2 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.4{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x-300, y: touch.location(in: self).y+600), duration: 0.4)
                    tissue.run(tissueRemoveAnimation)
                    
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.4 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.6{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x, y: touch.location(in: self).y+600), duration: 0.4)
                    tissue.run(tissueRemoveAnimation)
                    
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.6 && touch.location(in: self).x<UIScreen.main.bounds.width * 0.8{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x+300, y: touch.location(in: self).y+600), duration: 0.4)
                    tissue.run(tissueRemoveAnimation)
                    
                }else if touch.location(in: self).x>=UIScreen.main.bounds.width * 0.8 && touch.location(in: self).x<UIScreen.main.bounds.width{
                    let tissueRemoveAnimation=SKAction.move(to: CGPoint(x: touch.location(in: self).x+600, y: touch.location(in: self).y+600), duration: 0.4)
                    tissue.run(tissueRemoveAnimation)
                    
                }
                
            }
            
        }
    }
    
    // SKPhysicsContactDelegateのメソッド。衝突したときに呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == 0b0001 || contact.bodyB.categoryBitMask == 0b0001 {
            if tissueArray.count==2{
                tissue.removeFromParent()
                tissueArray.removeLast()
                scoreCount+=1
                scoreLabel.text=String(scoreCount)
            }
            
           
            
            if tissueArray.count==1{
                makeTissue()
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
    
    
    //結果表示
    func makeResultLabel(){
        resultLabel.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4)
        resultLabel.text=String(scoreCount)
        resultLabel.backgroundColor=UIColor.blue
        resultLabel.textAlignment=NSTextAlignment.center
        resultLabel.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        resultLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width*0.2)
        self.view?.addSubview(resultLabel)
        
    }
    
    func makeHitBar(){
        
        topBar.size=CGSize(width: UIScreen.main.bounds.width, height: 10)
        topBar.physicsBody=SKPhysicsBody(rectangleOf: topBar.size)
        topBar.position=CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height*1.2)
        topBar.physicsBody?.categoryBitMask=0b0001
        topBar.physicsBody?.collisionBitMask=0b0001
        topBar.physicsBody?.isDynamic=true
        topBar.physicsBody?.affectedByGravity=false
        self.addChild(topBar)
        
        leftBar.size=CGSize(width: 10, height: UIScreen.main.bounds.height)
        leftBar.physicsBody=SKPhysicsBody(rectangleOf: leftBar.size)
        leftBar.position=CGPoint(x: -UIScreen.main.bounds.width*0.1, y: UIScreen.main.bounds.height*0.5)
        leftBar.physicsBody?.categoryBitMask=0b0001
        leftBar.physicsBody?.collisionBitMask=0b0001
        leftBar.physicsBody?.isDynamic=true
        leftBar.physicsBody?.affectedByGravity=false
        self.addChild(leftBar)
        
        rightBar.size=CGSize(width: 10, height: UIScreen.main.bounds.height)
        rightBar.physicsBody=SKPhysicsBody(rectangleOf: rightBar.size)
        rightBar.position=CGPoint(x: UIScreen.main.bounds.width*1.1, y: UIScreen.main.bounds.height*0.5)
        rightBar.physicsBody?.categoryBitMask=0b0001
        rightBar.physicsBody?.collisionBitMask=0b0001
        rightBar.physicsBody?.isDynamic=true
        rightBar.physicsBody?.affectedByGravity=false
        self.addChild(rightBar)
        
        
        
    }
    
    
    
    func makeTissue(){
        tissue=SKSpriteNode(imageNamed: "tissue")
        tissue.size=CGSize(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.5)
        tissue.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.45)
        tissue.zPosition=0.8
        tissue.physicsBody=SKPhysicsBody(rectangleOf: tissue.size)
        tissue.physicsBody?.categoryBitMask=0b0010
        tissue.physicsBody?.contactTestBitMask=0b0001
        tissue.physicsBody?.collisionBitMask=0b0010
        tissue.physicsBody?.affectedByGravity=false
        
        tissue.name="tissue"
        self.addChild(tissue)
        tissueArray.append(tissue)
    }
    
    func makeTouch(){
        touchNode=SKSpriteNode()
        touchNode.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.6)
        touchNode.position=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.75)
        touchNode.zPosition=0.9
        touchNode.name="touch"
        self.addChild(touchNode)
    }
    
    //リスタートノード
    func makeRestartTouch(){
        let restartNode=SKSpriteNode()
        restartNode.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        restartNode.position=CGPoint(x: UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.width * 0.578)
        restartNode.name="restart"
        restartNode.zPosition=1
        restartNode.color=UIColor.red
        self.addChild(restartNode)
    }
    
    func makeEndTouch(){
        let endNode=SKSpriteNode()
        endNode.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.6)
        endNode.position=CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.75)
        endNode.zPosition=0.95
        endNode.name="end"
        self.addChild(endNode)
    }
    
    func makeAboveBox(){
        let AboveBox=SKSpriteNode(imageNamed: "aboveBox")
        AboveBox.size=CGSize(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.width * 0.573)
        AboveBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.width
            * 0.6)
        AboveBox.zPosition=1
        self.addChild(AboveBox)
    }
    
    func makeTimerLabel(){
        timerLabel.position=CGPoint(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.9)
        timerLabel.fontSize=40
        timerLabel.text="15"
        self.addChild(timerLabel)
    }
    
    func makeScoreLabelNode(){
        scoreLabel.position=CGPoint(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.9)
        scoreLabel.fontSize=40
        scoreLabel.text=String(scoreCount)
        self.addChild(scoreLabel)
    }
    
    
    func removeTissue(){
        if tissue.position.y <= UIScreen.main.bounds.height / 2{
            let tissueRemoveAnimation=SKAction.moveTo(y: UIScreen.main.bounds.height, duration: 1)
            tissue.run(tissueRemoveAnimation)
        }
    }
    
    func makeTimer(){
    gameTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
    }
    
    @objc func timer(){
        
        if count == 0{
            makeEndTouch()
            tissue.removeFromParent()
            gameTimer.invalidate()
            makeResultLabel()
            makeRestartTouch()
        }
        if count <= 10{
            timerLabel.fontColor=UIColor.yellow
        }
        if count <= 5{
            timerLabel.fontColor=UIColor.red
        }
        timerLabel.text=String(count)
        count-=1
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
