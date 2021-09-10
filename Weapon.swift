//
//  Weapon.swift
//  RPG
//
//  Created by Charlie Robison on 5/21/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class Weapon {
    private var weaponName: String;
    private var weaponPrice = 0;
    private var weaponPower = 0;
    
    init(weaponName: String) {
        self.weaponName = weaponName;
        setAttributes();
    }
    
    /**Sets the attributes for the sword.
     *
     */
    func setAttributes() {
        switch weaponName {
        case("Small Sword"):
            weaponPrice = 20;
            weaponPower = 5;
        case("Broadsword"):
            weaponPrice = 200;
            weaponPower = 20;
        case("Golden Sword"):
            weaponPrice = 10000
            weaponPower = 50;
        case("Jade Blade"):
            weaponPrice = 500000000;
            weaponPower = 200;
        case("Silver Knife"):
            weaponPrice = 10;
            weaponPower = 3;
        case("Golden Knife"):
            weaponPrice = 100;
            weaponPower = 15;
        case("Jade Knife"):
            weaponPrice = 20000;
            weaponPower = 100;
        default:
            print("Weapon doesn't exist");
        }
    }
    
    func getName() -> String {
        return weaponName;
    }
    
    func getPrice() -> Int {
        return weaponPrice;
    }
    
    func getPower() -> Int {
        return weaponPower;
    }
}
