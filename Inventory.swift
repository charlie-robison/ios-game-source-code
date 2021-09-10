//
//  Inventory.swift
//  RPG
//
//  Created by Charlie Robison on 5/13/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

//Stores Items in an ArrayList ADT with O(1) operatiosn for add remove and get.
//Sorts items by largest power to smallest power.
//Has a size capacity of 9. 
class Inventory {
    private var list: [Item];
    private var size: Int;
    
    //Constructor.
    init() {
        self.list = [];
        self.size = 0;
    }
    
    init(list: [Item]) {
        self.list = list;
        self.size = list.count;
    }
    
    /**Searches for the number of occurences of an item.
     *
     */
    func searchItemOccurrence(itemName: String) -> Int {
        return recursiveSearch(itemName: itemName, index: 0, numberOfOccurrences: 0);
    }
    
    /**Recursive helper method for searchItemOccurrences.
     *
     */
    func recursiveSearch(itemName: String, index: Int, numberOfOccurrences: Int) -> Int {
        if (index == size) {
            return numberOfOccurrences;
        }
        if (list[index].getName() == itemName) {
            return recursiveSearch(itemName: itemName, index: index + 1, numberOfOccurrences: numberOfOccurrences + 1);
        }
        return recursiveSearch(itemName: itemName, index: index + 1, numberOfOccurrences: numberOfOccurrences);
    }
    
    //Gets the Item at the given index.
    func get(index: Int) -> Item! {
        return list[index];
    }

    //Adds an item to the list.
    func addItem(item: Item){
        //Size limit of 9.
        if (size >= 9) {
            print("Capacity!");
            return;
        }
        list.append(item);
        size += 1;
    }
    
    //Removes an item from the list. 
    func removeItem(index: Int) -> Item! {
        let val = list[index];
        list.remove(at: index);
        size -= 1;
        return val;
    }
    
    func getSize() -> Int {
        return size;
    }
    
    func getList() -> [Item] {
        return list;
    }
    
    func setList(newList: [Item]) {
        list = newList;
    }
}

