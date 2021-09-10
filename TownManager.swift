//
//  TownManager.swift
//  RPG
//
//  Created by Charlie Robison on 5/27/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import Foundation
import SpriteKit

class TownManager: SKScene {
    //Objects
    private var houseObj = House();
    
    //Player's money.
    var money = 10000;
    //The number of materials the player has.
    var matNumber: [Int] = [];
    
    //Required money.
    private var requiredMoney = 0;
    //The required number of materials.
    private var numberOfMaterials: [Int] = [];
    //Money Label.
    private var moneyLabel = SKLabelNode();
    //Camera.
    private var cameraNode = SKCameraNode();
    //Buy Buttons.
    private var buyLabel = SKLabelNode();
    private var buyButton = SKSpriteNode();
    //Shop Node.
    private var shop = SKSpriteNode();
    
    //List of all structures.
    private var structList: [SKSpriteNode] = [];
    private var structIndex = 0;
    private var touchCheck: [Bool] = [];
    private var touchChange = false;
    private var isTouching: [Bool] = [];
    //List of all positions.
    var structPosX: [CGFloat] = [];
    var structPosY: [CGFloat] = [];
    
    override func didMove(to view: SKView) {
        //Creates camera.
        cameraNode = self.childNode(withName: "Camera") as! SKCameraNode;
        camera = cameraNode;
        
        //Creates money label.
        moneyLabel = SKLabelNode(text: "$" + String(money));
        moneyLabel.fontSize = 20;
        moneyLabel.fontColor = UIColor.white;
        moneyLabel.position = CGPoint(x: -320, y: 120);
        moneyLabel.zPosition = 2;
        self.addChild(moneyLabel);
        
        //Creates buy label.
        buyLabel = SKLabelNode(text: "Buy!");
        buyLabel.fontSize = 60;
        buyLabel.fontColor = UIColor.white;
        buyLabel.position = CGPoint(x: -320, y: 0);
        buyLabel.zPosition = 2;
        self.addChild(buyLabel);
        
        //Creates buy button.
        buyButton = SKSpriteNode(color: UIColor.black, size: CGSize(width: 100, height: 100));
        buyButton.position = CGPoint(x: -320, y: 0);
        buyButton.zPosition = 1;
        self.addChild(buyButton);
        
        //Creates shop button.
        shop = SKSpriteNode(imageNamed: "Shop");
        shop.position = CGPoint(x: -200, y: 200);
        shop.size = CGSize(width: 100, height: 100);
        self.addChild(shop);
        
        //Sets required money to house price.
        requiredMoney = houseObj.getPrice();
        numberOfMaterials = houseObj.getNumberOfMaterials();
        //Adds existing structures to scene.
        addExistingStructs();
    }
    
    /**Adds existing structures to scene.
     */
    func addExistingStructs() {
        //Checks if list is empty.
        if (structPosX.count == 0) {
            return;
        }
        //Loops through all positions
        for pos in 0..<structPosX.count {
            //Adds a house at the given position.
            let h = House();
            let house = h.getHouse();
            house.position = CGPoint(x: structPosX[pos], y: structPosY[pos]);
            house.physicsBody = SKPhysicsBody(rectangleOf: house.size);
            house.physicsBody?.restitution = 0;
            house.physicsBody?.affectedByGravity = false;
            house.physicsBody?.allowsRotation = false;
            house.physicsBody?.isDynamic = false;
            self.addChild(house);
            structList.append(house);
            touchCheck.append(true);
            isTouching.append(false);
        }
        //Removes all elements from list.
        structPosX.removeAll();
        structPosY.removeAll();
    }
    
    /**All Touch Operations.
     */
    func touchOperations(touch: UITouch) {
        let location = touch.location(in: self);
        //Checks if buy button was pressed.
        if (location.x >= buyButton.position.x - (buyButton.size.width/2) && location.x <= buyButton.position.x + (buyButton.size.width/2) && location.y >= buyButton.position.y - (buyButton.size.height/2) && location.y <= buyButton.position.y + (buyButton.size.height/2)) {
            if (money < requiredMoney) {
                print("Not Enough Money!")
                return;
            }
            //Checks if houses are placed and money is less than required money.
            if (money >= requiredMoney) {
                //Loops through all required materials.
                for i in 0..<numberOfMaterials.count {
                    //Checks if the correct amount of the material exists.
                    if (matNumber[i] < numberOfMaterials[i]) {
                        print("Not Enough Materials");
                        return;
                    }
                }
                //Checks if there are no structures.
                if (structList.count == 0) {
                    //Spawns house.
                    spawnHouse();
                    //Reduces money.
                    reduceMoney(amount: requiredMoney);
                    //Decreases each material amount.
                    for i in 0..<numberOfMaterials.count {
                        matNumber[i] -= numberOfMaterials[i];
                    }
                    return;
                }
                //Loops through all structures.
                for s in structList {
                    //Checks if there is a structure at point (0,0).
                    if (s.position == CGPoint(x: 0, y: 0))  {
                        return;
                    }
                    //Spawns house.
                    spawnHouse();
                    //Reduces money.
                    reduceMoney(amount: requiredMoney);
                    return;
                }
            }
        }
        
        //Checks if town node is pressed.
        if (location.x >= shop.position.x - (shop.size.width/2) && location.x <= shop.position.x + (shop.size.width/2) && location.y >= shop.position.y - (shop.size.height/2) && location.y <= shop.position.y + (shop.size.height/2)) {
            //Switches to town scene.
            switchToTown();
        }
        
        //Loops through all structures.
        for s in structList {
            structIndex = structList.firstIndex(of: s)!;
            //Checks if structure is pressed.
            if (location.x >= s.position.x - (s.size.width/2) && location.x <= s.position.x + (s.size.width/2) && location.y >= s.position.y - (s.size.height/2) && location.y <= s.position.y + (s.size.height/2) && touchCheck[structIndex]) {
                touchChange = true;
                //Structure follows finger.
                s.position.x = location.x;
                s.position.y = location.y;
                isTouching[structIndex] = true;
            } else {
                touchChange = false;
                isTouching[structIndex] = false;
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Calls touchOperations.
            touchOperations(touch: touch);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Calls touchOperations.
            touchOperations(touch: touch);
        }
    }
    
    func changeTouch() {
        if (touchChange) {
            for t in 0..<touchCheck.count {
                if (t != structIndex) {
                    touchCheck[t] = false;
                }
            }
        } else {
            for t in 0..<touchCheck.count {
                touchCheck[t] = true;
            }
        }
    }
    
    /**Switches to town scene.
     */
    func switchToTown() {
        //Loops through all structures.
        for i in 0..<structList.count {
            //Adds position of stucture to structList.
            structPosX.append(structList[i].position.x);
            structPosY.append(structList[i].position.y);
        }
        //Gets the town scene.
        let townScene = TownScene(fileNamed: "Town");
        //Sets houses' positions in Town Scene.
        townScene?.housePosX = structPosX;
        townScene?.housePosY = structPosY;
        townScene?.p.setMoney(newVal: money);
        townScene?.fromManager = true;
        //Switches scene.
        self.scene?.view?.presentScene(townScene);
    }
    
    /**Recuces money by a given amount.
     */
    func reduceMoney(amount: Int) {
        money -= amount;
    }

    /**Spawns a new house.
     */
    func spawnHouse() {
        let h = House();
        let house = h.getShadow();
        house.position = CGPoint(x: 0, y: 0);
        house.physicsBody = SKPhysicsBody(rectangleOf: house.size);
        house.physicsBody?.restitution = 0;
        house.physicsBody?.affectedByGravity = false;
        house.physicsBody?.allowsRotation = false;
        house.physicsBody?.isDynamic = false;
        self.addChild(house);
        structList.append(house);
        touchCheck.append(true);
        isTouching.append(false);
    }
    
    func checkHousePos() {
        for h in structList {
            let structIndex = structList.firstIndex(of: h)!;
            if (!isTouching[structIndex]) {
                for s in structList {
                    if (h.position.x >= s.position.x - s.size.width/2 - 30 && h.position.x <= s.position.x + s.size.width/2 + 30 && h.position.y >= s.position.y - s.size.height/2 - 30 && h.position.y <= s.position.y + s.size.height/2 + 30 && s != h) {
                        h.removeFromParent();
                        touchCheck.remove(at: structIndex);
                        isTouching.remove(at: structIndex);
                        spawnHouse();
                        print("Too Close To Other House!!");
                    }
                }
            }
        }
    }
    
    /**Updates money label.
     */
    func updateMoneyLabel() {
        moneyLabel.text = "$" + String(money);
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateMoneyLabel();
        changeTouch();
        //checkHousePos();
    }
}
