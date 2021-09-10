//
//  ItemDatabase.swift
//  RPG
//
//  Created by Charlie Robison on 5/16/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

//Stores all item names in an array and all item images in an array.
//Access to both arrays are given.
class ItemDataBase {
    
    //Arrays for items.
    private var swords: [String];
    private var knives: [String];
    private var potions: [String];
    private var materials: [String];
    private var tools: [String];
    //Arrays for item images.
    private var swordsImages: [String];
    private var knivesImages: [String];
    private var potionsImages: [String];
    private var materialsImages: [String];
    private var toolsImages: [String];
    
    private var swordsPrices: [Int];
    private var knivesPrices: [Int];
    private var potionsPrices: [Int];
    private var materialsPrices: [Int];
    private var toolsPrices: [Int];
    
    init() {
        //Initializes arrays for items.
        self.swords = ["Small Sword", "Broadsword", "Golden Sword", "Jade Blade"];
        self.knives = ["Silver Knife", "Golden Knife", "Jade Knife"];
        self.potions = ["Health Potion", "Energy Potion", "Lethal Potion"];
        self.materials = ["Wood", "Bricks", "Steel"];
        self.tools = ["Axe", "Pickaxe", "Fishing Rod"];
        //Initializes arrays for item images.
        self.swordsImages = ["Small_Sword.png", "Broadsword.png", "Golden_Sword.png", "Jade_Blade.png"];
        self.knivesImages = ["Silver_Knife.png", "Golden_Knife.png", "Jade_Knife.png"];
        self.potionsImages = ["Health_Potion.png", "Energy_Potion.png", "Lethal_Potion.png"];
        self.materialsImages = ["Wood.png", "Bricks.png", "Steel.png"];
        self.toolsImages = ["Axe.png", "Pickaxe.png", "Fishing_Rod.png"];
        
        self.swordsPrices = [200, 800, 4000, 15000];
        self.knivesPrices = [50, 1000, 7000];
        self.potionsPrices = [200, 700, 2000];
        self.materialsPrices = [20, 100, 700];
        self.toolsPrices = [300, 300, 200];
    }
    
    //Accesses the array, allItems.
    func getAllItems() -> [String] {
        //Creates an array allItems.
        var allItems: [String] = [];
        //Adds all contents from arrays to allItems.
        allItems.append(contentsOf: swords);
        allItems.append(contentsOf: knives);
        allItems.append(contentsOf: potions);
        allItems.append(contentsOf: materials);
        allItems.append(contentsOf: tools);
        //Returns allItems.
        return allItems;
    }
    
    //Accesses the array, allImages.
    func getAllItemImages() -> [String] {
        //Creates an array allImages
        var allImages: [String] = [];
        allImages.append(contentsOf: swordsImages);
        allImages.append(contentsOf: knivesImages);
        allImages.append(contentsOf: potionsImages);
        allImages.append(contentsOf: materialsImages);
        allImages.append(contentsOf: toolsImages);
        //Returns allImages.
        return allImages;
    }
    
    func getAllMaterials() -> [String] {
        return materials;
    }
    
    //Accesses the array, allPrices
    func getAllItemPrices() -> [Int] {
        //Creates an array allPrices
        var allPrices: [Int] = [];
        allPrices.append(contentsOf: swordsPrices);
        allPrices.append(contentsOf: knivesPrices);
        allPrices.append(contentsOf: potionsPrices);
        allPrices.append(contentsOf: materialsPrices);
        allPrices.append(contentsOf: toolsPrices);
        //Returns allPrices.
        return allPrices;
    }
    
}
