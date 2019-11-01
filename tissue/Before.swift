//
//  Before.swift
//  tissue
//
//  Created by 山口航輝 on 2019/08/16.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//


import Foundation
import UIKit
import SpriteKit

class BeforeScene : SKScene{
    
    //タイマー
    var count=Int()
    var countLabel=UILabel()
    
    
    override func didMove(to view: SKView) {
        count=3
        
        makeFirstView()
        makeLabel()
        makeTimer()
        
        
    }
    
    
    func makeFirstView(){
        let backgroundImgView=SKSpriteNode(imageNamed: "background")
        backgroundImgView.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundImgView.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        self.addChild(backgroundImgView)
    }
    
    func makeTimer(){
        _=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timer), userInfo: nil, repeats: true)
    }
    
    //カウントダウンの音(3.2.1)
    func playSound2(){
        let sound:SKAction = SKAction.playSoundFileNamed("sound3.mp3", waitForCompletion: true)
        self.run(sound)
    }
    
    //カウントダウンの音(0)
    func playSound3(){
        let sound:SKAction = SKAction.playSoundFileNamed("sound4.mp3", waitForCompletion: true)
        self.run(sound)
    }
    
    func makeLabel(){
        // ラベルを作る
        countLabel = UILabel(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height))
        
        // ラベルの色
        countLabel.backgroundColor = UIColor.clear
        
        
        // テキストの色
        countLabel.textColor = UIColor.black
        
        // テキストを中央寄せ
        countLabel.textAlignment = NSTextAlignment.center
        
        countLabel.font = UIFont(name: "KKM-AnalogTerevisionFont", size: UIScreen.main.bounds.width * 0.5)
        
        // ラベルの位置
        countLabel.layer.position = CGPoint(x: UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/16,y: UIScreen.main.bounds.height/2)
        self.view?.addSubview(countLabel)
    }
    
    @objc func timer(){
        if count == -1{
            let scene = GameScene(size: self.scene!.size)
            scene.scaleMode = SKSceneScaleMode.aspectFill
            self.view!.presentScene(scene)
            countLabel.removeFromSuperview()
        }
        
        if count >= 1{
            playSound2()
        }else if count == 0{
            playSound3()
        }
        countLabel.text=String(count)
        count-=1
        
    }
}

