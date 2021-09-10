//
//  Player.swift
//  RPG
//
//  Created by Charlie Robison on 5/13/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

//Creates a new Player and adds it sprite node properties. 
class Player {
    
    private var player: SKSpriteNode;
    
    //Player Stats
    private var money: Int;
    private var level: Int;
    private var exp: Int;
    private var maxExp: Int;
    private var attack: CGFloat;
    private var defense: CGFloat;
    private var maxHealth: CGFloat;
    
    init() {
        self.player = SKSpriteNode(color: UIColor.black, size: CGSize(width: 20, height: 20));
        self.player.position = CGPoint(x: -150, y: -150);
        player.name = "Player";
        player.zPosition = 1;
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size);
        player.physicsBody?.restitution = 0;
        player.physicsBody?.affectedByGravity = false;
        player.physicsBody?.allowsRotation = false;
        player.physicsBody?.linearDamping = 0;
        player.physicsBody?.angularDamping = 0;
        player.physicsBody?.friction = 0;
        
        //Player stats
        self.money = 0;
        self.level = 1;
        self.exp = 0;
        self.maxExp = 5;
        self.attack = 13.0;
        self.defense = 60;
        self.maxHealth = 100.0;
    }
    
    func getPlayer() -> SKSpriteNode {
        return player;
    }
    
    func getMoney() -> Int {
        return money;
    }
    
    func setMoney(newVal: Int) {
        money = newVal;
    }
    
    func addMoney(addedMoney: Int) {
        money += addedMoney;
    }
    
    func subtractMoney(subMoney: Int) {
        money -= subMoney;
    }
    
    func getMaxHealth() -> CGFloat {
        return maxHealth;
    }
    
    func addExp(addedExp: Int) {
        exp += addedExp;
        if (exp >= maxExp) {
            if (exp == maxExp) {
                exp = 0;
            } else {
                exp = exp - maxExp;
            }
            level += 1;
            attack = pow(2.0, (CGFloat(level) - 3.0)) + 13.0;
            defense += 4;
            maxExp = 5 * maxExp;
            maxHealth += 10;
            return;
        }
    }
    
    func getLevel() -> Int {
        return level;
    }
    
    func setLevel(currentLevel: Int) {
        level = currentLevel;
        /*
        attack = pow(2.0, (CGFloat(level) - 3.0)) + 13.0;
        defense += CGFloat(level * 4);
        maxExp = Int(pow(CGFloat(maxExp), CGFloat((5 * level))));
        maxHealth += CGFloat(10 * level);*/
        //return;
    }
    
    func getExp() -> Int {
        return exp;
    }
    
    func getMaxExp() -> Int {
        return maxExp;
    }
    
    func getAttack() -> CGFloat {
        return attack;
    }
    
    func addAttack(attackVal: CGFloat) {
        attack += attackVal;
    }
    
    func subAttack(attackVal: CGFloat) {
        attack -= attackVal;
    }
    
    func getDefense() -> CGFloat {
        return defense;
    }
 
}
