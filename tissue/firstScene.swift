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
import AVFoundation

class firstScene : SKScene{
    
    
    let highScoreLabel = UILabel()
    let highScoreLabelCover = UILabel()
    //bgm
    var player:AVAudioPlayer!
    let soundFilePath : NSString = Bundle.main.path(forResource: "gameSound2", ofType: "mp3")! as NSString
    
    
    override func didMove(to view: SKView) {
        
        makeFirstView()
        makeStartBtn()
        makeCollectionBtn()
        makehighScoreLabelCover()
        makeHighScoreLabel()
        
        playBgm()
        
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "start" {
                let scene = BeforeScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                self.view!.presentScene(scene)
                
            }
            
            if let touch = touches.first as UITouch? {
                let location = touch.location(in: self)
                if self.atPoint(location).name == "tweet" {
                    //twitterに投稿したい文章をtextに入れる
                    let text = "暇つぶしに最適!!\nみんなも遊んでみてね！"
                    
                    //.urlQueryAllowed : URLクエリ内で使用できる文字列で返却する
                    guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
                    
                    guard let twitterURL = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") else {return}
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(twitterURL, options:[:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
            
            
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
        let collectionBtn=SKSpriteNode(imageNamed: "tweet")
        collectionBtn.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        collectionBtn.position=CGPoint(x: UIScreen.main.bounds.width - UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.width * 0.578)
        collectionBtn.name="tweet"
        self.addChild(collectionBtn)
    }
    
    //bgm
    func playBgm(){
        let fileURL : NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        do{
            player = try AVAudioPlayer(contentsOf: fileURL as URL)
            player.numberOfLoops = -1
            player.volume=0.4
        }catch{
            print("error")
        }
        
        player.play()
    }
    
    func makeHighScoreLabel(){
        highScoreLabel.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.2)
        highScoreLabel.text="今までの最高記録\(String(GameScene.userDefaults.integer(forKey: "score")))枚!!"
        highScoreLabel.backgroundColor=UIColor.cyan
        highScoreLabel.textAlignment=NSTextAlignment.center
        if(UIScreen.main.bounds.width<=414){
        highScoreLabel.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        }else if(UIScreen.main.bounds.width >= 834){
            highScoreLabel.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        }
        highScoreLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width*0.07)
        self.view?.addSubview(highScoreLabel)
    }
    
    func makehighScoreLabelCover(){
        highScoreLabelCover.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.3)
        highScoreLabelCover.backgroundColor=UIColor.green
        if(UIScreen.main.bounds.width<=414){
        highScoreLabelCover.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        }else if(UIScreen.main.bounds.width>=834){
            highScoreLabelCover.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        }
        self.view?.addSubview(highScoreLabelCover)
        
    }
    
}
