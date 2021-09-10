//
//  Enemy.swift
//  RPG
//
//  Created by Charlie Robison on 5/18/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

//Creates a new Enemy and adds it sprite node properties.
class Enemy {
    
    private var enemy: SKSpriteNode;
    
    //Enemy Stats
    private var enemyHealth: Int = 0;
    private var enemyMaxHealth: Int = 20;
    private var enemyLevel: Int;
    private var enemyAttack: CGFloat = 0;
    private var enemyDefense: CGFloat = 0;
    
    init(enemyLevel: Int) {
        self.enemy = SKSpriteNode(color: UIColor.red, size: CGSize(width: 20, height: 20));
        enemy.name = "Enemy";
        enemy .physicsBody = SKPhysicsBody(rectangleOf: enemy.size);
        enemy.physicsBody?.restitution = 0;
        enemy.physicsBody?.affectedByGravity = false;
        enemy.physicsBody?.allowsRotation = false;
        enemy.physicsBody?.linearDamping = 0;
        enemy.physicsBody?.angularDamping = 0;
        enemy.physicsBody?.friction = 0;
        
        self.enemyLevel = enemyLevel;
        setStats();
    }
    
    /**Sets the stats for the enemy based on the level.
     *
     */
    func setStats() {
        let initialHealth: CGFloat = 50;
        enemyMaxHealth = 15 * (enemyLevel - 1) + Int(initialHealth);
        let initialAttack: CGFloat = 8;
        enemyAttack = CGFloat(5 * (enemyLevel - 1)) + initialAttack;
        let  initialDefense: CGFloat = 50;
        enemyDefense = CGFloat(initialDefense * pow(1.5, CGFloat(enemyLevel)));
        enemyHealth = enemyMaxHealth;
    }
    
    func getEnemy() -> SKSpriteNode {
        return enemy;
    }
    
    func getLevel() -> Int {
        return enemyLevel;
    }
    
    func getHealth() -> Int {
        return enemyHealth;
    }
    
    func getMaxHealth() -> Int {
        return enemyMaxHealth;
    }
    
    
    func getAttack() -> CGFloat {
        return enemyAttack;
    }
    
    func getDefense() -> CGFloat {
        return enemyDefense;
    }
    
    func takeDamage(damage: CGFloat) {
        enemyHealth -= Int(damage);
    }
    
    /**Returns the exp gained by the player once the enemy is defeated.
     */
    func expGiven() -> Int {
        let expGained = 10 * (enemyLevel * enemyLevel);
        return expGained;
    }
}
