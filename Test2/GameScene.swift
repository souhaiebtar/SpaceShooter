//
//  GameScene.swift
//  SpaceShooter
//
//  Created by unknown-macbook on 5/5/16.
//  Copyright (c) 2016 indietarhouni.com. All rights reserved.
//

// add a comment for a github test
import SpriteKit

var player = SKSpriteNode?()
var projectile = SKSpriteNode?()
var enemy = SKSpriteNode?()

var scoreLabel = SKLabelNode?()
var mainLabel = SKLabelNode?()

var fireProjectileRate = 0.2
var projectileSpeed = 0.9

var enemySpeed = 2.1
var enemySpawnRate = 0.6

var isAlive = true

var score = 0

var textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

struct physicsCategory{
    static let player : UInt32 = 1
    static let enemy : UInt32 = 2
    static let projectile : UInt32 = 3
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.purpleColor()
        
        spawnPlayer()
        spawnScoreLabel()
        spawnMainLabel()
        spawnProjectile()
        fireProjectile()
        randomEnemyTimerSpawn()
        updateScore()
        hideLabel()
        resetVariablesOnStart()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let touchLocation = touch.locationInNode(self)
            
            if isAlive == true {
                player?.position.x = touchLocation.x
                player?.position.y = touchLocation.y
                
            }
            
            if isAlive == false {
                player?.position.x = -200
            }
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func spawnPlayer(){
        //player = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 40, height: 40))
        player = SKSpriteNode(imageNamed: "player")
        player?.position = CGPointMake(frame.midX, 130)
        player?.physicsBody = SKPhysicsBody(rectangleOfSize: (player?.size)!)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.categoryBitMask = physicsCategory.player
        player?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player?.physicsBody?.dynamic = false
        
        self.addChild(player!)
        
    }
    
    func spawnScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel?.fontSize = 50
        scoreLabel?.fontColor = textColorHUD
        scoreLabel?.position = CGPoint(x: frame.midX, y: 50)
        scoreLabel?.text = "Score"
        
        self.addChild(scoreLabel!)
    }
    
    func spawnMainLabel(){
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel?.fontSize = 100
        mainLabel?.fontColor = textColorHUD
        mainLabel?.position = CGPoint(x: frame.midX, y: frame.midY)
        mainLabel?.text = "Start"
        
        self.addChild(mainLabel!)
    }
    
    func spawnProjectile(){
        //projectile = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(10, 10))
        projectile = SKSpriteNode(imageNamed: "projectile")
        projectile?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)!)
        
        projectile?.physicsBody = SKPhysicsBody(rectangleOfSize: (projectile?.size)!)
        projectile?.physicsBody?.affectedByGravity = false
        projectile?.physicsBody?.categoryBitMask = physicsCategory.projectile
        projectile?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        projectile?.physicsBody?.dynamic = false
        projectile?.zPosition = -1
        
        let moveForward = SKAction.moveToY(1000, duration: projectileSpeed)
        let destroy = SKAction.removeFromParent()
        projectile!.runAction(SKAction.sequence([moveForward, destroy]))
        
        self.addChild(projectile!)
    }
    
    func spawnEnemy(){
        //enemy = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(30, 30))
        enemy = SKSpriteNode(imageNamed: "enemy")
        enemy?.position = CGPoint(x: Int(arc4random_uniform(1000) + 300), y: 1000)
        enemy?.physicsBody = SKPhysicsBody(rectangleOfSize: enemy!.size)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy?.physicsBody?.contactTestBitMask = physicsCategory.projectile
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.dynamic = true
        
        let	 moveForward = SKAction.moveToY(-100, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        
        enemy?.runAction(SKAction.sequence([moveForward, destroy]))
        self.addChild(enemy!)
        
        
    }
    
    func spawnExplosion(enemyTemp: SKSpriteNode){
        
        let explosionEmiiterPath: NSString = NSBundle.mainBundle().pathForResource("explosion", ofType: "sks")!
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmiiterPath as String) as! SKEmitterNode
    
        explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
        explosion.zPosition = 1
        explosion.targetNode = self
        
        self.addChild(explosion)
        
        let explosionTimerRemove = SKAction.waitForDuration(1.0)
        let removeExplosion = SKAction.runBlock{
            explosion.removeFromParent()
        }
        self.runAction(SKAction.sequence([explosionTimerRemove, removeExplosion]))
    }
    
    func fireProjectile(){
        let fireProjectileTimer = SKAction.waitForDuration(fireProjectileRate)
        
        let spawn = SKAction.runBlock{
            self.spawnProjectile()
        }
        
        let sequence = SKAction.sequence([fireProjectileTimer, spawn])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    
    func randomEnemyTimerSpawn(){
        
        let spawnEnemyTimer = SKAction.waitForDuration(enemySpawnRate)
        
        let spawn = SKAction.runBlock{
            self.spawnEnemy()
        }
        
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        
        self.runAction((SKAction.repeatActionForever(sequence)))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if (((firstBody.categoryBitMask == physicsCategory.projectile) && (secondBody.categoryBitMask == physicsCategory.enemy)) || ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.projectile))) {
            
            spawnExplosion(firstBody.node as! SKSpriteNode)
            projectileCollision(firstBody.node as! SKSpriteNode, projectileTemp: secondBody.node as! SKSpriteNode)
        }
        
        if (((firstBody.categoryBitMask == physicsCategory.player) && (secondBody.categoryBitMask == physicsCategory.enemy)) || ((firstBody.categoryBitMask == physicsCategory.enemy) && (secondBody.categoryBitMask == physicsCategory.player))){
            
            enemyPlayerCollision(firstBody.node as! SKSpriteNode, playerTemp: secondBody.node as! SKSpriteNode)
            
        }
    }
    
    func projectileCollision(enemyTemp: SKSpriteNode, projectileTemp: SKSpriteNode){
        enemyTemp.removeFromParent()
        projectileTemp.removeFromParent()
        
        score = score + 1
        
        updateScore()
        
    }
    
    func enemyPlayerCollision(enemyTemp: SKSpriteNode, playerTemp: SKSpriteNode){
        mainLabel?.fontSize = 50
        mainLabel?.alpha = 1.0
        mainLabel?.text = "Game Over"
        
        player?.removeFromParent()
        
        isAlive = false
        
        waitThenMoveToTitleScreen()
    }
    
    func waitThenMoveToTitleScreen(){
        let wait = SKAction.waitForDuration(3.0)
        let transition = SKAction.runBlock{
            self.view?.presentScene(TitleScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        }
        let sequence = SKAction.sequence([wait, transition])
        self.runAction(SKAction.repeatAction(sequence, count: 1))
    }
    
    func updateScore(){
        
        scoreLabel?.text = "Score: \(score)"
        
        
    }
    
    func hideLabel(){
        let wait = SKAction.waitForDuration(3.0)
        let hide = SKAction.runBlock{
            mainLabel?.alpha = 0.0
        }
        
        let sequence = SKAction.sequence([wait, hide])
        self.runAction(SKAction.repeatAction(sequence, count: 1))
    }
    
    func resetVariablesOnStart(){
        isAlive = true
        score = 0
        
    }
    
    
    
    
}
