//
//  Potion.swift
//  RPG
//
//  Created by Charlie Robison on 5/19/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class Potion {
    private var potionName: String;
    private var potionPrice = 0;
    
    init(potionName: String) {
        self.potionName = potionName;
        setAttributes();
    }
    
    /**Sets potion's attributes.
     *
     */
    func setAttributes() {
        switch potionName {
        case("Energy Potion"):
            potionPrice = 50;
        case("Health Potion"):
            potionPrice = 100;
        case("Lethal Potion"):
            potionPrice = 300;
        default:
            print("Potion doesn't exist!");
        }
    }
    
    func getPotionName() -> String {
        return potionName;
    }
    
    func getPotionPrice() -> Int {
        return potionPrice;
    }
}

class EnergyPotion: Potion {
    private var energyValue: CGFloat;
    
    init() {
        self.energyValue = 30;
        super.init(potionName: "Energy Potion");
    }
    
    func getEnergyValue() -> CGFloat {
        return energyValue;
    }
}

class HealthPotion: Potion {
    private var healthValue: CGFloat;
    
    init() {
        self.healthValue = 50;
        super.init(potionName: "Health Potion");
    }
    
    func getHealthValue() -> CGFloat {
        return healthValue;
    }
}

class LethalPotion: Potion {
    private var damageValue: CGFloat;
    
    init() {
        self.damageValue = 50;
        super.init(potionName: "Lethal Potion");
    }
    
    func getDamageValue() -> CGFloat {
        return damageValue;
    }
}

