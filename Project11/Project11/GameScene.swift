//
//  GameScene.swift
//  Project11
//
//  Created by Lareen Melo on 10/10/19.
//  Copyright © 2019 Lareen Melo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var remainingBallsLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    var resultLabel: SKLabelNode!

    let colors = ["Blue", "Yellow", "Purple", "Grey", "Red", "Cyan", "Green"]
    var remainingBalls = 5 {
        didSet {
            remainingBallsLabel.text = "Remaining balls: \(remainingBalls)"
        }
    }

    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        remainingBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingBallsLabel.text = "Remaining balls: \(remainingBalls)"
        remainingBallsLabel.horizontalAlignmentMode = .right
        remainingBallsLabel.position = CGPoint(x: 980, y: 700)
        addChild(remainingBallsLabel)
        
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "New game"
        newGameLabel.position = CGPoint(x: 130, y: 700)
        addChild(newGameLabel)
        
        resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        resultLabel.text = ""
        resultLabel.horizontalAlignmentMode = .center
        resultLabel.position = CGPoint(x: 512, y: 700)
        addChild(resultLabel)

        
        newGame()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            if objects.contains(newGameLabel) {
                newGame()
            }         else if remainingBalls > 0 && !isBallInPlay() {
                var ballColor = ""
                if let color = colors.randomElement() {
                    ballColor = "ball\(color)"
                } else {
                    ballColor = "ballRed"
                }
                
                let ball = SKSpriteNode(imageNamed: ballColor)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.physicsBody?.restitution = 0.4
                ball.position = CGPoint(x: location.x, y: 700)
                ball.name = "ball"
                addChild(ball)
            }

            

            
//            if objects.contains(editLabel) {
//                editingMode.toggle()
//            } else {
//                if editingMode {
//                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
//                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
//                    box.zRotation = CGFloat.random(in: 0...3)
//                    box.position = location
//                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
//                    box.physicsBody?.isDynamic = false
//
//                    addChild(box)
//
//                } else {
//                    var ballColor = ""
//                    if let color = colors.randomElement() {
//                         ballColor = "ball\(color)"
//                    } else {
//                        ballColor = "ballRed"
//                    }
//
//                    let ball = SKSpriteNode(imageNamed: ballColor)
//                    ball.name = "ball"
//                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
//                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
//                    ball.physicsBody?.restitution = 0.4
//                    ball.position = CGPoint(x: location.x, y: 680)
//                    addChild(ball)
//
//                }
//            }
        }
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    func isBallInPlay() -> Bool {
        for node in self.children {
            if node.name == "ball" {
                return true
            }
        }
        return false
    }

    
    func isRemainingBoxes() -> Bool {
        for node in self.children {
            if node.name == "box" {
                return true
            }
        }
        return false
    }
    
    func newGame() {
        remainingBalls = 5
        
        resultLabel.text = ""
        
        for node in self.children {
            if node.name == "box" || node.name == "ball" {
                node.removeFromParent()
            }
        }
        
        createObstacles(15)
    }
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
            
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
            
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            remainingBalls += 1
            manageResult()

        } else if object.name == "bad" {
            destroy(ball: ball)
            remainingBalls -= 1
            manageResult()

        } else if object.name == "box" {
            object.removeFromParent()
        }
    }
    
    func manageResult() {
        if !isRemainingBoxes() {
            resultLabel.fontColor = UIColor.green
            resultLabel.text = "VICTORY"
        }
        else if remainingBalls == 0 {
            resultLabel.fontColor = UIColor.red
            resultLabel.text = "DEFEAT"
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func remainingObstacles() -> Bool {
        for node in self.children {
            if node.name == "box" {
                return true
            }
        }
        return false
    }
    
    func createObstacles(_ number:  Int) {
        for _ in 1...number {
            let size = CGSize(width: Int.random(in: 16...128), height: 16)
            let position = CGPoint(x: CGFloat.random(in: 120...830), y: CGFloat.random(in: 200...668))
            let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
            
            box.zRotation = CGFloat.random(in: 0...3)
            box.position = position
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            box.name = "box"
            
            addChild(box)
        }
    }
}
