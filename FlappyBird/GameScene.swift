//
//  GameScene.swift
//  FlappyBird
//
//  Created by Peter Regard on 2/21/15.
//  Copyright (c) 2015 Samurai Technology. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipeUp = SKSpriteNode()
    var pipeDown = SKSpriteNode()
    var birdTexture = SKTexture(imageNamed:"Tardis1.png")
    var birdTexture2 = SKTexture(imageNamed:"Tardis4.png")
    var birdTexture3 = SKTexture(imageNamed: "Tardis3.png")
    var bgTexture = SKTexture(imageNamed:"img/bg.png")
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    let gapGroup:UInt32 = 0 << 3
    var gameOver = 0
    var objects = SKNode()
    var spawn = NSTimer()
    var score = 0
    var label = SKLabelNode()
    var i = 0
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0, -7)
        self.physicsWorld.contactDelegate = self
        self.addChild(objects)
        
        
        
        
        
        
        
        /*_________________________________________________________________________
                        Background*/
        
        

            var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        
            var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        
            var movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
        
        for var i:CGFloat=0; i<3; i++ {
        
            bg = SKSpriteNode(texture: bgTexture)
        
            bg.position = CGPoint(x: bgTexture.size().width/2+bgTexture.size().width*i, y: CGRectGetMidY(self.frame))
            
            bg.size.height = self.frame.height
            
            
            bg.runAction(movebgForever)
        objects.addChild(bg)
        }
        //_______________________________________________________________________
        //             Pipes
        

        spawn = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "result", userInfo: nil, repeats: true)
        
       
       
        //_____________________________________________________________________
        //              Bird
        
        
        
            var animation = SKAction.animateWithTextures([birdTexture, birdTexture2, birdTexture3, birdTexture2], timePerFrame: 0.5)
        
            var makeBirdFlap = SKAction.repeatActionForever(animation)
        
        
            bird = SKSpriteNode(texture: birdTexture2)
        
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
            bird.runAction(makeBirdFlap)
        
        //______________________________________________________________________
        //              Bird Physics
        
            bird.physicsBody = SKPhysicsBody (rectangleOfSize:CGSizeMake(40, 70))
            bird.physicsBody?.dynamic = true
            bird.physicsBody?.allowsRotation = false
            bird.physicsBody?.categoryBitMask = birdGroup
            bird.physicsBody?.contactTestBitMask = objectGroup
            bird.physicsBody?.collisionBitMask = gapGroup
            bird.zPosition = 10
            self.addChild(bird)
        /*__________________________________________________________________________
            Ground Collision   */
        
        var ground = SKNode()
            ground.position = CGPointMake(0,0)
            ground.physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(self.frame.size.width, 1))
            ground.physicsBody?.dynamic = false
            ground.physicsBody?.categoryBitMask = objectGroup
        
            self.addChild(ground)
        //___________________________________________________________________________
        
       
    
    
    
    }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        

        gameOver = 1
        
            objects.speed = 0}
        
    
    func result(){
        if gameOver == 0{
        var pipeUpTexture = SKTexture(imageNamed:"img/pipe2.png")
        var pipeDownTexture = SKTexture(imageNamed: "img/pipe1.png")
        
        let gapHeight = birdTexture.size().height * 3
        
        var movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        var pipeOffSet = CGFloat(movementAmount) - self.frame.size.height / 4
        
        
        pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeDown = SKSpriteNode(texture: pipeDownTexture)
        
        pipeUp.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame)-pipeUp.size.height/2 - gapHeight/2 + pipeOffSet)
        pipeDown.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame)+pipeDown.size.height/2 + gapHeight/2 + pipeOffSet)
        
        var movePipes = SKAction.moveByX(-self.frame.size.width-296, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        
        var removePipes = SKAction.removeFromParent()
        
        var moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
                    
                    pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
                    pipeUp.physicsBody?.dynamic = false
                    
                    pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
                    pipeDown.physicsBody?.dynamic = false
            
        var gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMaxX(self.frame), y: CGRectGetMidY(self.frame) + pipeOffSet)
            gap.runAction(moveAndRemovePipes)
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = gapGroup
            objects.addChild(gap)
            
            
        
        //                      Pipe1
        
        pipeUp.runAction(moveAndRemovePipes)
        
        objects.addChild(pipeUp)
        
        //                      Pipe2
        pipeDown.runAction(moveAndRemovePipes)
        
        objects.addChild(pipeDown)
        }
}
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameOver == 0{
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 55))}
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
