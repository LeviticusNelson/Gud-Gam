//
//  GameScene.swift
//  Gud Gam
//
//  Created by Levi Nelson and Tanner Leslie on 9/29/19.
//  Copyright © 2019 Get Swifty. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    // Initializing node variables as well as the the score
    var mineCart: SKSpriteNode!
    var rock: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    var scoreBoard: SKLabelNode!
    var score:Int = 0

    
    //this function allows the scene to run on the phone
    override func didMove(to view: SKView) {
        gameScene()
    }
    
    //This struct defines the different physics catagories, so that we can define which physical object can detect contact with one another
    struct PhysicsCatagory {
        static let mineCart:UInt32 = 1 ; static let ground:UInt32 = 2
        static let rock:UInt32 = 3
    }
    
    // This function adds the properties of each node (object) within the scene and
    func gameScene(){
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        // Initializing the node for the score in the lower left corner of the screen
        scoreBoard = SKLabelNode(fontNamed: "AmericanTypewriter")
        scoreBoard.text = "Score: 0"
        scoreBoard.fontSize = 65
        scoreBoard.fontColor = SKColor.black
        scoreBoard.horizontalAlignmentMode = .left
        scoreBoard.verticalAlignmentMode = .bottom
        scoreBoard.position = CGPoint(x: frame.minX + 20, y: frame.minY + 15)
        addChild(scoreBoard)
        
        // Initializing the minecart node as well as the properties of what contact type it is
        mineCart = SKSpriteNode(imageNamed: "mineCart")
        mineCart.name = "mineCart"
        mineCart.size = CGSize(width: frame.size.width/15, height: frame.size.width/15)
        mineCart.position = CGPoint(x: frame.size.width / 8, y: frame.midY + 24)
        mineCart.physicsBody = SKPhysicsBody(rectangleOf: mineCart.size)
        mineCart.physicsBody?.affectedByGravity = true
        mineCart.physicsBody?.allowsRotation = false
        mineCart.physicsBody?.restitution = 0.0
        mineCart.physicsBody?.categoryBitMask = PhysicsCatagory.mineCart
        mineCart.physicsBody?.collisionBitMask = PhysicsCatagory.ground | PhysicsCatagory.rock
        mineCart.physicsBody?.contactTestBitMask = PhysicsCatagory.ground | PhysicsCatagory.rock
        addChild(mineCart)

        
        // Initializing the ground node as well as the properites of contact catagory
        var splinePoints = [CGPoint(x: 0, y: frame.midY - 5), CGPoint(x: frame.size.width, y: frame.midY - 5)]
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.lineWidth = 5
        ground.name = "ground"
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        ground.physicsBody?.restitution = 0.0
        // Not dynamic means that other nodes cannot affect the node
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.ground
        ground.physicsBody?.collisionBitMask = 0
        addChild(ground)
        
        // function that spawns the rock
        spawnRock()

        // Initalizing gravity within the scene, affects the minecart, but not the rock
        physicsWorld.gravity = CGVector(dx:0, dy: -10)
        
        // This creates a frame around the scene so that the minecart cannot move further out of the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
    }
    
    // randX creates a smaller randomness to where the rock spawns outside the scene
    static var randX = CGFloat.random(in: 10..<100)
    static var difficultyNum = 0.0
    
    func spawnRock() {
        
        // Initialization of node rock
        rock = SKSpriteNode(imageNamed: "rock")
        rock.name = "rock"
        rock.size = CGSize(width: frame.size.width/15, height: frame.size.width/15)
        rock.position = CGPoint(x: frame.size.width + GameScene.randX, y: frame.midY + 26)
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody?.affectedByGravity = false
        rock.physicsBody?.allowsRotation = true
        rock.physicsBody?.isDynamic = false
        rock.physicsBody?.restitution = 0.0
        rock.physicsBody?.categoryBitMask = PhysicsCatagory.rock
        rock.physicsBody?.collisionBitMask = 0

        addChild(rock)
        
        // SKActions moveRock and rotateRock allow the rock to "roll" across the screen
        let moveRock = SKAction.moveTo(x: -100.0, duration: TimeInterval(GameScene.difficultyNum))
        let rotateRock = SKAction.rotate(byAngle: 1080.0, duration: 100)
        rock.run(rotateRock)
        
        // Once the action of moveRock is finished, the score increases by 100, the rock node is deleted, a new rock node is added and difficultyNum gets closer to 1 but never equals to 1, allowing the time of the rock to move across the screen to decrease, making the speed increase.
        rock.run(moveRock) {
            self.scoreBoard.text = "Score: \(self.score)"
            GameScene.difficultyNum = (1 / log10((Double(self.score + 100) / 100.0) + 1))
            self.rock.removeFromParent()
            self.rock = nil
            GameScene.randX = CGFloat.random(in: 10..<100)
            self.spawnRock()
            self.score += 100
            
        }
        
    }
    
    // This is the scene that occurs if the rock is in contact with the minecart, which initializes the label "Tap to Restart" as well as the score of that game.
    static var overHuh:Bool = false
    func gameOverScene(){
        GameScene.overHuh = true
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        let gameOverLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        gameOverLabel.text = "Tap to Restart"
        gameOverLabel.fontSize = 65
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreBoard.position = CGPoint(x: frame.midX, y: frame.midY - 80)
        scoreBoard.horizontalAlignmentMode = .center
        scoreBoard.verticalAlignmentMode = .bottom
        addChild(scoreBoard)
        addChild(gameOverLabel)
    }
    
    // Boolean to see if mincart is on ground
    static var 🛤 = true

    // Called when contact ends between two nodes
    // Checks whether is the minecart is on ground, changes 🛤 to true if minecart has contacted ground
    func didEnd(_ contact: SKPhysicsContact) {
        if !(contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "mineCart") || !(contact.bodyA.node?.name == "mineCart" && contact.bodyB.node?.name == "ground") {
            GameScene.🛤 = false
        } else {
            GameScene.🛤 = true
        }
    }
    
    // Called when contact starts between two nodes
    // Checks to see if minecart has contacted ground and if rock has contacted the mincart
    // Starts gameOverScene() and removes previous nodes if rock has contacted minecart
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ground" && contact.bodyB.node?.name == "mineCart") || (contact.bodyA.node?.name == "mineCart" && contact.bodyB.node?.name == "ground") {
                   GameScene.🛤 = true
               } else {
                   GameScene.🛤 = false
               }
        if (contact.bodyA.node?.name == "rock" && contact.bodyB.node?.name == "mineCart") || (contact.bodyA.node?.name == "mineCart" && contact.bodyB.node?.name == "rock") {
            self.removeAllChildren()
            gameOverScene()
        }
    }
    // Called when the user is has touched the screen
    // When the minecart is touching the ground, the mincart can jump
    // When the scene is gameOverScene, the gameOverScene nodes are removed and the game restarts
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if GameScene.🛤 == true{
        mineCart.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90), at: mineCart.position)
        }
        if GameScene.overHuh == true {
            GameScene.overHuh = false
            removeAllChildren()
            GameScene.difficultyNum = 0
            score = 0
            gameScene()
        }
    }
}

