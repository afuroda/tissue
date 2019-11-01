//
//  GameViewController.swift
//  tissue
//
//  Created by 山口航輝 on 2019/07/20.
//  Copyright © 2019年 koki.yamaguchi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SKViewに型を変換する
        let skView = self.view as! SKView
        // ビューと同じサイズでシーンを作成する
        let scene = firstScene(size:skView.frame.size)
        // ビューにシーンを表示する
        skView.presentScene(scene)
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        bannerView.frame = CGRect(x:0,y:(self.view.bounds.height-self.view.bounds.height/12),width:self.view.bounds.width,height:self.view.bounds.height/12)
        self.view.addSubview(bannerView)
        
       
    }

    override var shouldAutorotate: Bool {
        return true
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
