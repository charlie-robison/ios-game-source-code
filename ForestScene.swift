//
//  GameScene.swift
//  RPG
//
//  Created by Charlie Robison on 6/6/21.
//  Copyright © 2021 Charlie Robison. All rights reserved.
//

import SpriteKit
import GameplayKit

class ForestScene: SKScene {
    
    private let data = UserDefaults.standard;
    
    //Object References.
    let p = Player();
    var inv = Inventory();
    private let itemData = ItemDataBase();
    private let fight = Fight();
    private let m = Message();
    
    //Sprite Nodes.
    var player = SKSpriteNode();
    private var cameraNode = SKCameraNode();
    
    //Player Controls.
    private var rightButton = SKSpriteNode();
    private var leftButton = SKSpriteNode();
    private var upButton = SKSpriteNode();
    private var downButton = SKSpriteNode();
    private var invSlots = SKSpriteNode();
    private var levelDisplay = SKLabelNode();
    var expLabel = SKLabelNode();
    
    //Button Checks.
    private var up = false;
    private var down = false;
    private var left = false;
    private var right = false;
    
    //Holds all enemy nodes.
    private var enemies: [SKSpriteNode] = [];
    //Holds all enemy names.
    private var enemyNames: [String] = [];
    //Holds all enemy objects.
    private var enemyObj: [Enemy] = [];
    private var enemyLevels: [SKLabelNode] = [];
    //Holds all enemy fight states.
    private var enemyFightStates: [Bool] = [];
    
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
    
    
    //Money Display
    var moneyLabel = SKLabelNode();
    
    
    //Environments
    private var trees: [SKSpriteNode] = [];
    private var treePosX: [CGFloat] = [];
    private var treePosY: [CGFloat] = [];
    private var trunks: [SKSpriteNode] = [];
    private var trunkNames: [String] = [];
    private var rocks: [SKSpriteNode] = [];
    private var rockPosX: [CGFloat] = [];
    private var rockPosY: [CGFloat] = [];
    
    
    
    //Inventory.
    //Names for items.
    private var itemsSpawnArray: [String] = [];
    var tempItemsArray: [Item] = [];
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
        //recieveData();
        inv = Inventory(list: tempItemsArray);
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
        //Spawns trees and rocks and enemies in random locations.
        spawnTree(maxNumberOfTrees: 10, xMax: 320, yMax: 120);
        spawnRock(maxNumberOfRocks: 10, xMax: 320, yMax: 120);
        spawnEnemy(maxNumberOfEnemies: 5, xMax: 320, yMax: 120);
    }
    
    /**Saves data in scene to be recalled later.
     */
    func saveData() {
        //Saves tree and rock position information.
        data.set(treePosX, forKey: "Tree_X_Pos");
        data.set(treePosY, forKey: "Tree_Y_Pos");
        data.set(rockPosX, forKey: "Rock_X_Pos");
        data.set(rockPosY, forKey: "Rock_Y_Pos");
    }
    
    /**Receives data from previous save.
     */
    func recieveData() {
        //Recieves tree and rock position information.
        treePosX = data.array(forKey: "Tree_X_Pos") as? [CGFloat] ?? [CGFloat]();
        treePosY = data.array(forKey: "Tree_Y_Pos") as? [CGFloat] ?? [CGFloat]();
        rockPosX = data.array(forKey: "Rock_X_Pos") as? [CGFloat] ?? [CGFloat]();
        rockPosY = data.array(forKey: "Rock_Y_Pos") as? [CGFloat] ?? [CGFloat]();
    }
    
    /**Switches to TownScene.
     */
    func toTown() {
        if (player.position.y < -320) {
            saveData();
            let townScene = TownScene(fileNamed: "Town");
            townScene?.health = health;
            townScene?.healthPos = healthPos;
            townScene?.healthWidth = healthWidth;
            townScene?.fightState = fightState;
            townScene?.toolState = toolState;
            townScene?.weaponEquipped = weaponEquipped;
            townScene?.toolEquipped = toolEquipped;
            townScene?.currentWeapon = currentWeapon;
            townScene?.currentTool = currentTool;
            townScene?.numberOfMaterials = numberOfMaterials;
            //townScene?.tempItemsArray = inv.getList();
            townScene?.p.setLevel(currentLevel: p.getLevel());
            townScene?.p.setMoney(newVal: p.getMoney());
            self.scene?.view?.presentScene(townScene);
            print("Wood:  " + String(numberOfMaterials[0]));
            print("Bricks: " + String(numberOfMaterials[1]));
            print("Steel: " + String(numberOfMaterials[2]));
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
                    print("YOO");
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
        healthWidth = healthMeter.size.width;
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
            healthWidth = healthMeter.size.width;
            healthPos += (healthDifference + healthFactor);
            //Incrments player's health by replinishSize.
            health += healthDifference;
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
    
    
    /**ENEMY OPERATIONS!!**/
    
    /**Checks if the player is close to any of the enemies.
     * If the player is close, the enemies follow the player.
     *
     */
    func updateEnemies() {
        //Gives values for max distance.
        let maxX: Double = 80;
        let maxY: Double = 80;
        let maxRadius: Double = ((maxX * maxX) + (maxY * maxY)).squareRoot();
        //Stores SkAction to follow player.
        let moveToPlayer = SKAction.move(to: player.position, duration:2.0);
        let stayStill = SKAction.move(by: CGVector(dx: 0, dy: 0), duration: 2.0);
        //Loops through all enemies in the scene.
        for i in 0..<enemies.count {
            checkEnemyState(enemyIndex: i);
            //Health bars follow enemy.
            followEnemy(enemy: enemies[i], index: i);
            //Stores distance between player and each enemy.
            let distanceX: Double = Double(abs(player.position.x - enemies[i].position.x));
            let distanceY: Double = Double(abs(player.position.y - enemies[i].position.y));
            let radius: Double = Double(((distanceX * distanceX) + (distanceY * distanceY)).squareRoot());
            //Checks if the distance between the player and enemy are less than the max values.
            if (radius <= maxRadius) {
                //Adds the SKAction to the enemy.
                enemies[i].run(moveToPlayer);
                //Sets the enemy fight state.
                setEnemyFightState(index: i);
            } else {
                //Sets enemies velocity to 0.
                enemies[i].run(stayStill);
                //Sets enemy fight state to false.
                enemyFightStates[i] = false;
            }
        }
    }
    
    /**Sets the enemy fight state for the enemy at the index.
     */
    func setEnemyFightState(index: Int) {
        //Gets random number.
        let randomNum = Int.random(in: 0..<10);
        //Checks if randomNum divides 11.
        if (randomNum % 11 == 0) {
            //Sets state to true.
            enemyFightStates[index] = true;
        } else {
            //Sets state to false.
            enemyFightStates[index] = false;
        }
    }
    
    /**Checks what the enemy's state is.
     */
    func checkEnemyState(enemyIndex: Int) {
        //Checks if fight state for enemy is true.
        if (enemyFightStates[enemyIndex]) {
            enemies[enemyIndex].color = UIColor.green;
        } else {
            enemies[enemyIndex].color = UIColor.red;
        }
    }
    
    /**Enemy level label follow enemy.
     */
    func followEnemy(enemy: SKSpriteNode, index: Int) {
        enemyLevels[index].position = CGPoint(x: enemy.position.x, y: enemy.position.y + 10);
    }
    
    /**Checks the health of the enemy. Removes enemy from scene if health is 0.
     *
     */
    func checkEnemyHealth(enemy: SKSpriteNode, enemyIndex: Int) {
        let currentEnemy = enemies[enemyIndex];
        let currentEnemyObj = enemyObj[enemyIndex];
        let enemyLevel = enemyLevels[enemyIndex];
        //Checks if enemy health is zero.
        if (currentEnemyObj.getHealth() <= 0) {
            let oldLevel = currentEnemyObj.getLevel();
            //Removes enemy from scene.
            currentEnemy.removeFromParent();
            enemyLevel.removeFromParent();
            //Adds exp to player.
            p.addExp(addedExp: currentEnemyObj.expGiven());
            p.addMoney(addedMoney: oldLevel * 5);
            if (p.getExp() >= p.getMaxExp()) {
                resetPlayerHealth();
            }
        }
    }
    
    /**Enemy takes damage from player.
     */
    func enemyDamage(enemy: SKSpriteNode, enemyIndex: Int) {
        //Gets the current enemy object for enemyIndex.
        let currentEnemy = self.enemyObj[enemyIndex];
        //Checks the enemy's health.
        checkEnemyHealth(enemy: enemy, enemyIndex: enemyIndex);
        //Stores the enemyDefense.
        let enemyDefense = currentEnemy.getDefense();
        //Stores the damage taken from the player.
        let damage: CGFloat = fight.damageFromAttack(attack: p.getAttack(), defense: enemyDefense);
        //Sets the damage on the current enemy.
        currentEnemy.takeDamage(damage: damage);
        return;
    }
    
    /**Checks if there is a collision between the player and an enemy.
     *
     */
    func collideEnemy() {
        //Loops through all enemy nodes.
        for e in enemies {
            //Enumerates all nodes that are enemies.
            enumerateChildNodes(withName: e.name!) { [self] node, _ in
                //Stores the current index of the enemy.
                let enemyIndex = self.enemyNames.firstIndex(of: e.name!);
                let enemy = node as! SKSpriteNode;
                //Checks if enemy intersects player.
                if (enemy.frame.intersects(self.player.frame)) {
                    //Checks if player is in fight state.
                    if (self.weaponEquipped && self.fightState) {
                        //Enemy takes damage.
                        enemyDamage(enemy: enemy, enemyIndex: enemyIndex!);
                        return;
                    }
                    //Checks if enemy is in fight state.
                    if (self.enemyFightStates[enemyIndex!]) {
                        //Gets damage from enemy.
                        let damage = fight.damageFromAttack(attack: enemyObj[enemyIndex!].getAttack(), defense: p.getDefense());
                        //Decreases player's health.
                        takesDamage(damageSize: damage);
                    }
                }
            }
        }
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
    
    
    /**Spawns  a random number of enemies up to a max value and between a certain range.
     */
    func spawnEnemy(maxNumberOfEnemies: Int, xMax: CGFloat, yMax: CGFloat) {
        //Hold the number of enemies.
        var numberOfEnemies = Int.random(in: 1...maxNumberOfEnemies);
        //Loops while numberOfEnemies is greater than zero.
        while(numberOfEnemies > 0) {
            //Decrements numberOfEnemies.
            numberOfEnemies -= 1;
            var randomLevel = 0;
            //Creates a new enemy.
            if (p.getLevel() <= 1) {
                randomLevel = Int.random(in: 1..<(p.getLevel() + 1));
            } else {
                randomLevel = Int.random(in: (p.getLevel() - 1)..<(p.getLevel() + 1));
            }
            let e = Enemy(enemyLevel: randomLevel);
            let enemy = e.getEnemy();
            //Gets random x and y positions.
            let randomXPos = CGFloat.random(in: -xMax..<xMax);
            let randomYPos = CGFloat.random(in: -xMax..<xMax);
            //Sets positions.
            enemy.position = CGPoint(x: randomXPos, y: randomYPos);
            //Holds result of checkPos.
            let checkSpawn = checkPos(posX: randomXPos, posY: randomYPos);
            //Checks if checkSpawn is true.
            if (checkSpawn) {
                //Adds enemy to scene.
                self.addChild(enemy);
                //Adds enemy to enemies array.
                enemies.append(enemy);
                //Creates the enemy's name.
                enemy.name = "Enemy" + String(enemies.count);
                //Adds enemy name to array.
                enemyNames.append(enemy.name!);
                //Adds enemy object to array.
                enemyObj.append(e);
                //Sets initial fight state.
                let enemyFightState = false;
                //Adds fight state to array.
                enemyFightStates.append(enemyFightState);
                //Creates a label node for enemy.
                let enemyLevel = SKLabelNode(text: "Lv: " + String(e.getLevel()));
                enemyLevel.fontColor = UIColor.white;
                enemyLevel.fontSize = 10;
                enemyLevel.zPosition = 1;
                enemyLevel.position = CGPoint(x: enemy.position.x, y: 10 + enemy.position.y);
                enemyLevels.append(enemyLevel);
                self.addChild(enemyLevel);
            } else {
                return;
            }
        }
    }
    
    
    /**Spawns  a random number of rocks up to a max value and between a certain range.
     */
    func spawnRock(maxNumberOfRocks: Int, xMax: CGFloat, yMax: CGFloat) {
        //Checks if there were previously rocks.
        if (rockPosX.count > 0) {
            //Loops through each rock position.
            for pos in 0..<rockPosX.count {
                //Creates a rock at the given position.
                let r = Rock();
                let rock = r.getRock();
                rock.position = CGPoint(x: rockPosX[pos], y: rockPosY[pos]);
                self.addChild(rock);
                //Adds nodes to list.
                rocks.append(rock);
            }
            return;
        }
        //Hold the number of rocks.
        var numberOfRocks = Int.random(in: 1...maxNumberOfRocks);
        //Loops while numberOfRocks is greater than zero.
        while(numberOfRocks > 0) {
            //Decrements numberOfRocks.
            numberOfRocks -= 1;
            //Creates a new rock.
            let r = Rock();
            let rock = r.getRock();
            //Gets random x and y positions.
            let randomXPos = CGFloat.random(in: -xMax..<xMax);
            let randomYPos = CGFloat.random(in: -xMax..<xMax);
            //Sets positions.
            rock.position = CGPoint(x: randomXPos, y: randomYPos);
            //Adds nodes to scene.
            self.addChild(rock);
            //Adds nodes to list.
            rocks.append(rock);
            rockPosX.append(rock.position.x);
            rockPosY.append(rock.position.y);
        }
    }
    
    /**Spawns  a random number of trees up to a max value and between a certain range.
     */
    func spawnTree(maxNumberOfTrees: Int, xMax: CGFloat, yMax: CGFloat) {
        //Checks if there were previously trees.
        if (treePosX.count > 0) {
            //Loops through each tree position.
            for pos in 0..<treePosX.count {
                //Creates a tree at the given position.
                let t = Tree();
                let tree = t.getTree();
                let trunk = t.getTrunk();
                trunk.name = "Trunk" + String(trunks.count);
                tree.position = CGPoint(x: treePosX[pos], y: treePosY[pos]);
                trunk.position =  CGPoint(x: tree.position.x - 5, y: tree.position.y - 5);
                self.addChild(tree);
                self.addChild(trunk);
                //Adds nodes to list.
                trees.append(tree);
                trunks.append(trunk);
                trunkNames.append(trunk.name!);
            }
            return;
        }
        //Hold the number of trees.
        var numberOfTrees = Int.random(in: 1...maxNumberOfTrees);
        //Loops while numberOfTrees is greater than zero.
        while(numberOfTrees > 0) {
            //Decrements numberOfTrees.
            numberOfTrees -= 1;
            //Creates a new tree and trunk.
            let t = Tree();
            let tree = t.getTree();
            let trunk = t.getTrunk();
            
            //Gets random x and y positions.
            let randomXPos = CGFloat.random(in: -xMax..<xMax);
            let randomYPos = CGFloat.random(in: -xMax..<xMax);
            //Sets positions.
            tree.position = CGPoint(x: randomXPos, y: randomYPos);
            trunk.position =  CGPoint(x: tree.position.x - 5, y: tree.position.y - 5);
            //Adds nodes to scene.
            self.addChild(tree);
            self.addChild(trunk);
            trunk.name = "Trunk" + String(trunks.count);
            //Adds nodes to list.
            trees.append(tree);
            trunks.append(trunk);
            trunkNames.append(trunk.name!);
            treePosX.append(tree.position.x);
            treePosY.append(tree.position.y);
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
        if (materialList[randomName] == "Bricks") {
            numberOfMaterials[1] += 1;
        } else {
            numberOfMaterials[2] += 1;
        }
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
        //Removes the trunk from the scene.
        tree.removeFromParent();
        //Removes the tree from the scene.
        trees[treeIndex].removeFromParent();
        treePosX.remove(at: treeIndex);
        treePosY.remove(at: treeIndex);
        //List holds wood.
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
        numberOfMaterials[0] += 1;
        woodLabel.text =  "Wood: " + String(numberOfMaterials[0]);
        brickLabel.text = "Brick: " + String(numberOfMaterials[1]);
        steelLabel.text = "Steel: " + String(numberOfMaterials[2]);
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
                //let treeIndex = self.trunks.firstIndex(of: t);
                let treeIndex = self.trunkNames.firstIndex(of: t.name!);
                let tree = node as! SKSpriteNode;
                //Checks if treeintersects player.
                if (tree.frame.intersects(self.player.frame)) {
                    //Checks if player is in toolState and if current tool is an axe.
                    if (self.toolEquipped && self.toolState && self.currentTool == "Axe") {
                        //Breaks the tree into materials.
                        self.breakTree(tree: tree, treeIndex: treeIndex!);
                        return;
                    }
                }
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
        setData();
        count += 1;
        //Player Functions.
        playerMovement();
        checkHealth();
        fightTime();
        fightMode();
        toolMode();
        //Enemy Functions.
        updateEnemies();
        collideEnemy();
        //Inventory Functions.
        spawnItems();
        pickUpItem();
        updateInv();
        //Environment Functions.
        collideNature();
        toTown();
    }
}
