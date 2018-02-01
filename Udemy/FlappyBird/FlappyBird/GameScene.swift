//
//  GameScene.swift
//  FlappyBird
//
//  Created by Aliona on 04/09/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var ground = SKNode()
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()

    var gameOver = false
    var score = 0
    let gapHeight : CGFloat = 350.0

    var timer = Timer()
    
    enum ColliderType : UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    var movementAmount : CGFloat {
        get {
            return CGFloat(arc4random() % UInt32(self.frame.height / 2))
        }
    }
    var pipeOffset : CGFloat {
        get {
            return movementAmount - self.frame.height / 4
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setupGame()
    }

    func setupGame() {

        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addPipes), userInfo: nil, repeats: true)

        addBackground()
        addPipes()
        addGround()
        addBird()
        addGameOverLabel()
    }

    private func addGameOverLabel() {
        gameOverLabel.text = "GAME OVER!"
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 30
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
    }
    
    private func addBackground() {
        
        let texture = SKTexture(imageNamed: "bg.png")
        
        let move = SKAction.move(by: CGVector(dx: -texture.size().width, dy: 0), duration: 5)
        let shiftBackgroundAnimation = SKAction.move(by: CGVector(dx: texture.size().width, dy: 0), duration: 0)
        let animateBackground = SKAction.repeatForever(SKAction.sequence([move, shiftBackgroundAnimation]))
        
        for i in 0...3 {
        
            background = SKSpriteNode(texture: texture)
            
            background.position = CGPoint(x: texture.size().width * CGFloat(i), y: self.frame.midY)
            background.size.height = self.frame.height
            
            background.run(animateBackground)
            background.zPosition = -1
            
            addChild(background)
            
        }

        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 50
        scoreLabel.color = .black
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height / 2 - 70)

        addChild(scoreLabel)
    }
    
    @objc private func addPipes() {
        let move = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))

        let texture = SKTexture(imageNamed: "pipe1.png")
        
        let pipe = SKSpriteNode(texture: texture)
        let offset = gapHeight * CGFloat(arc4random_uniform(100)) / 100.0
        pipe.position = CGPoint(x: self.frame.midX + frame.width, y: self.frame.midY + texture.size().height / 2 + offset)
        pipe.run(move)
        
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipe.size)
        pipe.physicsBody?.isDynamic = false
        
        pipe.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe.physicsBody?.categoryBitMask =  ColliderType.Object.rawValue
        pipe.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        addChild(pipe)
        
        let texture2 = SKTexture(imageNamed: "pipe2.png")
        
        let pipe2 = SKSpriteNode(texture: texture2)
        let offset2 = gapHeight - offset
        pipe2.position = CGPoint(x: self.frame.midX + frame.width, y: self.frame.midY - texture.size().height / 2 - offset2)
        pipe2.run(move)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2.size)
        pipe2.physicsBody?.isDynamic = false
        
        pipe2.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.categoryBitMask =  ColliderType.Object.rawValue
        pipe2.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        addChild(pipe2)

        let gap = SKNode()
        gap.position = CGPoint(x: frame.midX + frame.width, y: gapHeight / 2 - offset2)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: texture.size().width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.run(move)

        gap.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody?.categoryBitMask =  ColliderType.Gap.rawValue
        gap.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue

        addChild(gap)
    }
    
    private func addBird() {
        
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.5)
        let flap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture1)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(flap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height / 2)
        bird.physicsBody?.isDynamic = false
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody?.categoryBitMask =  ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        addChild(bird)
    }
    
    private func addGround() {
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: self.frame.width, height: 1.0))
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.categoryBitMask =  ColliderType.Object.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        addChild(ground)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        guard !gameOver else {
            return
        }

        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue
        || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score += 1
            scoreLabel.text = String(score)
        } else {
            self.speed = 0
            gameOver = true
            timer.invalidate()
            gameOverLabel.isHidden = false

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !gameOver {
            
            bird.physicsBody?.isDynamic = true
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector.init(dx: 0, dy: 50))
            
        } else {

            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setupGame()

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
