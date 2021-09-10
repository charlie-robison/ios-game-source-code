//
//  Item.swift
//  RPG
//
//  Created by Charlie Robison on 5/13/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

//Creates a new Item which have the properties of a name, and price.
//Takes only one argument in constructor which determines item power and price.
//Accessor methods for sprite node, name, and price.
class Item {
    private var item: SKSpriteNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 20, height: 20));
    private var itemName: String = "";
    private var itemPrice: Int;
    private var placedInInv: Bool;
    
    private var database = ItemDataBase();
    
    //Constructor.
    init(itemName: String) {
        //Stores all item names in array.
        let allItems = database.getAllItems();
        //Stores all item images in array.
        let allImages = database.getAllItemImages();
        //Loops through all item names in array.
        for i in 0..<allItems.count {
            //Checks if itemName given is equal to the element at the index.
            if (itemName == allItems[i]) {
                //Creates a new sprite for the item using the image at the corresponding index in allImages.
                self.item = SKSpriteNode(imageNamed: allImages[i]);
                self.item.scale(to: CGSize(width: 20, height: 20));
                self.item.size = CGSize(width: 20, height: 20);
                self.item.name = allItems[i];
                self.itemName = allItems[i];
            }
        }
        self.itemPrice = 0;
        self.placedInInv = false;
    }
    
    //Gets the sprite node.
    func getItem() -> SKSpriteNode {
        return item;
    }
    
    //Gets the name.
    func getName() -> String {
        return itemName;
    }
    
    //Gets the price.
    func getPrice() -> Int {
        //Stores all item names in array.
        let allItems = database.getAllItems();
        //Stores all item prices in array.
        let allPrices = database.getAllItemPrices();
        //Loops through all item names in array.
        for i in 0..<allItems.count {
            //Checks if itemName given is equal to the element at the index.
            if (itemName == allItems[i]) {
                //Sets the item price to the price located at the corresponding index in allPrices.
                itemPrice = allPrices[i];
            }
        }
        return itemPrice;
    }
    
    //Checks if item has been placed in the inventory.
    func getPlacedInInv() -> Bool {
        return placedInInv;
    }
    
    //Sets the item state of the item.
    func setPlacedInInv(state: Bool) {
        placedInInv = state;
    }
}
