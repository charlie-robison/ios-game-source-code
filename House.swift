//
//  House.swift
//  RPG
//
//  Created by Charlie Robison on 5/27/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class House {
    private var house: SKSpriteNode!;
    private var shadow: SKSpriteNode!;
    private var block: SKSpriteNode!;
    private var price: Int;
    private var numberOfMaterials: [Int];
    
    init() {
        self.house = SKSpriteNode(imageNamed: "Hut");
        self.house.name = "Hut";
        self.house.scale(to: CGSize(width: 80, height: 80));
        self.house.zPosition = 2;
        self.shadow = SKSpriteNode(imageNamed: "Hut_Shadow");
        self.shadow.name = "Hut_Shadow";
        self.shadow.scale(to: CGSize(width: 80, height: 80));
        self.shadow.zPosition = 0;
        self.block = SKSpriteNode(color: UIColor.black, size: CGSize(width: 40, height: 24));
        self.block.alpha = 0.0;
        self.block.name = "House";
        self.block.physicsBody = SKPhysicsBody(rectangleOf: block.size);
        self.block.physicsBody?.restitution = 0;
        self.block.physicsBody?.affectedByGravity = false;
        self.block.physicsBody?.allowsRotation = false;
        self.block.physicsBody?.linearDamping = 0;
        self.block.physicsBody?.angularDamping = 0;
        self.block.physicsBody?.friction = 0;
        self.block.physicsBody?.isDynamic = false;
        
        self.price = 100;
        //10 wood, 5 bricks, 0 steel.
        self.numberOfMaterials = [10, 5, 0];
    }
    
    func getHouse() -> SKSpriteNode {
        return house;
    }
    
    func getShadow() -> SKSpriteNode {
        return shadow;
    }
    
    func getBlock() -> SKSpriteNode {
        return block;
    }
    
    func getPrice() -> Int {
        return price;
    }
    
    func getNumberOfMaterials() -> [Int] {
        return numberOfMaterials;
    }
    
}
