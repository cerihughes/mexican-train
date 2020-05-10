//
//  GameScene.swift
//  MexicanTrain
//
//  Created by Ceri on 09/05/2020.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        label = childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Create shape node to use during mouse interaction
        let w = (size.width + size.height) * 0.05
        spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
            ]))
        }
    }

    func touchDown(atPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.green
            addChild(n)
        }
    }

    func touchMoved(toPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.blue
            addChild(n)
        }
    }

    func touchUp(atPoint pos: CGPoint) {
        if let n = spinnyNode?.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.red
            addChild(n)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction(named: "Pulse")!, withKey: "fadeInOut")
        }

        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
