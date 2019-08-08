//
//  firstScene.swift
//  tissue
//
//  Created by 山口航輝 on 2019/07/20.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class firstScene : SKScene{
    
    
    override func didMove(to view: SKView) {
        
        makeFirstView()
        makeStartBtn()
        makeCollectionBtn()
        
    
    }
    
    @objc func gameStart(){
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view!.presentScene(scene)
        print("push")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "start" {
                let scene = GameScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                self.view!.presentScene(scene)
                print("push")
                
            }
        }
    }
    
    
    
    func makeFirstView(){
        let backgroundImgView=SKSpriteNode(imageNamed: "titleImage")
        backgroundImgView.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundImgView.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        self.addChild(backgroundImgView)
    }
    
    func makeStartBtn(){
        let startBtn=SKSpriteNode(imageNamed: "start")
        startBtn.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        startBtn.position=CGPoint(x: UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.width * 0.578)
        startBtn.name="start"
        self.addChild(startBtn)
    }
    
    func makeCollectionBtn(){
        let collectionBtn=SKSpriteNode(imageNamed: "seeCollection")
        collectionBtn.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        collectionBtn.position=CGPoint(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.width * 0.578)
        collectionBtn.name="collection"
        self.addChild(collectionBtn)
    }
    
}
