//
//  GameScene.swift
//  JustPong
//
//  Created by Jacob Silva on 10/9/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()                                                               // ball sprite
    var enemy = SKSpriteNode()                                                              // enemy sprite
    var player = SKSpriteNode()                                                             // player sprite
    
    var score = [Int]()                                                                     // score value
    
    var topLabel = SKLabelNode()                                                            // enemy score
    var botLabel = SKLabelNode()                                                            // player score
    
    var countdownLabel = SKLabelNode()                                                      // countdown timer label
    
    var restartLabel = SKLabelNode()                                                        // restart words label
    var restartButton = SKSpriteNode()                                                      // restart button sprite
    
    var winnerLabel = SKLabelNode()                                                         // winner announcement label
    
    var xSpeed = 25                                                                         // x speed initalizer
    var ySpeed = 25                                                                         // y speed initalizer
    
    var gameOver = false                                                                    // check if game over initializer
    
    override func didMove(to view: SKView) {
        
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode                            // connect names with sprites/labels
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        player = self.childNode(withName: "player") as! SKSpriteNode
        
        topLabel = self.childNode(withName: "enemyScore") as! SKLabelNode
        botLabel = self.childNode(withName: "playerScore") as! SKLabelNode
        
        countdownLabel = self.childNode(withName: "countdown") as! SKLabelNode
        countdownLabel.isHidden = true
        
        restartLabel = self.childNode(withName: "restart") as! SKLabelNode
        restartLabel.isHidden = true
        restartButton = self.childNode(withName: "restartButton") as! SKSpriteNode
        restartButton.isHidden = true
        
        winnerLabel = self.childNode(withName: "winner") as! SKLabelNode
        winnerLabel.isHidden = true

        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)                                // define border for physics
        
        border.friction = 0                                                                 // 0 friction between objects
        border.restitution = 1                                                              // no air resistance factor
        border.categoryBitMask = 1                                                          // physics body property to the border

        self.physicsBody = border
        
        startGame()                                                                         // start game function
        
    }
    
    
    func checkWinner() {                                                                    // play till 11 win by 2
        if (score[0] >= 11 && score[0] - score[1] >= 2) {
            gameOver = true
            displayWinner(winner: "PLAYER WINS")
        } else if (score[1] >= 11 && score[1] - score[0] >= 2) {
            gameOver = true
            displayWinner(winner: "R0B0T WINS")
        }
    }
    
    func startCountdown() {                                                                  // countdown for kickoff
        countdownLabel.isHidden = false
        ball.isHidden = true

        let countdownSequence = SKAction.sequence([
            SKAction.run { self.countdownLabel.text = "3" },
            SKAction.wait(forDuration: 1),
            SKAction.run { self.countdownLabel.text = "2" },
            SKAction.wait(forDuration: 1),
            SKAction.run { self.countdownLabel.text = "1" },
            SKAction.wait(forDuration: 1),
            SKAction.run { self.countdownLabel.text = "GO!" },
            SKAction.wait(forDuration: 0.5),
            SKAction.run {
                self.ball.isHidden = false
                self.countdownLabel.isHidden = true
                // Only apply impulse after the countdown finishes
                self.ball.physicsBody?.applyImpulse(CGVector(dx: self.xSpeed,
                                                             dy: self.ySpeed))
            }
        ])

        self.run(countdownSequence)
    }
    
    func displayWinner(winner: String) {                                                    // win game condition
        // Stop the ball
        ball.physicsBody?.velocity = CGVector(dx: 0,
                                              dy: 0)
        winnerLabel.isHidden = false
        winnerLabel.text = winner
        restartLabel.isHidden = false
        restartButton.isHidden = false
        
        player.isHidden = true
        enemy.isHidden = true
        ball.isHidden = true
    }
    
    func startGame() {                                                                       // start game function
        gameOver = false
        score = [0,0]
        topLabel.text = "\(score[1])"
        botLabel.text = "\(score[0])"
        startCountdown()
    }
    
    func addScore(playerWhoWon : SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0,
                                              dy: 0)
        
        if playerWhoWon == player {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -Int.random(in: 10..<35),           // apply random x impluse
                                                    dy: -ySpeed ))
        }
        else if playerWhoWon == enemy {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: 10..<35),            // apply random x impluse
                                                    dy: ySpeed ))
        }
        
        topLabel.text = "\(score[1])"
        botLabel.text = "\(score[0])"
        
        checkWinner()
    }
    
    func restartGame() {                                                                     // restart game function
        // Reset the score
        restartLabel.isHidden = true
        restartButton.isHidden = true
        winnerLabel.isHidden = true
        
        player.isHidden = false
        enemy.isHidden = false
        ball.isHidden = false
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,                                     // check for touch input
                               with event: UIEvent?) {
        if gameOver {
            restartGame()
        } else {
            for touch in touches {
                let location = touch.location(in: self)
                if location.y < -75 {
                    player.run(SKAction.moveTo(x: location.x,
                                               duration: 0.005))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,                                     // update touch input
                               with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.y < -75 {
                player.run(SKAction.moveTo(x: location.x,
                                           duration: 0.005))
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        switch currentDifficulty {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x,
                                      duration: 0.2))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x,
                                      duration: 0.1))
            xSpeed = 26
            ySpeed = 26
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x,
                                      duration: 0.09))
            xSpeed = 27
            ySpeed = 27
            break
        }
        
        
        if ball.position.y <= player.position.y - 70 {
            addScore(playerWhoWon: enemy)
            enemy.position.x = 0
        }
        else if ball.position.y >= enemy.position.y + 70 {
            addScore(playerWhoWon: player)
            enemy.position.x = 0
        }
            
    }
}
