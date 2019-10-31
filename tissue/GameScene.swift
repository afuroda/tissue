//
//  GameScene.swift
//  tissue
//
//  Created by 山口航輝 on 2019/07/20.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


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
    var resultLabelCover=UILabel()
    
    //bgm
    var player:AVAudioPlayer!
    let soundFilePath : NSString = Bundle.main.path(forResource: "gameSound", ofType: "mp3")! as NSString
    
    
    
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
        playBgm()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!intersects(tissue)){
            makeTissue()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if self.atPoint(location).name == "touch"{
                
                
                if(tissue.position.y>=UIScreen.main.bounds.height * 0.45 + 1){
                    playSound1()
                    
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
            
            if self.atPoint(location).name == "restart"{
                resultLabel.removeFromSuperview()
                resultLabelCover.removeFromSuperview()
                let scene = BeforeScene(size: self.scene!.size)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                self.view!.presentScene(scene)
            }
            
            if self.atPoint(location).name == "tweet"{
                //twitterに投稿したい文章をtextに入れる
                let text = "今回の記録は\(scoreCount)枚だったよ!!"
                
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
    
    // SKPhysicsContactDelegateのメソッド。衝突したときに呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == 0b0001 || contact.bodyB.categoryBitMask == 0b0001 {
           
                tissue.removeFromParent()
                scoreCount+=1
            if scoreCount >= 30 && scoreCount <= 40{
                scoreLabel.fontColor=UIColor.blue
            }else if scoreCount >= 41 && scoreCount <= 50{
                scoreLabel.fontColor=UIColor.yellow
            }else if scoreCount >= 51 && scoreCount <= 60{
                scoreLabel.fontColor=UIColor.green
            }else if scoreCount >= 61 && scoreCount <= 70{
                scoreLabel.fontColor=UIColor.red
            }else if scoreCount >= 71 && scoreCount <= 80{
                scoreLabel.fontColor=UIColor.purple
            }else if scoreCount >= 81{
                scoreLabel.fontColor=UIColor.init(red: 245/255, green: 209/255, blue: 0, alpha: 1)
            }
                scoreLabel.text=String(scoreCount)
            makeTissue()
          
        }
        
        
    }
    
    func makeFirstView(){
        let backgroundImgView=SKSpriteNode(imageNamed: "background")
        backgroundImgView.size=CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundImgView.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        self.addChild(backgroundImgView)
    }
    
    func makeUnderBox(){
        print(UIScreen.main.bounds.height)
        let UnderBox=SKSpriteNode(imageNamed: "box")
        UnderBox.size=CGSize(width: UIScreen.main.bounds.width * 0.87, height: UIScreen.main.bounds.width * 0.573)
       UnderBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height
        * 0.35)
        
        UnderBox.zPosition=0.6
        self.addChild(UnderBox)
    }
    
    
    //結果表示
    func makeResultLabel(){
        resultLabel.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.2)
        resultLabel.text="今回の記録\(String(scoreCount))枚!!"
        resultLabel.backgroundColor=UIColor.cyan
        resultLabel.textAlignment=NSTextAlignment.center
        if(UIScreen.main.bounds.width<=414){
        resultLabel.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.4)
        }else if(UIScreen.main.bounds.width >= 834){
            resultLabel.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        }
        resultLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width*0.1)
        self.view?.addSubview(resultLabel)
        
    }
    
    func makeResultLabelCover(){
        resultLabelCover.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.3)
        resultLabelCover.backgroundColor=UIColor.green
        if(UIScreen.main.bounds.width<=414){
        resultLabelCover.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.4)
        }else if(UIScreen.main.bounds.width>=834){
            resultLabelCover.layer.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.3)
        }
        self.view?.addSubview(resultLabelCover)
        
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
        let restartNode=SKSpriteNode(imageNamed: "restart")
        restartNode.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        restartNode.position=CGPoint(x: UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.width * 0.578)
        restartNode.name="restart"
        restartNode.zPosition=1
        restartNode.color=UIColor.red
        self.addChild(restartNode)
    }
    
    //ツイートノード
    func makeTweetTouch(){
        let tweetNode=SKSpriteNode(imageNamed: "tweet")
        tweetNode.size=CGSize(width: UIScreen.main.bounds.width * 0.34, height: UIScreen.main.bounds.width * 0.27)
        tweetNode.position=CGPoint(x: UIScreen.main.bounds.width * 0.75, y: UIScreen.main.bounds.width * 0.578)
        tweetNode.name="tweet"
        tweetNode.zPosition=1
        self.addChild(tweetNode)
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
        
       AboveBox.position=CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height
       * 0.35)
        
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
            makeResultLabelCover()
            makeResultLabel()
            makeRestartTouch()
            makeTweetTouch()
            playSound4()
        }
        if count <= 10{
            timerLabel.fontColor=UIColor.yellow
        }
        if count <= 5{
            timerLabel.fontColor=UIColor.red
        }
        
        if(count <= 5 && count >= 1){
            playSound2()
        }
        timerLabel.text=String(count)
        count-=1
        
    }
    
    //抜くときの音
    func playSound1(){
        let sound:SKAction = SKAction.playSoundFileNamed("sound1.mp3", waitForCompletion: true)
        self.run(sound)
    }
    
    //カウントダウンの音(3.2.1)
    func playSound2(){
        let sound:SKAction = SKAction.playSoundFileNamed("sound3.mp3", waitForCompletion: true)
        self.run(sound)
    }
    
    //カウントダウンの音(0)
    func playSound4(){
        let sound:SKAction = SKAction.playSoundFileNamed("sound2.mp3", waitForCompletion: true)
        self.run(sound)
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
