//
//  TitleScene.swift
//  Test2
//
//  Created by unknown-macbook on 5/7/16.
//  Copyright © 2016 indietarhouni.com. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene{
    
    var btnPlay : UIButton!
    var gameTitle : UILabel!
    
    var textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.purpleColor()
        
        setUpText()
    }
    
    func setUpText(){
        //setup game button and the game title
        btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
        btnPlay.center = CGPointMake(view!.frame.size.width / 2, 600)
        btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 60)
        btnPlay.setTitle("play", forState: UIControlState.Normal)
        btnPlay.setTitleColor(textColorHUD, forState: UIControlState.Normal)
        
        //when you click on the button, it will call playTheGame
        btnPlay.addTarget(self, action: Selector("playTheGame"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(btnPlay)
        
        gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: 300))
        gameTitle!.textColor = textColorHUD
        gameTitle!.font = UIFont(name: "Futura", size: 40)
        gameTitle!.textAlignment = NSTextAlignment.Center
        gameTitle!.text = "ANDROMEDA GALAXY"
        self.view?.addSubview(gameTitle)
        
    }
    
    func playTheGame(){
        
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1.0))
        btnPlay.removeFromSuperview()
        gameTitle.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene"){
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
            
        }
    }
    
    
    
    
    
    
}