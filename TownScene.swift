//
//  TownScene.swift
//  RPG
//
//  Created by Charlie Robison on 5/28/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import SpriteKit
import GameplayKit

class TownScene: SKScene {

    private let data = UserDefaults.standard;
    var fromManager = false;
    //Gets all the house positions.
    var housePosX: [CGFloat] = [];
    var housePosY: [CGFloat] = [];
    //Gets all the houses.
    var houseList: [SKSpriteNode] = [];
    var chestList: [SKSpriteNode] = [];
    var chestObj: [Chest] = [];
    var itemsInsideChest: [Item] = [];
    //Holds house alerts.
    private var houseAlerts: [SKSpriteNode] = [];
    //Holds divisor for house alert speeds.
    private var divisor: CGFloat = 1;
    
    //Object References.
    let p = Player();
    private let inv = Inventory();
    private let itemData = ItemDataBase();
    private let fight = Fight();
    private let m = Message();
    
    //Sprite Nodes.
    var player = SKSpriteNode();
    private var cameraNode = SKCameraNode();
    private var shop = SKSpriteNode();
    
    //Player Controls.
    private var rightButton = SKSpriteNode();
    private var leftButton = SKSpriteNode();
    private var upButton = SKSpriteNode();
    private var downButton = SKSpriteNode();
    var invSlots = SKSpriteNode();
    var levelDisplay = SKLabelNode();
    //Money Display
    var moneyLabel = SKLabelNode();
    var expLabel = SKLabelNode();
    
    //Button Checks.
    private var up = false;
    private var down = false;
    private var left = false;
    private var right = false;
    
    //Health
    //Green health meter.
    var healthMeter = SKSpriteNode();
    //Read health meter.
    private var maxHealthMeter = SKSpriteNode();
    //Black Outline around health bars.
    private var backgroundHealth = SKSpriteNode();
    //Health meter's position.
    var healthPos: CGFloat = -150;
    //Player's total health.
    var health: CGFloat = 100;
    var healthWidth: CGFloat = 100;
    private var healthCheck = true;
    
    private var trees: [SKSpriteNode] = [];
    private var trunks: [SKSpriteNode] = [];
    
    
    //Inventory.
    //Names for items.
    var itemsSpawnArray: [String] = [];
    //Array which holds all sprite nodes for items in inventory.
    var invDisplay: [SKSpriteNode] = [];
    //Current index in inventory to create sprite nodes.
    var currentIndex = 0;
    
    var materialsInBag: [Material] =  [Material(materialName: "Wood"), Material(materialName: "Bricks"), Material(materialName: "Steel")];
    var numberOfMaterials: [Int] = [0, 0, 0];
    var woodLabel = SKLabelNode();
    var brickLabel = SKLabelNode();
    var steelLabel = SKLabelNode();
    
    //Holds state for if a weapon is equipped.
    var weaponEquipped = false;
    //Holds state for if a tool is equipped.
    var toolEquipped = false;
    //Holds the current weapon equipped.
    var currentWeapon: String = "";
    //Holds the current tool equipped.
    var currentTool: String = "";
    //Holds player's states.
    var fightState = false;
    var toolState = false;
    //Timer for fight animation.
    private var fightTimer = 0;
    
    //Counter
    private var count = 0;
    
    //Holds all nodes from a message.
    private var messageNodes: [SKNode] = [];
    //Holds all decision buttons.
    private var decideButtons: [SKSpriteNode] = [];
    //Stores value for yes button.
    private var yesTouch = false;
    //Stores value for no button.
    private var noTouch = false;
    
    override func didMove(to view: SKView) {
        
        view.isMultipleTouchEnabled = true;
        //Receives saved data.
        //recieveData();
        //Creates main on screen sprite nodes in scene.
        createNodes();
        //Creates buttons on the screen.
        createButtons();
        //Creates health bars on the screen.
        createHeathBar();
        //itemsSpawnArray gets all items from database.
        itemsSpawnArray = itemData.getAllItems();
        //Display player stats.
        playerStats();
        //getData();
        //Spawns houses.
        spawnHouse();
        spawnChest(posX: -320.0, posY: -240.0, itemName: "Silver Knife");
    }
    
    /**Saves all data from TownScene.
     */
    func saveData() {
        //Saves house positions.
        data.set(housePosX, forKey: "House_Positions_X");
        data.set(housePosY, forKey: "House_Positions_Y");
    }
    
    /**Receives all data from previous save.
     */
    func recieveData() {
        //Checks if previous scene was TownManager.
        if (!fromManager) {
            //Recieves house positions.
            housePosX = data.array(forKey: "House_Positions_X") as? [CGFloat] ?? [CGFloat]();
            housePosY = data.array(forKey: "House_Positions_Y") as? [CGFloat] ?? [CGFloat]();
        } else {
            fromManager = false;
        }
    }
    
    func checkPlayerPos() {
        if (player.position.y > 400) {
            //Saves data from scene.
            saveData();
            let forestScene = ForestScene(fileNamed: "ForestScene");
            forestScene?.health = health;
            forestScene?.healthPos = healthPos;
            forestScene?.healthWidth = healthWidth;
            forestScene?.fightState = fightState;
            forestScene?.toolState = toolState;
            forestScene?.weaponEquipped = weaponEquipped;
            forestScene?.toolEquipped = toolEquipped;
            forestScene?.currentWeapon = currentWeapon;
            forestScene?.currentTool = currentTool;
            forestScene?.numberOfMaterials = numberOfMaterials;
            forestScene?.tempItemsArray = inv.getList();
            forestScene?.p.setLevel(currentLevel: p.getLevel());
            //forestScene?.p.setMoney(newVal: p.getMoney());
            self.scene?.view?.presentScene(forestScene);
            print("Wood:  " + String(numberOfMaterials[0]));
            print("Bricks: " + String(numberOfMaterials[1]));
            print("Steel: " + String(numberOfMaterials[2]));
        }
    }
    
    /**Switches to townManager scene.
     */
    func switchToTownManager() {
        //Checks if there are houses that exist.
        if (houseList.count > 0) {
            //Loops through each house.
            for house in houseList {
                //Appends housePos.
                housePosX.append(house.position.x);
                housePosY.append(house.position.y);
            }
        }
        //Switches to TownManager scene.
        let townManagerScene = TownManager(fileNamed: "TownManager");
        //Sets structPos to housePos.
        townManagerScene?.structPosX = housePosX;
        townManagerScene?.structPosY = housePosY;
        townManagerScene?.money = p.getMoney();
        townManagerScene?.matNumber = numberOfMaterials;
        self.scene?.view?.presentScene(townManagerScene);
        print("Wood:  " + String(numberOfMaterials[0]));
        print("Bricks: " + String(numberOfMaterials[1]));
        print("Steel: " + String(numberOfMaterials[2]));
    }
    
    /**Spawns a house and its shadow.
     */
    func spawnHouse() {
        //Checks if list is empty.
        if (housePosX.count == 0) {
            return;
        }
        //Loops through all positions
        for pos in 0..<housePosX.count {
            let h = House();
            let house = h.getHouse();
            house.position = CGPoint(x: housePosX[pos], y: housePosY[pos]);
            self.addChild(house);
            houseList.append(house);
            //houseAlert(house: house);
            
            let houseShadow = h.getShadow();
            houseShadow.position = house.position;
            self.addChild(houseShadow);
            
            let block = h.getBlock();
            block.position = CGPoint(x: house.position.x, y: house.position.y - (block.size.height/2));
            self.addChild(block);
        }
    }
    
    /**Spawns a money collection alert above a house when ready.
     */
    func houseAlert(house: SKSpriteNode) {
        //Creates a new house alert.
        let a = HouseAlert();
        let alert = a.getAlert();
        //Sets its position.
        alert.position = CGPoint(x: house.position.x, y: (house.position.y + house.size.height/2) + 5);
        //Adds alert to list.
        houseAlerts.append(alert);
        self.addChild(alert);
    }
    
    /**Moves alert up and down based on count.
     */
    func houseAlertAnimation() {
        for i in 0..<houseAlerts.count {
            houseAlerts[i].position.y += 0.5 * divisor;
            if (count % 30 == 0) {
                divisor *= -1;
            }
        }
    }
    
    /**Creates a new chest that spaws a given item at a given point.
     */
    func spawnChest(posX: CGFloat, posY: CGFloat, itemName: String) {
        let itemInside = Item(itemName: itemName);
        let c = Chest(item: itemInside);
        let chest = c.getChest();
        chest.position = CGPoint(x: posX, y: posY);
        chest.name = "Chest" + String(chestList.count);
        self.addChild(chest);
        chestList.append(chest);
        itemsInsideChest.append(itemInside);
        chestObj.append(c);
    }
    
    func collideChest() {
        for c in chestList {
            enumerateChildNodes(withName: c.name!) { node, _ in
                let chestIndex = self.chestList.firstIndex(of: c);
                let chest = node as! SKSpriteNode;
                //Checks if treeintersects player.
                if (chest.frame.intersects(self.player.frame)) {
                    let animation = self.chestObj[chestIndex!].getAnimation();
                    var counter  = 0;
                    let chestAnimation = SKAction.animate(with: animation, timePerFrame: 10.0);
                    chest.run(chestAnimation);
                    while (counter < 1000) {
                        counter += 1;
                        
                    }
                    let itemFromChest = self.itemsInsideChest[chestIndex!];
                    let chestPos = chest.position;
                    
                    let item = itemFromChest.getItem();
                    item.position = chestPos;
                    self.addChild(item);
                    chest.removeFromParent();
                }
            }
        }
    }
    
    /**Creates main on screen sprite nodes in scene.
     */
    func createNodes() {
        //Creates player node.
        player = p.getPlayer();
        self.addChild(player);
        //Creates camera node.
        cameraNode = self.childNode(withName: "Camera") as! SKCameraNode;
        camera = cameraNode;
        //Creates inventory nodes.
        invSlots = self.childNode(withName: "InvSlots") as! SKSpriteNode;
        invSlots.zPosition = 3;
        //Creates level node.
        levelDisplay = SKLabelNode(text: "Level " + String(p.getLevel()));
        levelDisplay.fontSize = 25;
        levelDisplay.position = CGPoint(x: player.position.x + -215, y: player.position.y + 110);
        levelDisplay.zPosition = 3;
        self.addChild(levelDisplay);
        expLabel = SKLabelNode(text: "Exp Remaining: " + String(p.getMaxExp() - p.getExp()));
        expLabel.position = CGPoint(x: player.position.x + -215, y: player.position.y + 70);
        expLabel.fontSize = 10;
        expLabel.zPosition = 3;
        self.addChild(expLabel);
        moneyLabel = SKLabelNode(text: "$" + String(p.getMoney()));
        moneyLabel.fontSize = 15;
        moneyLabel.zPosition = 3;
        moneyLabel.position = CGPoint(x: player.position.x + 200, y: player.position.y + 110);
        self.addChild(moneyLabel);
        shop = SKSpriteNode(imageNamed: "Shop");
        shop.position = CGPoint(x: -200, y: 200);
        shop.size = CGSize(width: 80, height: 80);
        shop.zPosition = 2;
        self.addChild(shop);
        let shopBlock = SKSpriteNode(color: UIColor.black, size: CGSize(width: 30, height: 30));
        shopBlock.position = CGPoint(x: shop.position.x - 5, y: shop.position.y - 17);
        shopBlock.alpha = 0.0;
        shopBlock.name = "Shop";
        shopBlock.physicsBody = SKPhysicsBody(rectangleOf: shopBlock.size);
        shopBlock.physicsBody?.restitution = 0;
        shopBlock.physicsBody?.affectedByGravity = false;
        shopBlock.physicsBody?.allowsRotation = false;
        shopBlock.physicsBody?.linearDamping = 0;
        shopBlock.physicsBody?.angularDamping = 0;
        shopBlock.physicsBody?.friction = 0;
        shopBlock.physicsBody?.isDynamic = false;
        self.addChild(shopBlock);
        displayMaterials();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Stores fight state.
        var touchFightState = true;
        //Stores tool state.
        var touchToolState = true;
        //Loops through all touches by the user.
        for touch in touches {
            //Sets a variable for the location of one of the touches.
            let location = touch.location(in: self);
            //Checks which button was pressed.
            if (location.x >= rightButton.position.x - (rightButton.size.width/2) && location.x <= rightButton.position.x + (rightButton.size.width/2) && location.y >= rightButton.position.y - (rightButton.size.height/2) && location.y <= rightButton.position.y + (rightButton.size.height/2)) {
                right = true;
                touchFightState = false;
                touchToolState = false;
            } else if (location.x >= leftButton.position.x - (leftButton.size.width/2) && location.x <= leftButton.position.x + (leftButton.size.width/2) && location.y >= leftButton.position.y - (leftButton.size.height/2) && location.y <= leftButton.position.y + (leftButton.size.height/2)) {
                left = true;
                touchFightState = false;
                touchToolState = false;
            } else if (location.x >= upButton.position.x - (upButton.size.width/2) && location.x <= upButton.position.x + (upButton.size.width/2) && location.y >= upButton.position.y - (upButton.size.height/2) && location.y <= upButton.position.y + (upButton.size.height/2)) {
                up = true;
                touchFightState = false;
                touchToolState = false;
            } else if (location.x >= downButton.position.x - (downButton.size.width/2) && location.x <= downButton.position.x + (downButton.size.width/2) && location.y >= downButton.position.y - (downButton.size.height/2) && location.y <= downButton.position.y + (downButton.size.height/2)) {
                down = true;
                touchFightState = false;
                touchToolState = false;
            }
            
            if (location.x >= shop.position.x - (shop.size.width/2) && location.x <= shop.position.x + (shop.size.width/2) && location.y >= shop.position.y - (shop.size.height/2) && location.y <= shop.position.y + (shop.size.height/2)) {
                switchToTownManager();
            }
            
            
            //Loops through all items in inventory.
            for i in 0..<invDisplay.count {
                //Sets touch location to current item in iteration.
                let itemLocation = touch.location(in: invDisplay[i]);
                //Checks if the player selects the item.
                if (itemLocation.x >= (-1 * (invDisplay[i].size.width/2)) - 2 && itemLocation.x <= 2 + (invDisplay[i].size.width/2) && itemLocation.y >= (-1 * (invDisplay[i].size.height/2)) - 2 && itemLocation.y <= 2 + (invDisplay[i].size.height/2)) {
                    //Checks for the item's name and calls corresponding function.
                    useItem(itemName: invDisplay[i].name!, itemIndex: i);
                    touchFightState = false;
                    touchToolState = false;
                    return;
                }
            }
            
            //Sets touch location to invSlots.
            let invLocation = touch.location(in: invSlots);
            //Checks if touch is inside invSlots.
            if (invLocation.x >= -1 * invSlots.size.width/2 && invLocation.x <= invSlots.size.width/2 && invLocation.y >= -1 * invSlots.size.width/2 && invLocation.y <= invSlots.size.width/2) {
                //Sets touchFightState and touchToolState to false.
                touchFightState = false;
                touchToolState = false;
                return;
            }
            
            //Loops throuugh all house alerts and removes it when touched.
            for a in houseAlerts {
                if (location.x >= a.position.x - a.size.width/2 && location.x <= a.position.x + a.size.width/2 && location.y >= a.position.x - a.size.height/2 && location.y <= a.position.y + a.size.height/2) {
                    print("LET GO");
                    a.removeFromParent();
                    p.addMoney(addedMoney: 50);
                }
            }
            
            //Checks if touchFightState is true.
            if (touchFightState) {
                //Sets fightState to true.
                fightState = true;
            }
            //Checks if touchToolState is true.
            if (touchToolState) {
                //Sets toolState to true.
                toolState = true;
            }
        }
    
        for touch in touches {
            if (decideButtons.count == 2) {
                let buttonYes = decideButtons[0];
                let buttonNo = decideButtons[1];
                let buttonLocation = touch.location(in: self);
                if (buttonLocation.x >= buttonYes.position.x - (buttonYes.size.width/2) && buttonLocation.x <= buttonYes.position.x + (buttonYes.size.width/2) && buttonLocation.y >= buttonYes.position.y - (buttonYes.size.height/2) && buttonLocation.y <= buttonYes.position.y + (buttonYes.size.height/2)) {
                    isPaused = false;
                    removeMessage();
                    yesTouch = true;
                    
                } else if (buttonLocation.x >= buttonNo.position.x - (buttonNo.size.width/2) && buttonLocation.x <= buttonNo.position.x + (buttonNo.size.width/2) && buttonLocation.y >= buttonNo.position.y - (buttonNo.size.height/2) && buttonLocation.y <= buttonNo.position.y + (buttonNo.size.height/2)) {
                    noTouch = true;
                }
            }
        }
    }
    
    /**Cancels player's movement.
     */
    func cancelMove(touch: UITouch) {
        //Sets a variable for the location of one of the touches.
        let location = touch.location(in: self);
        //Checks which button was pressed.
        if (location.x >= rightButton.position.x - (rightButton.size.width/2) && location.x <= rightButton.position.x + (rightButton.size.width/2) && location.y >= rightButton.position.y - (rightButton.size.height/2) && location.y <= rightButton.position.y + (rightButton.size.height/2)) {
            right = false;
        } else if (location.x >= leftButton.position.x - (leftButton.size.width/2) && location.x <= leftButton.position.x + (leftButton.size.width/2) && location.y >= leftButton.position.y - (leftButton.size.height/2) && location.y <= leftButton.position.y + (leftButton.size.height/2)) {
            left = false;
        } else if (location.x >= upButton.position.x - (upButton.size.width/2) && location.x <= upButton.position.x + (upButton.size.width/2) && location.y >= upButton.position.y - (upButton.size.height/2) && location.y <= upButton.position.y + (upButton.size.height/2)) {
            up = false;
        } else if (location.x >= downButton.position.x - (downButton.size.width/2) && location.x <= downButton.position.x + (downButton.size.width/2) && location.y >= downButton.position.y - (downButton.size.height/2) && location.y <= downButton.position.y + (downButton.size.height/2)) {
            down = false;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Loops through all touches.
        for touch in touches {
            //Cancels player movement.
            cancelMove(touch: touch);
        }
        fightState = false;
        toolState = false;
    }
    
    /****PLAYER OPERATIONS!!!***/
    
    /**All the objects the follow the player.
     *
     */
    func playerFollow() {
        //Camera follows player.
        cameraNode.position.x = player.position.x;
        cameraNode.position.y = player.position.y;
        //Right button follows player.
        rightButton.position.x = player.position.x + 250;
        rightButton.position.y = player.position.y - 60;
        //Left button follows player.
        leftButton.position.x = player.position.x + 190;
        leftButton.position.y = player.position.y - 60;
        //Up button follows player.
        upButton.position.x = player.position.x + 220;
        upButton.position.y = player.position.y - 30;
        //Down button follows player.
        downButton.position.x = player.position.x + 220;
        downButton.position.y = player.position.y - 90;
        //InvSlots follows player.
        invSlots.position.x = player.position.x - 190;
        invSlots.position.y = player.position.y - 70;
        
        levelDisplay.position = CGPoint(x: player.position.x + -215, y: player.position.y + 110);
        levelDisplay.text = "Level: " + String(p.getLevel());
        expLabel.position = CGPoint(x: player.position.x + -215, y: player.position.y + 70);
        moneyLabel.position = CGPoint(x: player.position.x + 200, y: player.position.y + 110);
        moneyLabel.text = "$" + String(p.getMoney());
        //Health Bars follows player.
        let healthMeterWidth = healthMeter.size.width;
        healthMeter.position.y = 90 + player.position.y;
        healthMeter.position.x = player.position.x + (healthPos - healthMeterWidth/2);
        maxHealthMeter.position = CGPoint(x: -200 + player.position.x, y: 90 + player.position.y);
        backgroundHealth.position = CGPoint(x: -200 + player.position.x, y: 90 + player.position.y);
        //Material Labels.
        woodLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 60);
        brickLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 50);
        steelLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 40);
    }
    
    /**Displays number of materials on the screen.
     */
    func displayMaterials() {
        woodLabel = SKLabelNode(text: "Wood: " + String(numberOfMaterials[0]));
        woodLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 60);
        woodLabel.fontSize = 10;
        woodLabel.zPosition = 3;
        self.addChild(woodLabel);
        brickLabel = SKLabelNode(text: "Brick: " + String(numberOfMaterials[1]));
        brickLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 50);
        brickLabel.fontSize = 10;
        brickLabel.zPosition = 3;
        self.addChild(brickLabel);
        steelLabel = SKLabelNode(text: "Steel: " + String(numberOfMaterials[2]));
        steelLabel.position = CGPoint(x: player.position.x + -233, y: player.position.y + 40);
        steelLabel.fontSize = 10;
        steelLabel.zPosition = 3;
        self.addChild(steelLabel);
    }
    
    /**Display's player's stats.
     *
     */
    func playerStats() {
        let money = p.getMoney();
        let level = p.getLevel();
        let exp = p.getExp();
        let attack = p.getAttack();
        let defense = p.getDefense();
        
        print("***Player Stats***");
        print("Money: $", money);
        print("Level: ", level);
        print("Exp: ", exp);
        print("Attack: ", attack);
        print("Defense: ", defense);
        print("Weapon Equipped: " + currentWeapon);
        print("Tool Equipped: " + currentTool);
    }
    
    
    /**PLAYER STATE OPERATIONS!!**/
    
    /**Gets the time for the fight animation and turns off fightState once the screen is tapped.
     */
    func fightTime() {
        //Checks if fightState is true.
        if (fightState) {
            //Updates fightTimer.
            fightTimer += 1;
            //Checks if fightTimer is 10.
            if (fightTimer == 10) {
                //Sets fightState to false.
                fightState = false;
                //Resets timer.
                fightTimer = 0;
            }
        } else {
            fightTimer = 0;
        }
    }
    
    /**Sets player in fight mode.
     *
     */
    func fightMode() {
        //Checks if a weapon has been equipped and fight state is true.
        if (weaponEquipped && fightState) {
            //Changes player image.
            player.color = UIColor.blue;
        } else {
            //Resets player image.
            player.color = UIColor.black;
        }
    }
    
    /**Sets player in tool mode.
     *
     */
    func toolMode() {
        //Checks if a tool has been equipped and tool state is true.
        if (toolEquipped && toolState) {
            //Changes player image.
            player.color = UIColor.red;
        }
    }
    
    /**Sets the player's velcity vector based on the button pushed.
     * Also sets the camera to the player.
     *
     */
    func playerMovement() {
        //Makes sure, buttons and camera follows player.
        playerFollow();
        //Checks for which button is pressed and sets the player's velocity.
        if (up) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 100);
        } else if (down) {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: -100);
        } else if (left) {
            player.physicsBody?.velocity = CGVector(dx: -100, dy: 0);
        } else if (right) {
            player.physicsBody?.velocity = CGVector(dx: 100, dy: 0);
        } else {
            player.physicsBody!.velocity = CGVector(dx: 0, dy: 0);
        }
    }
    
    /**Creates the movement buttons for the player.
     *
     */
    func createButtons() {
        //Creates sprite nodes for buttons.
        rightButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30));
        rightButton.zPosition = 3;
        self.addChild(rightButton);
        
        leftButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30));
        leftButton.zPosition = 3;
        self.addChild(leftButton);
        
        upButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30));
        upButton.zPosition = 3;
        self.addChild(upButton);
        
        downButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30));
        downButton.zPosition = 3;
        self.addChild(downButton);
    }
    
    /**HEALTH OPERATIONS!!**/
    
    /**Creates health bars on screen.
     *
     */
    func createHeathBar() {
        //Sets initial positions.
        let x: CGFloat = -200;
        let y: CGFloat = 90;
        //Creates red health meter.
        maxHealthMeter = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 15));
        maxHealthMeter.position = CGPoint(x: x + player.position.x, y: y + player.position.y);
        maxHealthMeter.zPosition = 4;
        self.addChild(maxHealthMeter);
        //Creates green health meter.
        healthMeter = SKSpriteNode(color: UIColor.green, size: CGSize(width: healthWidth, height: 15));
        healthMeter.position = CGPoint(x: player.position.x + (healthPos - healthMeter.size.width/2), y: y + player.position.y);
        healthMeter.zPosition = 5;
        self.addChild(healthMeter);
        
        //Creates black outline.
        backgroundHealth = SKSpriteNode(color: UIColor.black, size: CGSize(width: 104, height: 19));
        backgroundHealth.position = CGPoint(x: x + player.position.x, y: y + player.position.y);
        backgroundHealth.zPosition = 3;
        self.addChild(backgroundHealth);
    }
    
    /**Decrements player's health by a given damage size. Changes green health bar's position and size.
     *
     */
    func takesDamage(damageSize: CGFloat) {
        //Factor between width of meter and maxHealth.
        let healthFactor = 100/p.getMaxHealth();
        //Decrements green health meter's size by damageSize.
        healthMeter.size.width -= (damageSize * healthFactor);
        //Decrements green health meter's position by damageSize.
        healthPos -= (damageSize * healthFactor);
        //Decrements player's health by damageSize.
        health -= damageSize;
        //Stores width of green health meter.
        let healthMeterWidth = healthMeter.size.width;
        //Resets green health meters position.
        healthMeter.position.x = player.position.x + (healthPos - healthMeterWidth/2);
    }
    
    /**Increments player's health by a given replinish size. Changes green health bar's position and size.
     *
     */
    func replinishHealth(replinishSize: CGFloat) {
        let healthFactor = 100/p.getMaxHealth();
        let maxHealth: CGFloat = p.getMaxHealth();
        let healthDifference = maxHealth - health;
        if (health >= maxHealth) {
            return;
        }
        
        if (healthDifference <= replinishSize) {
            healthMeter.size.width += (healthDifference + healthFactor);
            healthPos += (healthDifference + healthFactor);
            //Incrments player's health by replinishSize.
            health += healthDifference;
            //Stores width of green health meter.
            //Resets green health meters position.
            healthMeter.position.x = player.position.x + (healthPos - healthDifference/2);
            return;
        }
        //Incrments green health meter's size by replinishSize.
        healthMeter.size.width += (replinishSize * healthFactor);
        //Incrments green health meter's position by replinishSize.
        healthPos += (replinishSize * healthFactor);
        //Incrments player's health by replinishSize.
        health += replinishSize;
        //Stores width of green health meter.
        let healthMeterWidth = healthMeter.size.width;
        //Resets green health meters position.
        healthMeter.position.x = player.position.x + (healthPos - healthMeterWidth/2);
    }
    
    /**Checks the player's health.
     *
     */
    func checkHealth() {
        data.set(health, forKey: "Player_Health");
        //Checks if health is 0.
        if (health <= 0) {
            print("GAME OVER");
            //Removes all children.
            self.removeAllChildren();
        }
    }
    
    /**Resets player health after leveling up.
     */
    func resetPlayerHealth() {
        //Resets health.
        health = p.getMaxHealth();
        //Resets health width.
        healthMeter.size.width = 100;
        //Resets healthPos.
        healthPos = -150;
        //Resests position of health meter.
        healthMeter.position.x = player.position.x + (healthPos - healthMeter.size.width/2);
    }
    
    /**Checks if there is a collision between the player and a rock or tree..
     *
     */
    func collideNature() {
        //Enumerates all nodes with name "Rock".
        enumerateChildNodes(withName: "Rock") { node, _ in
            let rock = node as! SKSpriteNode;
            //Checks if rock intersects player.
            if (rock.frame.intersects(self.player.frame)) {
                //Checks if player is in toolState and if current tool is a pickaxe.
                if (self.toolEquipped && self.toolState && self.currentTool == "Pickaxe") {
                    //Breaks the rock into materials.
                    self.breakRock(rock: rock);
                    return;
                }
            }
        }
        //Enumerates all nodes with name "Tree".
        for t in trunks {
            enumerateChildNodes(withName: t.name!) { node, _ in
                let treeIndex = self.trunks.firstIndex(of: t);
                let tree = node as! SKSpriteNode;
                //Checks if treeintersects player.
                if (tree.frame.intersects(self.player.frame)) {
                    //Checks if player is in toolState and if current tool is an axe.
                    if (self.toolEquipped && self.toolState && self.currentTool == "Axe") {
                        //Breaks the tree into materials.
                        print("HIT");
                        self.breakTree(tree: tree, treeIndex: treeIndex!);
                        return;
                    }
                }
            }
        }
    }
    
    
    /**NATURE OPERATIONS!!**/
    
    /**Breaks a rock into brick or steel.
     *
     */
    func breakRock(rock: SKSpriteNode) {
        //Gets the rock position.
        let rockPosition = rock.position;
        //Removes the rock from the scene.
        rock.removeFromParent();
        //List holds brick and steel.
        let materialList = ["Bricks", "Steel"];
        //Gets random index.
        let randomName = Int.random(in: 0..<materialList.count);
        //Creates a new item.
        let i = Item(itemName: materialList[randomName]);
        let item = i.getItem();
        //Sets the new item's position to rock position.
        item.position = rockPosition;
        //Adds item to scene.
        self.addChild(item);
        woodLabel.text =  "Wood: " + String(numberOfMaterials[0]);
        brickLabel.text = "Brick: " + String(numberOfMaterials[1]);
        steelLabel.text = "Steel: " + String(numberOfMaterials[2]);
    }
    
    /**Breaks a tree into wood.
     *
     */
    func breakTree(tree: SKSpriteNode, treeIndex: Int) {
        //Gets the tree position.
        let treePosition = tree.position;
        //Removes the tree from the scene.
        tree.removeFromParent();
        trees[treeIndex].removeFromParent();
        //List holds brick and steel.
        let materialList = ["Wood"];
        //Gets random index.
        let randomName = Int.random(in: 0..<materialList.count);
        //Creates a new item.
        let i = Item(itemName: materialList[randomName]);
        let item = i.getItem();
        //Sets the new item's position to rock position.
        item.position = treePosition;
        //Adds item to scene.
        self.addChild(item);
        woodLabel.text =  "Wood: " + String(numberOfMaterials[0]);
        brickLabel.text = "Brick: " + String(numberOfMaterials[1]);
        steelLabel.text = "Steel: " + String(numberOfMaterials[2]);
    }
    
    
    /**SPAWNING OPERATIONS!!**/
    
    /**Checks if there is already a sprite node within a certain distance from a newly spawned node.
     */
    func checkPos(posX: CGFloat, posY: CGFloat) -> Bool {
        //Loops through all sprite nodes.
        for i in self.children {
            //Checks if the x and y position of the newly spawned node is within the correct range.
            if (posX >= i.position.x - 20 && posX <= i.position.x + 20 && posY >= i.position.y - 20 && posY <= i.position.y + 20) {
                //Returns false.
                return false;
            }
        }
        //Returns true.
        return true;
    }
    
    /**Spawns rocks in random locations relative to the player.
     *
     */
    func spawnRocks() {
        if (count % 311 == 0 && count != 0 && count != 1) {
            let r = Rock();
            let rock = r.getRock();
            //Gets random positions for rocks.
            let randomX = CGFloat.random(in: -150..<150);
            let randomY = CGFloat.random(in: -150..<150);
            //Holds the result of checkPos.
            let checkSpawn = checkPos(posX: randomX, posY: randomY);
            //Checks is checkSpawn is true.
            if (checkSpawn) {
                rock.position = CGPoint(x: randomX + player.position.x, y: randomY + player.position.y);
                self.addChild(rock);
            } else {
                return;
            }
        }
    }
    
    /**Spawns trees in random locations relative to the player.
     *
     */
    func spawnTrees() {
        if (count % 311 == 0 && count != 0 && count != 1) {
            let t = Tree();
            let tree = t.getTree();
            let shadow = t.getShadow();
            let trunk = t.getTrunk();
            trunk.name = "Trunks" + String(trunks.count);
            //Gets random positions for Trees.
            let randomX = CGFloat.random(in: -150..<150);
            let randomY = CGFloat.random(in: -150..<150);
            //Holds the result of checkPos.
            let checkSpawn = checkPos(posX: randomX, posY: randomY);
            //Checks is checkSpawn is true.
            if (checkSpawn) {
                tree.position = CGPoint(x: randomX + player.position.x, y: randomY + player.position.y);
                shadow.position = CGPoint(x: randomX + player.position.x, y: randomY + player.position.y);
                trunk.position =  CGPoint(x: tree.position.x, y: tree.position.y - 26);
                self.addChild(tree);
                self.addChild(shadow);
                self.addChild(trunk);
                trees.append(tree);
                trunks.append(trunk);
                
            } else {
                return;
            }
        }
    }
    
    
    /**Spawns items in random locations relative to player's position.
     *
     */
    func spawnItems() {
        //Checks if count divides 111.
        if (count % 111 == 0 && count != 0 && count != 1) {
            //Stores a random index from itemsSpawnArray.
            let randomName = Int.random(in: 0..<itemsSpawnArray.count);
            //Creates a new Item with the index.
            let i = Item(itemName: itemsSpawnArray[randomName]);
            //Creates a Sprite Node for item.
            let item = i.getItem();
            //Gets random positions for item.
            let randomX = CGFloat.random(in: -150..<150);
            let randomY = CGFloat.random(in: -150..<150);
            //Holds the result of checkPos.
            let spawnCheck = checkPos(posX: randomX, posY: randomY);
            //Checks if spawnCheck is true.
            if (spawnCheck) {
                //Sets random position for item relative to player.
                item.position = CGPoint(x: randomX + player.position.x, y: randomY + player.position.y);
                item.zPosition = 1;
                //Adds item to scene.
                self.addChild(item);
            } else {
                return;
            }
        }
    }
    
    /**INVENTORY OPERATIONS!!**/
    
    /**Checks if the player collides with an item and picks up the item.
     *
     */
    func pickUpItem() {
        //Sets an empty list of items the player has collided with.
        var hitItem: [SKSpriteNode] = [];
        //Gives a variable to store item name.
        var name = "";
        //Loops through all possible item's.
        for i in 0..<itemsSpawnArray.count {
            //Sets name to item name.
            name = itemsSpawnArray[i];
            //Checks for collisions between player and item.
            enumerateChildNodes(withName: name) { node, _ in
                //Sets item to the new node.
                let item = node as! SKSpriteNode;
                //Checks if each of the items collides with player.
                if item.frame.intersects(self.player.frame) {
                    //Adds this collided item to the list.
                    hitItem.append(item);
                }
            }
        }
        //Loops through all items collided with player.
        for item in hitItem {
            //Removes the item.
            item.removeFromParent();
            //Stores the name of the item.
            let nameOfItem = item.name;
            //Creates a new Item.
            let newItem = Item(itemName: nameOfItem!);
            //Adds the item to the inventory.
            inv.addItem(item: newItem);
            //Creates label nodes for all items in inventory.
            fillInv();
        }
    }
    
    /**Fills the inventory grid on the screen with the items in the inventory.
     *
     */
    func fillInv() {
        //Sets initial positions.
        var x: CGFloat = -215;
        var y: CGFloat = -45;
        //Sets the current column to 0.
        var col = 0;
        //Loops through each item in inventory.
        for i in currentIndex..<inv.getSize() {
            //Sets row to 0.
            var row = 0;
            //Sets item to the item at the current index in inventory.
            let item = inv.get(index: i);
            //Sets the state of the item when placed in the inventory to true.
            item?.setPlacedInInv(state: true);
            //Sets itemNode to the sprite node from Item.
            let itemNode = item?.getItem();
            //Sets the zPosition.
            itemNode?.zPosition = 4;
            //Checks if the index is divisible by 3.
            if (i % 3 == 0 && i != 0) {
                //Increments the row.
                row += 1;
                //Sets the column back to 0.
                col = 0;
                //Decrements y by 25 * row.
                y -= CGFloat(25 * row);
                //Resets x back to initial position (216).
                x = -216;
            }
            //Increment x by 25 * col.
            x =  -216 + CGFloat(25 * col);
            //Sets the position of the sprite node.
            itemNode?.position = CGPoint(x: x + player.position.x, y: player.position.y + y);
            //Increments col.
            col += 1;
            //Adds the node to the scene.
            self.addChild(itemNode!);
            //Adds the node to invDisplay (list of item nodes in inventory).
            invDisplay.append(itemNode!);
            //Increments current index.
            currentIndex += 1;
        }
    }
    
    /**Updates the position of each sprite node for the inventory.
     *
     */
    func updateInv() {
        //Sets initial positions.
        var x: CGFloat = -215;
        var y: CGFloat = -45;
        //Sets the current column to 0.
        var col = 0;
        //Loops through each sprite node in invDisplay.
        for i in 0..<invDisplay.count {
            //Sets the current row to 0.
            var row = 0;
            //Checks if the index is divisible by 3.
            if (i % 3 == 0 && i != 0) {
                //Increments the row.
                row += 1;
                //Sets the column back to 0.
                col = 0;
                //Decrements y by 25 * row.
                y -= CGFloat(25 * row);
                //Resets x back to initial position (216).
                x = -216;
            }
            //Increment x by 25 * col.
            x = -216 + CGFloat(25 * col);
            //Updates the position of the sprite node relative to the player.
            invDisplay[i].position.x = x + player.position.x;
            invDisplay[i].position.y = y + player.position.y;
            //Increments col by 1.
            col += 1;
        }
    }
    
    /**Removes an item at a given index from the inventory.
     *
     */
    func removeFromInventory(itemIndex: Int) {
        //Removes item from inventory list.
        inv.removeItem(index: itemIndex);
        //Decrements current index.
        currentIndex -= 1;
        //Removes item at itemIndex from inventory.
        invDisplay[itemIndex].removeFromParent();
        //Removes item from invDisplay.
        invDisplay.remove(at: itemIndex);
        //Refills the inventory.
        fillInv();
    }
    
    
    /**ITEM OPERATIONS!!**/
    
    /**Accesses the item chosen by the player and uses it.
     *
     */
    func useItem(itemName: String, itemIndex: Int) {
        //Number corresponds to type of item.
        if (itemName == "Small Sword" || itemName == "Broadsword" || itemName == "Golden Sword" || itemName == "Jade Blade" || itemName == "Silver Knife" || itemName == "Golden Knife" || itemName == "Jade Knife") {
            equipWeapon(weaponName: itemName, itemIndex: itemIndex);
        } else if (itemName == "Energy Potion" || itemName == "Health Potion" || itemName == "Lethal Potion") {
            usePotion(potionName: itemName, itemIndex: itemIndex);
        } else if (itemName == "Axe" || itemName == "Pickaxe" || itemName == "Fishing Rod") {
            equipTool(toolName: itemName, itemIndex: itemIndex);
        } else {
            print("NOT YET IMPLEMENTED");
        }
    }
    
    /**Sells an item to a shop and adds to money.
     *
     */
    func sellItem(itemName: String, itemIndex: Int) {
        //Number corresponds to type of item.
        if (itemName == "Small Sword" || itemName == "Broadsword" || itemName == "Golden Sword" || itemName == "Jade Blade" || itemName == "Silver Knife" || itemName == "Golden Knife" || itemName == "Jade Knife") {
            sellWeapon(weaponName: itemName, itemIndex: itemIndex);
        } else if (itemName == "Energy Potion" || itemName == "Health Potion" || itemName == "Lethal Potion") {
            sellPotion(potionName: itemName, itemIndex: itemIndex);
        } else if (itemName == "Axe" || itemName == "Pickaxe" || itemName == "Fishing Rod") {
            sellTool(toolName: itemName, itemIndex: itemIndex);
        } else if (itemName == "Wood" || itemName == "Bricks" || itemName == "Steel") {
            sellMaterial(materialName: itemName, itemIndex: itemIndex);
        } else {
            print("NOT YET IMPLEMENTED");
        }
    }
    
    /**Buys an item from a shop and takes away from bank.
     *
     */
    func buyItem(itemName: String) {
        //Number corresponds to type of item.
        if (itemName == "Small Sword" || itemName == "Broadsword" || itemName == "Golden Sword" || itemName == "Jade Blade" || itemName == "Silver Knife" || itemName == "Golden Knife" || itemName == "Jade Knife") {
            buyWeapon(weaponName: itemName);
        } else if (itemName == "Energy Potion" || itemName == "Health Potion" || itemName == "Lethal Potion") {
            buyPotion(potionName: itemName);
        } else if (itemName == "Axe" || itemName == "Pickaxe" || itemName == "Fishing Rod") {
            buyTool(toolName: itemName);
        } else if (itemName == "Wood" || itemName == "Bricks" || itemName == "Steel") {
            buyMaterial(materialName: itemName);
        } else {
            print("NOT YET IMPLEMENTED");
        }
    }

    /**Pauses the game and adds an equip item message.
     */
    func equipMessage(itemName: String) {
        //Pauses game.
        self.isPaused = true;
        let m = Message();
        //Creates message buttons, message, etc.
        let message = "Would you like to equip a " + itemName + "?";
        let button1 = "Yes";
        let button2 = "No";
        let messageBack = m.backgroundMessage(posX: Int(player.position.x), posY: Int(player.position.y));
        self.addChild(messageBack);
        //Adds messageBack to messageNodes.
        messageNodes.append(messageBack);
        let messageDisplay = m.messageDisplay(messageContent: message, posX: Int(player.position.x), posY: Int(player.position.y) + 5);
        self.addChild(messageDisplay);
        //Adds message to messageNodes.
        messageNodes.append(messageDisplay);
        let buttonYes = m.buttonTitle(buttonContent: button1, posX: Int(messageDisplay.position.x) - 20, posY: Int(messageDisplay.position.y) - 15);
        let buttonNo = m.buttonTitle(buttonContent: button2, posX: Int(messageDisplay.position.x) + 20, posY: Int(messageDisplay.position.y) - 15);
        let buttonBackYes = m.buttonBack(posX: Int(messageDisplay.position.x) - 20, posY: Int(messageDisplay.position.y) - 15);
        //Adds button to decide buttons.
        decideButtons.append(buttonBackYes);
        let buttonBackNo = m.buttonBack(posX: Int(messageDisplay.position.x) + 20, posY: Int(messageDisplay.position.y) - 15);
        //Adds button to decide buttons.
        decideButtons.append(buttonBackNo);
        self.addChild(buttonYes);
        //Adds button to messaegNodes.
        messageNodes.append(buttonYes);
        self.addChild(buttonNo);
        //Adds button to messaegNodes.
        messageNodes.append(buttonNo);
        self.addChild(buttonBackYes);
        //Adds button to messaegNodes.
        messageNodes.append(buttonBackYes);
        self.addChild(buttonBackNo);
        //Adds button to messaegNodes.
        messageNodes.append(buttonBackYes);
    }
    
    /**Removes messages from screen and unpauses game.
     */
    func removeMessage() {
        messageNodes.removeAll();
        self.isPaused = false;
    }
    
    
    /**WEAPON OPERATIONS!!**/
    
    /**Equips a weapon and removes it from inventory.
     *
     */
    func equipWeapon(weaponName: String, itemIndex: Int) {
        if (!weaponEquipped && !toolEquipped) {
            //Creates new sword with with sword name.
            let weapon = Weapon(weaponName: weaponName);
            //Adds to player's attack by sword's power.
            p.addAttack(attackVal: CGFloat(weapon.getPower()));
            //Removes corresponding item from inventory.
            removeFromInventory(itemIndex: itemIndex);
            //Sets weapon equiped to true;
            weaponEquipped = true;
            //Sets current weapon to the sword's name.
            currentWeapon = weaponName;
            //Displays Player's stats.
            playerStats();
        } else {
            //Checks if weapon is equipped.
            if (weaponEquipped) {
                //Unequips the sword.
                unEquipWeapon(weaponName: currentWeapon);
                //Equips the new sword.
                equipWeapon(weaponName: weaponName, itemIndex: itemIndex);
            //Checks if tool is equipped.
            } else if (toolEquipped) {
                //Unequips tool.
                unEquipTool(toolName: currentTool);
                //Equips weapon.
                equipWeapon(weaponName: weaponName, itemIndex: itemIndex);
            }
        }
    }
    
    /**Unequips a weapon and adds to inventory.
     *
     */
    func unEquipWeapon(weaponName: String) {
        //Checks if inventory is full.
        if (inv.getSize() <= 9) {
            //Creates a new weapon
            let weapon = Weapon(weaponName: weaponName);
            //Subtracts money by weapon power.
            p.subAttack(attackVal: CGFloat(weapon.getPower()));
            //Creates new item.
            let item = Item(itemName: weapon.getName());
            //Adds item to inventory.
            inv.addItem(item: item);
            //Sets weapon equiped to false.
            weaponEquipped = false;
            currentWeapon = "";
            //Displays Player's stats.
            playerStats();
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    /**Sells a weapon to a store.
     *
     */
    func sellWeapon(weaponName: String, itemIndex: Int) {
        //Creates a new weapon.
        let weapon = Weapon(weaponName: weaponName);
        //Adds money by weapon price.
        p.addMoney(addedMoney: weapon.getPrice());
        //Removes weapon from inventory.
        removeFromInventory(itemIndex: itemIndex);
        //Displays player's stats.
        playerStats();
    }
    
    /**Buys a weapon from a store.
     *
     */
    func buyWeapon(weaponName: String) {
        if (inv.getSize() <= 9) {
            //Creates a new weapon.
            let weapon = Weapon(weaponName: weaponName);
            //Subtracts money by weapon price.
            p.subtractMoney(subMoney: weapon.getPrice());
            //Creates a new item for the weapon.
            let item = Item(itemName: weapon.getName());
            //Adds the item to the inventory.
            inv.addItem(item: item);
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    
    /**TOOL OPERATIONS!!**/
    
    /**Equips a tool and removes it from the inventory.
     *
     */
    func equipTool(toolName: String, itemIndex: Int) {
        //Checks if a weapon and tool is not equipped.
        if (!weaponEquipped && !toolEquipped) {
            //Creates a new tool.
            let tool = Tool(toolName: toolName);
            //Removes from inventory.
            removeFromInventory(itemIndex: itemIndex);
            //Sets current tool to the tool name.
            currentTool = tool.getName();
            //Sets toolEquipped to true.
            toolEquipped = true;
            playerStats();
        } else {
            //Checks if there is a weapon equipped.
            if (weaponEquipped) {
                //Unequips weapon.
                unEquipWeapon(weaponName: currentWeapon);
                //Equips tool.
                equipTool(toolName: toolName, itemIndex: itemIndex);
                //Checks if there is a tool equipped.
            } else if (toolEquipped) {
                //Unequips tool.
                unEquipTool(toolName: currentTool);
                //Equips tool.
                equipTool(toolName: toolName, itemIndex: itemIndex);
            }
        }
    }
    
    /**Unequips a tool and adds it to inventory.
     *
     */
    func unEquipTool(toolName: String) {
        //Checks if inventory size is less than 9.
        if (inv.getSize() <= 9) {
            //Creates a new tool.
            let tool = Tool(toolName: toolName);
            //Creates new item.
            let item = Item(itemName: tool.getName());
            //Adds item to inventory.
            inv.addItem(item: item);
            //Sets tool equipped to false.
            toolEquipped = false;
            currentTool = "";
            //Displays Player's stats.
            playerStats();
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    /**Sells a tool and removes it from the inventory.
     *
     */
    func sellTool(toolName: String, itemIndex: Int) {
        //Creates a new tool.
        let tool = Tool(toolName: toolName);
        //Adds tool price to money.
        p.addMoney(addedMoney: tool.getPrice());
        //Removes from inventory.
        removeFromInventory(itemIndex: itemIndex);
        playerStats();
    }
    
    /**Buys a tool and adds it to the inventory.
     *
     */
    func buyTool(toolName: String) {
        //Checks the size of the inventory.
        if (inv.getSize() <= 9) {
            //Creates a new tool.
            let tool = Tool(toolName: toolName);
            //Subtracts the tool price from money.
            p.subtractMoney(subMoney: tool.getPrice());
            //Creates a new item.
            let item = Item(itemName: tool.getName());
            //Adds item to inventory.
            inv.addItem(item: item);
            playerStats();
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    
    /**POTION OPERATIONS!!**/
    
    /**Uses a potion and removes it from inventory.
     *
     */
    func usePotion(potionName: String, itemIndex: Int) {
        switch potionName {
        case("Energy Potion"):
            //Sets potion to energy potion.
            let potion = EnergyPotion();
            p.addExp(addedExp: 2);
            playerStats();
            //Removes item at itemIndex from inventory.
            removeFromInventory(itemIndex: itemIndex);
        case("Health Potion"):
            //Sets potion to health potion.
            let potion = HealthPotion();
            //Replinishes player's health from potion.
            replinishHealth(replinishSize: potion.getHealthValue());
            //Removes item at itemIndex from inventory.
            removeFromInventory(itemIndex: itemIndex);
        case("Lethal Potion"):
            //Sets potion to lethal potion.
            let potion = LethalPotion();
            //Decreases player's health from potion.
            takesDamage(damageSize: potion.getDamageValue());
            //Removes item at itemIndex from inventory.
            removeFromInventory(itemIndex: itemIndex);
        default:
            print("Unknown Potion");
        }
    }
    
    /**Sells a potion, adds to player's money, and removes potion from inventory.
     *
     */
    func sellPotion(potionName: String, itemIndex: Int) {
        //Creates a new potion.
        let potion = Potion(potionName: potionName);
        //Adds potion price to money.
        p.addMoney(addedMoney: potion.getPotionPrice());
        //Removes from inevntory.
        removeFromInventory(itemIndex: itemIndex);
        playerStats();
    }
    
    /**Buys a potion from a store.
     *
     */
    func buyPotion(potionName: String) {
        if (inv.getSize() <= 9) {
            //Creates a new potion.
            let potion = Potion(potionName: potionName);
            //Subrtracts potion price from money.
            p.subtractMoney(subMoney: potion.getPotionPrice());
            //Creates a new item for the potion.
            let item = Item(itemName: potion.getPotionName());
            //Adds the item to the inventory.
            inv.addItem(item: item);
            playerStats();
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    
    /**MATERIAL OPERATIONS!!**/
    
    /**Sells a material and removes it from inventory.
     *
     */
    func sellMaterial(materialName: String, itemIndex: Int) {
        let material = Material(materialName: materialName);
        p.addMoney(addedMoney: material.getPrice());
        removeFromInventory(itemIndex: itemIndex);
        playerStats();
    }
    
    /**Buys a material and adds it to inventory.
     *
     */
    func buyMaterial(materialName: String) {
        if (inv.getSize() <= 9) {
            let material = Material(materialName: materialName);
            p.subtractMoney(subMoney: material.getPrice());
            let item = Item(itemName: material.getName());
            inv.addItem(item: item);
            playerStats();
        } else {
            print("Your bag is full! Please remove an item!");
        }
    }
    
    func getData() {
        let savedLevel = data.object(forKey: "Player_Level") as? Int ?? Int();
        p.setLevel(currentLevel: savedLevel);
    }
    
    func setData() {
        var currentLevel = p.getLevel();
        if (currentLevel == 0) {
            currentLevel = 1;
        }
        data.set(currentLevel, forKey: "Player_Level");
    }
    
    override func update(_ currentTime: TimeInterval) {
        //setData();
        count += 1;
        //Player Functions.
        playerMovement();
        checkHealth();
        fightTime();
        fightMode();
        toolMode();
        //Inventory Functions.
        pickUpItem();
        updateInv();
        //Environment Functions.
        collideNature();
        collideChest();
        checkPlayerPos();
        //houseAlertAnimation();
    }
}

