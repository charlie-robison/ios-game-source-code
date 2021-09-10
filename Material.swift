//
//  Material.swift
//  RPG
//
//  Created by Charlie Robison on 5/22/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class Material {
    private var materialName: String;
    private var materialPrice = 0;
    
    init(materialName: String) {
        self.materialName = materialName;
        setAttributes();
    }
    
    /**Sets attributes for the materials.
     *
     */
    func setAttributes() {
        switch materialName {
        case("Wood"):
            materialPrice = 100;
        case("Bricks"):
            materialPrice = 300;
        case("Steel"):
            materialPrice = 1500;
        default:
            print("Material Doesn't Exist!");
        }
    }
    
    func getName() -> String {
        return materialName;
    }
    
    func getPrice() -> Int {
        return materialPrice;
    }
    
    func getHash() -> Int {
        switch materialName {
        case("Wood"):
            return 0;
        case("Bricks"):
            return 1;
        case("Steel"):
            return 2;
        default:
            return -1;
        }
    }
}
