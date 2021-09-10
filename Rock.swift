//
//  Rock.swift
//  RPG
//
//  Created by Charlie Robison on 5/22/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class Rock {
    private var rock: SKSpriteNode!;
    
    init() {
        self.rock = SKSpriteNode(imageNamed: "Rock.png");
        self.rock.name = "Rock";
        self.rock.scale(to: CGSize(width: 30, height: 30));
        self.rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size);
        self.rock.physicsBody?.restitution = 0;
        self.rock.physicsBody?.affectedByGravity = false;
        self.rock.physicsBody?.allowsRotation = false;
        self.rock.physicsBody?.linearDamping = 0;
        self.rock.physicsBody?.angularDamping = 0;
        self.rock.physicsBody?.friction = 0;
        self.rock.physicsBody?.isDynamic = false;
        
    }
    
    func getRock() -> SKSpriteNode {
        return rock;
    }
}

class Tree {
    private var tree: SKSpriteNode!;
    private var shadow: SKSpriteNode!;
    private var trunk: SKSpriteNode!;
    
    init() {
        self.tree = SKSpriteNode(imageNamed: "Basic_Tree.png");
        self.tree.name = "Tree";
        self.tree.scale(to: CGSize(width: 70, height: 70));
        self.tree.zPosition = 2;
        self.shadow = SKSpriteNode(imageNamed: "Basic_Tree_Shadow.png");
        self.shadow.name = "Tree_Shadow";
        self.shadow.scale(to: CGSize(width: 70, height: 70));
        self.shadow.zPosition = 0;
        self.trunk = SKSpriteNode(color: UIColor.black, size: CGSize(width: 18, height: 15));
        self.trunk.alpha = 0.0;
        self.trunk.name = "Trunk";
        
        self.trunk.physicsBody = SKPhysicsBody(rectangleOf: trunk.size);
        self.trunk.physicsBody?.restitution = 0;
        self.trunk.physicsBody?.affectedByGravity = false;
        self.trunk.physicsBody?.allowsRotation = false;
        self.trunk.physicsBody?.linearDamping = 0;
        self.trunk.physicsBody?.angularDamping = 0;
        self.trunk.physicsBody?.friction = 0;
        self.trunk.physicsBody?.isDynamic = false;
    }
    
    func getTree() -> SKSpriteNode {
        return tree;
    }
    
    func getShadow() -> SKSpriteNode {
        return shadow;
    }
    
    func getTrunk() -> SKSpriteNode {
        return trunk;
    }
}
