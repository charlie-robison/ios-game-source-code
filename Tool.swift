//
//  Tool.swift
//  RPG
//
//  Created by Charlie Robison on 5/21/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class Tool {
    private var toolName: String;
    private var toolPrice = 0;
    
    init(toolName: String) {
        self.toolName = toolName;
        setAttrubutes();
    }
    
    /**Sets the price of each tool based on the name.
     *
     */
    func setAttrubutes() {
        switch toolName {
        case("Axe"):
            toolPrice = 300;
        case("Pickaxe"):
            toolPrice = 300;
        case("Fishing Rod"):
            toolPrice = 200;
        default:
            print("Unknown Tool");
        }
    }
    
    func getName() -> String {
        return toolName;
    }
    
    func getPrice() -> Int {
        return toolPrice;
    }
}
