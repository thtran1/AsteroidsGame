int screenSize = 700;
int areaSize = 24;
//float areaX = (areaSize/2);
//float areaY = (areaSize/2);
float areaX = 1;
float areaY = 1;
float posX = screenSize/2;
float posY = screenSize/2;
int currentLevel = 1;
int highestLevel = currentLevel;
int points = 0;
SpaceShip ship = new SpaceShip(screenSize/2, screenSize/2);
SpaceShipControl control = new SpaceShipControl();
//RobotSpaceShip robot = new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
ArrayList <RobotSpaceShip> robot = new ArrayList <RobotSpaceShip>();
ArrayList <FriendlySpaceShip> friendly = new ArrayList <FriendlySpaceShip>();
ArrayList <Coins> coins = new ArrayList <Coins>();
ArrayList <Debris> debris = new ArrayList <Debris>();
SpaceStation spacestation = new SpaceStation(screenSize/2, screenSize/2);
SpaceStation robotstation = new SpaceStation(screenSize/2+(screenSize*22), screenSize/2+(screenSize*22));
//Asteroid[] asteroid = new Asteroid[50];
ArrayList <Bullet> bullet = new ArrayList <Bullet>();
ArrayList <RobotBullet> robotbullet = new ArrayList <RobotBullet>();
ArrayList <FriendlyBullet> friendlybullet = new ArrayList <FriendlyBullet>();
ArrayList <Asteroid> asteroid;
ArrayList <Float> rAX;
ArrayList <Float> rAY;
ArrayList <Float> fAX;
ArrayList <Float> fAY;
FuelCan fuelcan = new FuelCan();
HyperJump hyperjump = new HyperJump();
Speed speed = new Speed();
Health health = new Health();
Fuel fuel = new Fuel();
BulletCool bulletcool = new BulletCool();
areaMap map = new areaMap();
helpButton help = new helpButton();
Menu menu = new Menu();
Star[] stars = new Star[screenSize/10];//your variable declarations here
double gravity = 1.020;
double hypergravity = 1.50;
double maxTorque = 0.2; //0.2
double hyperTorque = maxTorque*50;
int rotateSpeed = 1;
int topSpeed = 10;
int hyperSpeed = topSpeed*3;
int bulletSpeed = 25;
float bulletCoolDown = 10;
float bulletCoolDownMax = 10;
float bulletS = 2;
float bulletSpray = 0;
int shootMode = 0;
int shootCool = 0;
int shootCoolTime = 5; //delay bullets
double shootDamage = 5; //5
double robotShootDamage = 3+(currentLevel/5); //3
double friendlyShootDamage = shootDamage*(0.6);
int maxMissed = 5;
int robotsAlive, intRobotsAlive, friendlysAlive, intFriendlysAlive;
int intRobots = 3;
int intFriendlys = 1;
float currentFuel = fuel.maxFuel;
float addFuel = 0;
float addHealth = 0;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
boolean qPressed = false;
boolean ePressed = false;
boolean jPressed = false;
boolean spacePressed = false;
boolean gameStop = true;
boolean defend = true;
boolean crazyMode = false;
boolean hyperspace = false;
public void setup() 
{
  frameRate(60);
  size(900, 700);
  background(0);
  screenSize = height;
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  asteroid = new ArrayList <Asteroid>();
  rAX = new ArrayList <Float>();
  rAY = new ArrayList <Float>();
  fAX = new ArrayList <Float>();
  fAY = new ArrayList <Float>();
  for (int i = 0; i < 10; i++) {
    asteroid.add(new Asteroid());
  }
  for (int i = 0; i < 0; i++) {
    robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
    rAX.add(i, (float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
    rAY.add(i, (float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
    robot.get(i).setAreaX((int)(Math.random()*areaSize/2)+(areaSize/4)+0.5);
    robot.get(i).setAreaY((int)(Math.random()*areaSize/2)+(areaSize/4)+0.5);
    robot.get(i).setX((int)((screenSize/2)+(screenSize*(robot.get(i).getAreaX()-areaX))));
    robot.get(i).setY((int)((screenSize/2)+(screenSize*(robot.get(i).getAreaY()-areaY))));
    robot.get(i).target = (int)(Math.random()*(friendly.size()+1));
  }
  for (int i = 0; i < 0; i++) {
    friendly.add(new FriendlySpaceShip(height/2, height/2));
    fAX.add(i, (float)((areaX)+(friendly.get(i).getX()-(screenSize/2))/screenSize));
    fAY.add(i, (float)((areaY)+(friendly.get(i).getY()-(screenSize/2))/screenSize));
    friendly.get(i).target = (int)(Math.random()*robot.size());
  }
  robotsAlive = robot.size();
  intRobotsAlive = robot.size();
  friendlysAlive = friendly.size();
  intFriendlysAlive = friendly.size();
}

public void draw() 
{
  //fill((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))*5,100);
  if (gameStop) {
    menu.mainmenu();
  } else if (!gameStop) {
    fill(0);
    rect(-100, -100, screenSize+100, screenSize+100);
    for (int i = 0; i < stars.length; i++) {
      stars[i].show();
    }
    if (dist(spacestation.getX(), spacestation.getY(), ship.getX(), ship.getY())<50*spacestation.stationSize)
    {
      if (health.currentHealth < health.maxHealth) {
        health.currentHealth += 0.001*health.maxHealth;
        health.barColor = color(255, 150, 150);
      }
      if (addHealth<50) {
        addHealth+=1;
      }
    }
    for (int i = 0; i<robot.size (); i++) {
      if (dist(robotstation.getX(), robotstation.getY(), robot.get(i).getX(), robot.get(i).getY())<50*robotstation.stationSize)
      {
        if (robot.get(i).currentHealth < robot.get(i).maxHealth && robot.get(i).currentHealth>0) {
          robot.get(i).currentHealth += 0.001*robot.get(i).maxHealth;
        }
        if (addHealth<50) {
          addHealth+=1;
        }
      }
    }
    for (int i = 0; i<friendly.size (); i++) {
      if (dist(spacestation.getX(), spacestation.getY(), friendly.get(i).getX(), friendly.get(i).getY())<50*spacestation.stationSize)
      {
        if (friendly.get(i).currentHealth < friendly.get(i).maxHealth && friendly.get(i).currentHealth>0) {
          friendly.get(i).currentHealth += 0.001*friendly.get(i).maxHealth;
        }
        if (addHealth<50) {
          addHealth+=1;
        }
      }
    }
    if (addHealth>0) {
      addHealth-=0.5;
    }
    if (dist(spacestation.getX(), spacestation.getY(), ship.getX(), ship.getY())>25*spacestation.stationSize) {
      fuel.barColor = color(100);
      health.barColor = color(255, 0, 0);
    }
    if ((int)shootCool>0) {
      shootCool-=1;
    }
    for (int i = 0; i <robot.size (); i++) {
      if ((int)robot.get(i).robotShootCool>0) {
        robot.get(i).robotShootCool-=1;
      }
    }
    for (int i = 0; i <friendly.size (); i++) {
      if ((int)friendly.get(i).friendlyShootCool>0) {
        friendly.get(i).friendlyShootCool-=1;
      }
    }
    //if (areaX != areaSize/2 || areaY != areaSize/2) {
    for (int i = 0; i < asteroid.size (); i++) {
      asteroid.get(i).show();
      asteroid.get(i).move();
    }

    if (dist(fuelcan.getX(), fuelcan.getY(), ship.getX(), ship.getY())<80) {
      fuelcan.isTouched = true;
      if (currentFuel<fuel.maxFuel) {
        if (currentFuel<fuel.maxFuel-(fuel.maxFuel/4)) {
          currentFuel+=fuel.maxFuel/4;
          addFuel = 50;
        }
        if (currentFuel>fuel.maxFuel-(fuel.maxFuel/4)) {
          currentFuel=fuel.maxFuel;
          addFuel = 50;
        }
      }
    }
    if (fuelcan.isTouched == false) {
      fuelcan.show();
      fuelcan.move();
    }
    //}
    //if (areaX == areaSize/2 && areaY == areaSize/2) {
    //if (areaX == 1 && areaY == 1) {
    spacestation.show();
    //robotstation.show();
    //}
    //if(areaX==23 && areaY==23) {
    robotstation.show();
    //}
    //fill(0, (abs(areaX-(areaSize/2))+abs(areaY-(areaSize/2)))*10);
    //rect(-100, -100, screenSize+100, screenSize+100);
    for (int i = 0; i < coins.size (); i++) {
      if (coins.get(i).reset == false) {
        coins.get(i).show();
        coins.get(i).coinOp+=1;
        if (coins.get(i).coinOp>=800) {
          coins.remove(i);
          continue;
        }
      }
      if (coins.get(i).reset == true) {
        fill(coins.get(i).myColor, 200-(float)coins.get(i).textUp);
        textAlign(CENTER, CENTER);
        textSize(20);
        text((int)coins.get(i).currentPoints, (float)coins.get(i).getX(), (float)(coins.get(i).getY()-coins.get(i).textUp));
        coins.get(i).textUp+=1;
        if (coins.get(i).textUp == 100) {
          coins.remove(i);
        }
      }
    }
    for (int i = 0; i < debris.size (); i++) {
      if (debris.get(i).debrisOp>0) {
        debris.get(i).move();
        debris.get(i).show();
        debris.get(i).debrisOp-=1;
      }
      if (debris.get(i).debrisOp<=0) {
        debris.remove(i);
      }
    }
    for (int i = 0; i<bullet.size (); i++) {
      bullet.get(i).move();
      bullet.get(i).show();
      if (abs(bullet.get(i).getX()-height/2)>=height*3||abs(bullet.get(i).getY()-height/2)>=height*3) {
        bullet.remove(i);
      }
    }
    for (int i = 0; i<robotbullet.size (); i++) {
      robotbullet.get(i).move();
      robotbullet.get(i).show();
      if (abs(robotbullet.get(i).getX()-height/2)>=height*3||abs(robotbullet.get(i).getY()-height/2)>=height*3) {
        if (robot.size()>0) {
          robot.get((int)Math.random()*robot.size()).missed+=maxMissed*2;
        }
        robotbullet.remove(i);
      }
    }
    for (int i = 0; i<friendlybullet.size (); i++) {
      friendlybullet.get(i).move();
      friendlybullet.get(i).show();
      if (abs(friendlybullet.get(i).getX()-height/2)>=height*3||abs(friendlybullet.get(i).getY()-height/2)>=height*3) {
        if (friendly.size()>0) {
          friendly.get((int)Math.random()*friendly.size()).missed+=maxMissed*2;
        }
        friendlybullet.remove(i);
      }
    }
    for (int i = 0; i < robot.size (); i++) {
      for (int x = 0; x <bullet.size (); x++) {
        if (dist(bullet.get(x).getX(), bullet.get(x).getY(), robot.get(i).getX(), robot.get(i).getY()) < 25+bullet.get(x).bulletSize) {
          if (shootMode == 0) {
            robot.get(i).currentHealth-=shootDamage*1.5;
            bullet.remove(x);
          }
          if (shootMode == 1) {
            robot.get(i).currentHealth-=shootDamage/3;
            bullet.remove(x);
          }
          if (shootMode == 2) {
            robot.get(i).currentHealth-=shootDamage*10*(bullet.get(x).touched);
            bullet.get(x).touched=bullet.get(x).touched/1.5;
          }
          debris.add(new Debris(robot.get(i).getX(), robot.get(i).getY(), robot.get(i).getDirectionX(), robot.get(i).getDirectionY()));
          if (robot.get(i).currentHealth <= 0) {
            robot.get(i).shipShot = true;
          }
          break;
        }
      }
      for (int x = 0; x <friendlybullet.size (); x++) {
        if (dist(friendlybullet.get(x).getX(), friendlybullet.get(x).getY(), robot.get(i).getX(), robot.get(i).getY()) < 15+friendlybullet.get(x).bulletSize) {
          robot.get(i).currentHealth-=friendlyShootDamage;
          debris.add(new Debris(robot.get(i).getX(), robot.get(i).getY(), robot.get(i).getDirectionX(), robot.get(i).getDirectionY()));
          friendlybullet.remove(x);
          break;
        }
      }
    }
    for (int x = 0; x < robotbullet.size (); x++) {
      if (dist(robotbullet.get(x).getX(), robotbullet.get(x).getY(), ship.getX(), ship.getY()) < 15+robotbullet.get(x).bulletSize) {
        health.currentHealth-=robotShootDamage;
        debris.add(new Debris(ship.getX(), ship.getY(), ship.getDirectionX(), ship.getDirectionY()));
        robotbullet.remove(x);
        break;
      }
      for (int y = 0; y < friendly.size (); y++) {
        if (dist(robotbullet.get(x).getX(), robotbullet.get(x).getY(), friendly.get(y).getX(), friendly.get(y).getY()) < 15+robotbullet.get(x).bulletSize) {
          friendly.get(y).currentHealth-=robotShootDamage;
          debris.add(new Debris(friendly.get(y).getX(), friendly.get(y).getY(), friendly.get(y).getDirectionX(), friendly.get(y).getDirectionY()));
          robotbullet.remove(x);
          break;
        }
      }
    }
    for (int i = 0; i < robot.size (); i++) {
      if (robot.get(i).dead == false) {
        if (robot.get(i).currentHealth<=0) {
          robot.get(i).dead = true;
          robot.get(i).myColor = color(200, 0);
          for (int j = 0; j < 10; j++) {
            debris.add(new Debris(robot.get(i).getX(), robot.get(i).getY(), robot.get(i).getDirectionX(), robot.get(i).getDirectionY()));
          }
          break;
        }
        robot.get(i).reFuel();
        robot.get(i).control();
        robot.get(i).move();
        robot.get(i).show();
        rAX.set(i, robot.get(i).getAreaX());
        rAY.set(i, robot.get(i).getAreaY());
      }
      if (robot.get(i).dead == true) {
        robot.get(i).move();
        robot.get(i).show();
        robot.get(i).explode();
        robot.get(i).explodeSize+=3;
        robot.get(i).explodeOp-=3;
        if (robot.get(i).explodeOp<=0) {
          if (robot.get(i).shipShot == true) {
            coins.add(new Coins(robot.get(i)));
          }
          robot.remove(i);
          rAX.remove(i);
          rAY.remove(i);
        }
      }
    }
    for (int i = 0; i < friendly.size (); i++) {
      if (friendly.get(i).dead == false) {
        if (friendly.get(i).currentHealth<=0) {
          friendly.get(i).dead = true;
          friendly.get(i).myColor = color(200, 0);
          for (int j = 0; j < 10; j++) {
            debris.add(new Debris(friendly.get(i).getX(), friendly.get(i).getY(), friendly.get(i).getDirectionX(), friendly.get(i).getDirectionY()));
          }
          break;
        }
        friendly.get(i).reFuel();
        friendly.get(i).control();
        friendly.get(i).move();
        friendly.get(i).show();
        fAX.set(i, friendly.get(i).getAreaX());
        fAY.set(i, friendly.get(i).getAreaY());
      }
      if (friendly.get(i).dead == true) {
        friendly.get(i).move();
        friendly.get(i).show();
        friendly.get(i).explode();
        friendly.get(i).explodeSize+=3;
        friendly.get(i).explodeOp-=3;
        if (friendly.get(i).explodeOp<=0) {
          friendly.remove(i);
          fAX.remove(i);
          fAY.remove(i);
        }
      }
    }
    if ((int)health.currentHealth > 0) {
      control.control();
      ship.show();
      ship.move();
      fill(255, 0, 0, ((health.maxHealth-health.currentHealth)-(health.maxHealth/2))*2);
      rect(-100, -100, screenSize+100, screenSize+100);
    } else if ((int)health.currentHealth <= 0) {
      if (ship.dead == false) {
        ship.myColor = color(200, 0);
        for (int j = 0; j < 10; j++) {
          debris.add(new Debris(ship.getX(), ship.getY(), ship.getDirectionX(), ship.getDirectionY()));
        }
        ship.dead = true;
      }
      if (ship.dead == true) {
        health.currentHealth = 0;
        ship.move();
        ship.show();
        ship.explode();
        ship.explodeSize+=2;
        ship.explodeOp-=2;
        if (ship.explodeOp<=0) {
          for (int i = 0; i<robot.size (); i++) {
            robot.remove(i);
            rAX.remove(i);
            rAY.remove(i);
          }
          for (int i = 0; i<friendly.size (); i++) {
            friendly.remove(i);
            fAX.remove(i);
            fAY.remove(i);
          }
          noStroke();
          fill(0);
          rect(0, 0, width, height);
          gameStop = true;
          menu.men = 2;
        }
      }
    }
    if (robot.size() == 0 && coins.size() == 0) {
      for (int i = 0; i<friendly.size (); i++) {
        friendly.remove(i);
        fAX.remove(i);
        fAY.remove(i);
      }
      noStroke();
      fill(0);
      rect(0, 0, width, height);
      points+=10;
      currentLevel+=1;
      if (currentLevel>highestLevel) {
        highestLevel=currentLevel;
      }
      gameStop = true;
      menu.men = 3;
    }
    ///////////////////////////////////////
    fill(50, 90);
    noStroke();
    rect(screenSize, 0, width-height, screenSize);//sidebar
    hyperjump.show();
    hyperjump.interaction();
    speed.show();
    speed.interaction();
    health.show();
    health.interaction();
    fuel.show();
    fuel.interaction();
    bulletcool.show();
    bulletcool.interaction();
    map.show();
    help.show();
    help.interaction();
    //fill(255,0,0,-200);
  }
}

class Coins
{
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY;
  protected int size;
  protected color myColor;
  protected boolean reset = false;
  protected double textUp;
  protected double coinOp;
  protected double currentPoints;
  Coins(RobotSpaceShip x) {
    myCenterX = x.getX();
    myCenterY = x.getY();
    myDirectionX = (Math.random()*0.5)-0.25;
    myDirectionY = (Math.random()*0.5)-0.25;
    size = 10;
    myColor = color(255, 255, 0);
    textUp = 5;
    coinOp = 0;
  }
  public void show() {
    fill(0, 50);
    //ellipse((float)myCenterX, (float)myCenterY, size*1.5, size*1.5);
    fill(myColor, 800-(float)coinOp);
    ellipse((float)myCenterX, (float)myCenterY, size, size);
    myCenterX+=myDirectionX;
    myCenterY+=myDirectionY;
    if (dist((float)myCenterX, (float)myCenterY, ship.getX(), ship.getY()) < size*1000) {
      points+=1;
      currentPoints = points;
      reset = true;
    }
    if (myCenterX >height+screenSize)
    {   
      reset = true;
      myCenterX = -screenSize;
    } else if (myCenterX<-screenSize)
    {   
      reset = true;
      myCenterX = height+screenSize;
    }    
    if (myCenterY >height+screenSize)
    {    
      reset = true;
      myCenterY = -screenSize;
    } else if (myCenterY < -screenSize)
    {   
      reset = true;
      myCenterY = height+screenSize;
    }
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  }
}

class Debris extends Floater
{
  private double speedRotation, debrisOp;
  Debris(int x, int y, double a, double b) {
    corners = 3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = 0;
    yCorners[0] = 3;
    xCorners[1] = 6;
    yCorners[1] = -3;
    xCorners[2] = -6;
    yCorners[2] = -3;
    debrisOp = 200;
    myColor = color((int)(Math.random()*100)+100);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = ((Math.random()*8)-4)+a;
    myDirectionY = ((Math.random()*8)-4)+b;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*1)-.5;
  }
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor, (float)debrisOp);   
    stroke(myColor, (float)debrisOp);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI] * Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI] * Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }
  public void move() {
    myCenterX+=myDirectionX;
    myCenterY+=myDirectionY;
    myDirectionX=myDirectionX/gravity;
    myDirectionY=myDirectionY/gravity;
    myPointDirection +=speedRotation;
    if (myCenterX >height+screenSize)
    {   
      myCenterX = -screenSize;
    } else if (myCenterX<-screenSize)
    {   
      myCenterX = height+screenSize;
    }    
    if (myCenterY >height+screenSize)
    {    
      myCenterY = -screenSize;
    } else if (myCenterY < -screenSize)
    {   
      myCenterY = height+screenSize;
    }
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class SpaceShipControl
{
  double fX = ship.myCenterX;
  double fY = ship.myCenterY;
  float mX, mY;
  protected double radDir =-Math.PI/2;
  public void control() {
    noStroke();
    if (!hyperspace) {
      if (wPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed && currentFuel > 0) {
        double dRadians = (ship.myPointDirection)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadians);
        ellipse(-7, -3, 10, 2);
        ellipse(-7, 3, 10, 2);
        resetMatrix();
        ship.accelerate(maxTorque, 0);
      }
      if (sPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+30)*(Math.PI/180);
        double dRadiansL = (ship.myPointDirection-30)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(1, 4, 10, 2);
        resetMatrix();
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(1, -4, 10, 2);
        resetMatrix();
        ship.accelerate(-maxTorque, 0);
      }
      if (qPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(5, -9, 10, 2);
        resetMatrix();
        ship.accelerate(maxTorque/1.5, -90);
      }
      if (ePressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed && currentFuel > 0) {
        double dRadiansL = (ship.myPointDirection-90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(5, 9, 10, 2);
        resetMatrix();
        ship.accelerate(maxTorque/1.5, 90);
      }
      if (dPressed && !jPressed && currentFuel > 0) {
        double dRadiansL = (ship.myPointDirection-90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(3, 20, 8, 2);
        resetMatrix();
        ship.rotate(rotateSpeed);
      }
      if (aPressed && !jPressed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(3, -20, 8, 2);
        resetMatrix();
        ship.rotate(-rotateSpeed);
      }
      if (spacePressed && (int)shootCool == 0) {
        if (bulletCoolDown > 0) {
          shootCool = shootCoolTime;
          if (shootMode == 0) {
            bulletCoolDown-=0.6;
            bullet.add(new Bullet(ship));
            shootCool = shootCoolTime;
          }
          if (shootMode == 1) {
            bulletCoolDown-=0.65;
            bullet.add(new Bullet(ship));
            bullet.add(new Bullet(ship));
            bullet.add(new Bullet(ship));
            bullet.add(new Bullet(ship));
            bullet.add(new Bullet(ship));
            shootCool = shootCoolTime;
          }
          if (shootMode == 2) {
            bulletCoolDown-=3;
            bullet.add(new Bullet(ship));
            shootCool = shootCoolTime*5;
          }
        }
        if (bulletCoolDown<= 0) {
          bulletCoolDown = -2;
        }
      }
      if (bulletCoolDown<bulletCoolDownMax) {
        bulletCoolDown+=0.1;
      }
      if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
        currentFuel-=0.02;
      }
    }
    //NEW HYPERSPACE
    if (hyperspace) {
      if ((int)hyperjump.hyperCool == 0&&(abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY) <= 1)) {
        hyperspace = false;
      }
      if (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)< hyperSpeed/2) {
        ship.accelerate(hyperTorque, 0);
      }
      if (wPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < hyperSpeed && currentFuel > 0) {
        double dRadians = (ship.myPointDirection)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadians);
        ellipse(-7, -3, 10, 2);
        ellipse(-7, 3, 10, 2);
        resetMatrix();
        ship.accelerate(hyperTorque, 0);
      }
      if (sPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < hyperSpeed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+30)*(Math.PI/180);
        double dRadiansL = (ship.myPointDirection-30)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(1, 4, 10, 2);
        resetMatrix();
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(1, -4, 10, 2);
        resetMatrix();
        ship.accelerate(-hyperTorque, 0);
      }
      if (qPressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < hyperSpeed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(5, -9, 10, 2);
        resetMatrix();
        ship.accelerate(hyperTorque/1.5, -90);
      }
      if (ePressed && (abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < hyperSpeed && currentFuel > 0) {
        double dRadiansL = (ship.myPointDirection-90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(5, 9, 10, 2);
        resetMatrix();
        ship.accelerate(hyperTorque/1.5, 90);
      }
      if (dPressed && currentFuel > 0) {
        double dRadiansL = (ship.myPointDirection-90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansL);
        ellipse(3, 20, 8, 2);
        resetMatrix();
        ship.rotate(rotateSpeed);
      }
      if (aPressed && currentFuel > 0) {
        double dRadiansR = (ship.myPointDirection+90)*(Math.PI/180);
        fill(255, 0, 0);
        translate((float)ship.myCenterX, (float)ship.myCenterY);
        rotate((float)dRadiansR);
        ellipse(3, -20, 8, 2);
        resetMatrix();
        ship.rotate(-rotateSpeed);
      }
    }
    //OLD HYPERSPACE
    //if (jPressed) {
    //  ship.myDirectionX = 0;
    //  ship.myDirectionY = 0;
    //  double dRadians = (ship.myPointDirection)*(Math.PI/180);
    //  if (fX > 5 && fX < screenSize-5 && fY > 5 && fY < screenSize-5) {
    //    fX += ((maxTorque*100) * Math.cos(dRadians));    
    //    fY += ((maxTorque*100) * Math.sin(dRadians));
    //  }
    //  stroke(0, 0, 255);
    //  line((float)ship.getX(), (float)ship.getY(), (float)fX, (float)fY);
    //}
    //if (!jPressed) {
    //  fX = ship.myCenterX;
    //  fY = ship.myCenterY;
    //  //fX = iX;
    //  //fY = iY;
    //}

    noStroke();
    fill(0, 50);
    double dRadians = ship.myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < ship.corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((ship.xCorners[nI]*2 * Math.cos(dRadians)) - (ship.yCorners[nI]*2 * Math.sin(dRadians))+ship.myCenterX);     
      yRotatedTranslated = (int)((ship.xCorners[nI]*2 * Math.sin(dRadians)) + (ship.yCorners[nI]*2 * Math.cos(dRadians))+ship.myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }
}

class Bullet extends Floater
{
  protected double dRadians;
  protected float bulletSize = bulletS;
  protected float touched = 1;
  public Bullet(SpaceShip x) {
    myCenterX = x.getX();
    myCenterY = x.getY();

    if (shootMode == 0) {
      myPointDirection = x.getPointDirection()+((Math.random()*8)-4);
      dRadians =myPointDirection*(Math.PI/180);
      myDirectionX=bulletSpeed*Math.cos(dRadians) + x.getDirectionX() - ship.myDirectionX;
      myDirectionY=bulletSpeed*Math.sin(dRadians) + x.getDirectionY() - ship.myDirectionY;
    }
    if (shootMode == 1) {
      myPointDirection = x.getPointDirection()+((Math.random()*16)-8);
      dRadians =myPointDirection*(Math.PI/180);
      myDirectionX=bulletSpeed/1.5*Math.cos(dRadians) + x.getDirectionX() - ship.myDirectionX;
      myDirectionY=bulletSpeed/1.5*Math.sin(dRadians) + x.getDirectionY() - ship.myDirectionY;
    }
    if (shootMode == 2) {
      myPointDirection = x.getPointDirection()+((Math.random()*4)-2);
      dRadians =myPointDirection*(Math.PI/180);
      myDirectionX=bulletSpeed*1.5*Math.cos(dRadians) + x.getDirectionX() - ship.myDirectionX;
      myDirectionY=bulletSpeed*1.5*Math.sin(dRadians) + x.getDirectionY() - ship.myDirectionY;
    }

    myColor = color(255, 255, 0);
  }
  public void show()
  {
    noStroke();
    fill(myColor);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize, bulletSize);
    bulletSize+=bulletSpray;
    noStroke();
    fill(0, 0, 250, 50);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize*5, bulletSize*5);
  }
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
  }   
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class SpaceShip extends Floater  
{   
  protected double intX = screenSize;
  protected double intY = screenSize;
  protected int spaceShipSize = 1;
  protected boolean dead = false;
  protected double explodeSize, explodeOp;
  protected int expR, expG, expB;
  SpaceShip(int x, int y) {
    corners = 15;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -5*spaceShipSize;
    yCorners[0] = -6*spaceShipSize;
    xCorners[1] = -4*spaceShipSize;
    yCorners[1] = -10*spaceShipSize;
    xCorners[2] = -2*spaceShipSize;
    yCorners[2] = -1*spaceShipSize;
    xCorners[3] = 9*spaceShipSize;
    yCorners[3] = -1*spaceShipSize;
    xCorners[4] = 9*spaceShipSize;
    yCorners[4] = -4*spaceShipSize;
    xCorners[5] = 10*spaceShipSize;
    yCorners[5] = -4*spaceShipSize;
    xCorners[6] = 10*spaceShipSize;
    yCorners[6] = -1*spaceShipSize;
    //top
    xCorners[7] = 21*spaceShipSize;
    yCorners[7] = 0*spaceShipSize;
    //top
    xCorners[8] = 10*spaceShipSize;
    yCorners[8] = 1*spaceShipSize;
    xCorners[9] = 10*spaceShipSize;
    yCorners[9] = 4*spaceShipSize;
    xCorners[10] = 9*spaceShipSize;
    yCorners[10] = 4*spaceShipSize;
    xCorners[11] = 9*spaceShipSize;
    yCorners[11] = 1*spaceShipSize;
    xCorners[12] = -2*spaceShipSize;
    yCorners[12] = 1*spaceShipSize;
    xCorners[13] = -4*spaceShipSize;
    yCorners[13] = 10*spaceShipSize;
    xCorners[14] = -5*spaceShipSize;
    yCorners[14] = 6*spaceShipSize;
    myColor = color(150, 150, 250);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
    nDegreesOfRotation = 0;
    explodeSize = 10;
    explodeOp = 200;
    expR = (int)(Math.random()*50)+200;
    expG = (int)(Math.random()*100)+100;
    expB = (int)(Math.random()*50)+0;
  }
  public void explode() {
    noStroke();
    fill(expR, expG, expB, (float)explodeOp);
    ellipse((float)myCenterX, (float)myCenterY, (float)explodeSize, (float)explodeSize);
  }
  public void accelerate (double dAmount, double pAdd)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians = (myPointDirection+pAdd)*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }   
  public void rotate (int dAmount)   
  {     
    //rotates the floater by a given number of degrees  
    nDegreesOfRotation+=dAmount;
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY 
    myPointDirection+=nDegreesOfRotation; 
    myPointDirection = myPointDirection/(gravity*1.2);
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
    if (!hyperspace) {
      myDirectionX = myDirectionX/gravity;
      myDirectionY = myDirectionY/gravity;
    }
    if (hyperspace) {
      myDirectionX = myDirectionX/hypergravity;
      myDirectionY = myDirectionY/hypergravity;
    }
    posX = (float)((myCenterX-(screenSize/2))/screenSize);
    posY = (float)((myCenterY-(screenSize/2))/screenSize);
    //wrap around screen    
    if (myCenterX>screenSize && areaX<areaSize)
    {     
      areaX++;
      myCenterX = 0;
      fuelcan.isTouched = false;
      fuelcan.setX(fuelcan.getX()-screenSize);
      for (int i = 0; i<coins.size (); i++) {
        coins.get(i).setX(coins.get(i).getX()-screenSize);
      }
      for (int i = 0; i<debris.size (); i++) {
        debris.get(i).setX(debris.get(i).getX()-screenSize);
      }
      for (int i = 0; i<robot.size (); i++) {
        robot.get(i).reset();
        robot.get(i).setX(robot.get(i).getX()-(screenSize));
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.get(i).reset();
        friendly.get(i).setX(friendly.get(i).getX()-(screenSize));
      }
      spacestation.setX(spacestation.getX()-(screenSize));
      robotstation.setX(robotstation.getX()-(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }   
      for (int i = 0; i < asteroid.size (); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size (); i++) {
        bullet.get(i).setX(bullet.get(i).getX()-(screenSize));
      }
      for (int i = 0; i < robotbullet.size (); i++) {
        robotbullet.get(i).setX(robotbullet.get(i).getX()-(screenSize));
      }
      for (int i = 0; i < friendlybullet.size (); i++) {
        friendlybullet.get(i).setX(friendlybullet.get(i).getX()-(screenSize));
      }
    } else if (myCenterX<0 && areaX>0)
    {     
      areaX--;
      myCenterX = screenSize;
      fuelcan.isTouched = false;
      fuelcan.setX(fuelcan.getX()+screenSize);
      for (int i = 0; i<coins.size (); i++) {
        coins.get(i).setX(coins.get(i).getX()+screenSize);
      }
      for (int i = 0; i<debris.size (); i++) {
        debris.get(i).setX(debris.get(i).getX()+screenSize);
      }
      for (int i = 0; i<robot.size (); i++) {
        robot.get(i).reset();
        robot.get(i).setX(robot.get(i).getX()+(screenSize));
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.get(i).reset();
        friendly.get(i).setX(friendly.get(i).getX()+(screenSize));
      }
      spacestation.setX(spacestation.getX()+(screenSize));
      robotstation.setX(robotstation.getX()+(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }
      for (int i = 0; i < asteroid.size (); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size (); i++) {
        bullet.get(i).setX(bullet.get(i).getX()+(screenSize));
      }
      for (int i = 0; i < robotbullet.size (); i++) {
        robotbullet.get(i).setX(robotbullet.get(i).getX()+(screenSize));
      }
      for (int i = 0; i < friendlybullet.size (); i++) {
        friendlybullet.get(i).setX(friendlybullet.get(i).getX()+(screenSize));
      }
    }    
    if (myCenterY >screenSize && areaY<areaSize)
    {    
      areaY++;
      myCenterY = 0;
      fuelcan.isTouched = false;
      fuelcan.setY(fuelcan.getY()-screenSize);
      for (int i = 0; i<coins.size (); i++) {
        coins.get(i).setY(coins.get(i).getY()-screenSize);
      }
      for (int i = 0; i<debris.size (); i++) {
        debris.get(i).setY(debris.get(i).getY()-screenSize);
      }
      for (int i = 0; i<robot.size (); i++) {
        robot.get(i).reset();
        robot.get(i).setY(robot.get(i).getY()-(screenSize));
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.get(i).reset();
        friendly.get(i).setY(friendly.get(i).getY()-(screenSize));
      }
      spacestation.setY(spacestation.getY()-(screenSize));
      robotstation.setY(robotstation.getY()-(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      } 
      for (int i = 0; i < asteroid.size (); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size (); i++) {
        bullet.get(i).setY(bullet.get(i).getY()-(screenSize));
      }
      for (int i = 0; i < robotbullet.size (); i++) {
        robotbullet.get(i).setY(robotbullet.get(i).getY()-(screenSize));
      }
      for (int i = 0; i < friendlybullet.size (); i++) {
        friendlybullet.get(i).setY(friendlybullet.get(i).getY()-(screenSize));
      }
    } else if (myCenterY < 0 && areaY>0)
    {     
      areaY--;
      myCenterY = screenSize;
      fuelcan.isTouched = false;
      fuelcan.setY(fuelcan.getY()+screenSize);
      for (int i = 0; i<coins.size (); i++) {
        coins.get(i).setY(coins.get(i).getY()+screenSize);
      }
      for (int i = 0; i<debris.size (); i++) {
        debris.get(i).setY(debris.get(i).getY()+screenSize);
      }
      for (int i = 0; i<robot.size (); i++) {
        robot.get(i).reset();
        robot.get(i).setY(robot.get(i).getY()+(screenSize));
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.get(i).reset();
        friendly.get(i).setY(friendly.get(i).getY()+(screenSize));
      }
      spacestation.setY(spacestation.getY()+(screenSize));
      robotstation.setY(robotstation.getY()+(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }     
      for (int i = 0; i < asteroid.size (); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size (); i++) {
        bullet.get(i).setY(bullet.get(i).getY()+(screenSize));
      }
      for (int i = 0; i < robotbullet.size (); i++) {
        robotbullet.get(i).setY(robotbullet.get(i).getY()+(screenSize));
      }
      for (int i = 0; i < friendlybullet.size (); i++) {
        friendlybullet.get(i).setY(friendlybullet.get(i).getY()+(screenSize));
      }
    }
    if (areaX == areaSize) {
      if (ship.getX()>height) {
        health.currentHealth-=abs((float)ship.getDirectionX());
        ship.setDirectionX(-ship.getDirectionX());
      }
    }
    if (areaX == 0) {
      if (ship.getX()<0) {
        health.currentHealth-=abs((float)ship.getDirectionX());
        ship.setDirectionX(-ship.getDirectionX());
      }
    }
    if (areaY == areaSize) {
      if (ship.getY()>height) {
        health.currentHealth-=abs((float)ship.getDirectionY());
        ship.setDirectionY(-ship.getDirectionY());
      }
    }
    if (areaY == 0) {
      if (ship.getY()<0) {
        health.currentHealth-=abs((float)ship.getDirectionY());
        ship.setDirectionY(-ship.getDirectionY());
      }
    }
  }   
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class RobotBullet extends Floater
{
  protected double dRadians;
  protected float bulletSize = bulletS;
  public RobotBullet(int x, int y, int d, double dX, double dY) {
    myCenterX = x;
    myCenterY = y;
    myPointDirection = d+((Math.random()*6)-3);
    dRadians =myPointDirection*(Math.PI/180);
    myDirectionX=bulletSpeed*Math.cos(dRadians) + dX - ship.getDirectionX();
    myDirectionY=bulletSpeed*Math.sin(dRadians) + dY - ship.getDirectionY();
    myColor = color(255, 255, 0);
  }
  public void show()
  {
    noStroke();
    fill(myColor);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize, bulletSize);
    bulletSize+=bulletSpray;
    noStroke();
    fill(150, 0, 0, 50);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize*5, bulletSize*5);
  }
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
  }   
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class RobotSpaceShip extends Floater  
{   
  protected float currentHealth = 50+(currentLevel*2.5);
  protected float maxHealth = 50+(currentLevel*2.5);
  protected double intX = screenSize;
  protected double intY = screenSize;
  protected int spaceShipSize = 1;
  protected double radDir =-Math.PI/2;
  protected double radDir1 =-Math.PI/2;
  protected double radDir2 =-Math.PI/2;
  protected int sp;
  protected int spOffset;
  protected int rotOffset;
  protected int strOffset;
  protected boolean needHealth;
  protected float robotAreaX = 11;
  protected float robotAreaY = 11;
  protected boolean dead = false;
  protected int robotShootCool = 0;
  protected int robotShootCoolTime = 25;
  protected int target;
  protected boolean shipShot = false;
  protected double explodeSize, explodeOp;
  protected int expR, expG, expB;
  protected double missed, tSpeed, mTorque, grav;
  protected boolean hyper;
  RobotSpaceShip(int x, int y) {
    corners = 15;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -5*spaceShipSize;
    yCorners[0] = -6*spaceShipSize;
    xCorners[1] = -4*spaceShipSize;
    yCorners[1] = -10*spaceShipSize;
    xCorners[2] = -2*spaceShipSize;
    yCorners[2] = -1*spaceShipSize;
    xCorners[3] = 9*spaceShipSize;
    yCorners[3] = -1*spaceShipSize;
    xCorners[4] = 9*spaceShipSize;
    yCorners[4] = -4*spaceShipSize;
    xCorners[5] = 10*spaceShipSize;
    yCorners[5] = -4*spaceShipSize;
    xCorners[6] = 10*spaceShipSize;
    yCorners[6] = -1*spaceShipSize;
    //top
    xCorners[7] = 21*spaceShipSize;
    yCorners[7] = 0*spaceShipSize;
    //top
    xCorners[8] = 10*spaceShipSize;
    yCorners[8] = 1*spaceShipSize;
    xCorners[9] = 10*spaceShipSize;
    yCorners[9] = 4*spaceShipSize;
    xCorners[10] = 9*spaceShipSize;
    yCorners[10] = 4*spaceShipSize;
    xCorners[11] = 9*spaceShipSize;
    yCorners[11] = 1*spaceShipSize;
    xCorners[12] = -2*spaceShipSize;
    yCorners[12] = 1*spaceShipSize;
    xCorners[13] = -4*spaceShipSize;
    yCorners[13] = 10*spaceShipSize;
    xCorners[14] = -5*spaceShipSize;
    yCorners[14] = 6*spaceShipSize;
    myColor = color(250, 150, 150);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
    nDegreesOfRotation = 0;
    sp = (int)(Math.random()*200)+100;
    spOffset = (int)(sp/4);
    //rotOffset = (int)(sp/(Math.random()*10)+1);
    //strOffset = (int)(sp/(Math.random()*10)+1);
    rotOffset = (int)(((Math.random()*300)+300)/sp);
    strOffset = (int)(((Math.random()*300)+300)/sp);
    explodeSize = 10;
    explodeOp = 200;
    expR = (int)(Math.random()*50)+200;
    expG = (int)(Math.random()*100)+100;
    expB = (int)(Math.random()*50)+0;
    missed = 0;
    tSpeed = topSpeed;
    mTorque = maxTorque;
    grav = gravity;
    hyper = false;
  }
  public void explode() {
    noStroke();
    fill(expR, expG, expB, (float)explodeOp);
    ellipse((float)myCenterX, (float)myCenterY, (float)explodeSize, (float)explodeSize);
  }
  public void reset() {
    //currentHealth = maxHealth;
    //myCenterX = myCenterX+((areaX)*screenSize);
    //myCenterY = myCenterY+((areaY)*screenSize);
  }
  public void accelerate (double dAmount, double pAdd)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians = (myPointDirection+pAdd)*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }   
  public void rotate (int dAmount)   
  {     
    //rotates the floater by a given number of degrees  
    nDegreesOfRotation+=dAmount;
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    if (!hyper) {
      tSpeed = topSpeed;
      mTorque = maxTorque;
      grav = gravity;
    } else if (hyper) {
      tSpeed = hyperSpeed;
      mTorque = hyperTorque;
      grav = hypergravity;
    }
    //change the x and y coordinates by myDirectionX and myDirectionY 
    myPointDirection+=nDegreesOfRotation; 
    myPointDirection = myPointDirection/(grav*1.2);
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
    myDirectionX = myDirectionX/grav;
    myDirectionY = myDirectionY/grav; 
    robotAreaX = (float)((areaX)+((myCenterX-(screenSize/2))/screenSize));
    robotAreaY = (float)((areaY)+((myCenterY-(screenSize/2))/screenSize));
    if ((int)robotAreaX == areaSize) {
      if (getX()>height+(((int)robotAreaX-areaX)*height)) {
        currentHealth-=abs((float)getDirectionX());
        setDirectionX(-getDirectionX());
      }
    }
    if ((int)robotAreaX == 0) {
      if (getX()<0+(((int)robotAreaX-areaX)*height)) {
        currentHealth-=abs((float)getDirectionX());
        setDirectionX(-getDirectionX());
      }
    }
    if ((int)robotAreaY == areaSize) {
      if (getY()>height+(((int)robotAreaY-areaY)*height)) {
        currentHealth-=abs((float)getDirectionY());
        setDirectionY(-getDirectionY());
      }
    }
    if ((int)robotAreaY == 0) {
      if (getY()<0+(((int)robotAreaY-areaY)*height)) {
        currentHealth-=abs((float)getDirectionY());
        setDirectionY(-getDirectionY());
      }
    }
    noStroke();
    fill(0, 50);
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]*2 * Math.cos(dRadians)) - (yCorners[nI]*2 * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]*2 * Math.sin(dRadians)) + (yCorners[nI]*2 * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }   
  public void nextLevel() {
    noStroke();
    fill(0);
    rect(0, 0, width, height);
    points+=1;
    currentLevel+=1;
    gameStop = true;
    menu.men = 3;
  }
  public void reFuel() {
    hyper = false;
    noStroke();
    if (target>=friendly.size()) {
      target = (int)(Math.random()*friendly.size());
    }
    int z = target;
    //for (int i = 0; i < friendly.size()-1; i++) {
    //  if (dist((float)friendly.get(z).getX(), (float)friendly.get(z).getY(), (float)myCenterX, (float)myCenterY)>dist((float)friendly.get(i).getX(), (float)friendly.get(i).getY(), (float)myCenterX, (float)myCenterY)) {
    //    target = i;
    //    break;
    //  }
    //}
    if (needHealth&&friendly.size()>0) {
      //myColor = color(250, 150, 150);
      int space = (int)(sp/4);
      int spaceOffset = spOffset;
      int rotateOffset = rotOffset*2;
      int strafeOffset = strOffset*2;
      radDir1=Math.asin((friendly.get(z).getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, friendly.get(z).getX(), friendly.get(z).getY())))-Math.PI/2;
      radDir=Math.asin((robotstation.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, robotstation.getX(), robotstation.getY())))-Math.PI/2;
      radDir2=Math.asin((ship.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, ship.getX(), ship.getY())))-Math.PI/2;
      if (getY()-robotstation.getY()<0) {
        radDir*=-1;
      }
      if (getY()-friendly.get(z).getY()<0) {
        radDir1*=-1;
      }
      if (getY()-ship.getY()<0) {
        radDir2*=-1;
      }
      fill(255);
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(robotstation.getX(), robotstation.getY(), getX(), getY())>space+spaceOffset) { //w
        accelerate(mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(robotstation.getX(), robotstation.getY(), getX(), getY())>space+spaceOffset) { //s

        accelerate(-mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

        accelerate(mTorque/1.5, -90);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

        accelerate(mTorque/1.5, 90);
      }
      if (target<friendly.size()) {
        if (dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY())>height/1.5) {
          if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
        }
        if (dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY())<height/1.5) {
          if ((myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir1*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
          if ((int)robotShootCool==0&&myPointDirection-(radDir1*180/(Math.PI))<rotateOffset/1.5) {
            robotbullet.add(new RobotBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
            robotShootCool = robotShootCoolTime;
          }
        }
      }
      if (target>=friendly.size()) {
        if (dist(ship.getX(), ship.getY(), getX(), getY())>height/1.5) {
          if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
        }
        if (dist(ship.getX(), ship.getY(), getX(), getY())<height/1.5) {
          if ((myPointDirection-(radDir2*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir2*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
          if ((int)robotShootCool==0&&myPointDirection-(radDir2*180/(Math.PI))<rotateOffset/1.5) {
            robotbullet.add(new RobotBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
            robotShootCool = robotShootCoolTime;
          }
        }
      }
      //shoot
      //if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
      //  currentFuel-=0.01;
      //}
      int rectSizeX = 50;
      float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
      if (currentHealth < maxHealth) {
        //rectangle
        fill(0);
        stroke(150);
        strokeWeight(1);
        rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
        strokeWeight(0.5);
        //bar
        fill(255, 0, 0);
        noStroke();
        rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
      }
      if (currentHealth>maxHealth/1.5) {
        needHealth = false;
      }
    }
    if (needHealth&&friendly.size()==0) {
      //myColor = color(250, 150, 150);
      int space = (int)(sp/4);
      int spaceOffset = spOffset;
      int rotateOffset = rotOffset*2;
      int strafeOffset = strOffset*2;
      radDir=Math.asin((robotstation.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, robotstation.getX(), robotstation.getY())))-Math.PI/2;
      radDir2=Math.asin((ship.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, ship.getX(), ship.getY())))-Math.PI/2;
      if (getY()-robotstation.getY()<0) {
        radDir*=-1;
      }
      if (getY()-ship.getY()<0) {
        radDir2*=-1;
      }
      if (getY()-robot.get(z).getY()<0) {
        radDir1*=-1;
      }
      fill(255);
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(robotstation.getX(), robotstation.getY(), getX(), getY())>space+spaceOffset) { //w
        accelerate(mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(robotstation.getX(), robotstation.getY(), getX(), getY())>space+spaceOffset) { //s

        accelerate(-mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

        accelerate(mTorque/1.5, -90);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

        accelerate(mTorque/1.55, 90);
      }

      if (dist(ship.getX(), ship.getY(), getX(), getY())>height/1.5) {
        if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      }
      if (dist(ship.getX(), ship.getY(), getX(), getY())<height/1.5) {
        if ((myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir1*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      }

      if ((int)robotShootCool==0&&myPointDirection-(radDir2*180/(Math.PI))<rotateOffset/1.5) {
        robotbullet.add(new RobotBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
        robotShootCool = robotShootCoolTime;
      }//shoot
      //if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
      //  currentFuel-=0.01;
      //}
      int rectSizeX = 50;
      float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
      if (currentHealth < maxHealth) {
        //rectangle
        fill(0);
        stroke(150);
        strokeWeight(1);
        rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
        strokeWeight(0.5);
        //bar
        fill(255, 0, 0);
        noStroke();
        rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
      }
      if (currentHealth>maxHealth/1.5) {
        needHealth = false;
      }
    }
  }

  public void control() {
    if (!needHealth) {
      int z = target;
      if (target>=friendly.size()) {
        target = (int)(Math.random()*friendly.size());
        //for (int i = 0; i < friendly.size ()-1; i++) {
        //  if (dist((float)friendly.get(z).getX(), (float)friendly.get(z).getY(), (float)myCenterX, (float)myCenterY)>dist((float)friendly.get(i).getX(), (float)friendly.get(i).getY(), (float)myCenterX, (float)myCenterY)) {
        //    target = i;
        //    break;
        //  }
        //}
      }
      if (friendly.size()>0&&target<=friendly.size()) {
        if (missed > 0) {
          if (missed > maxMissed) {
            target = (int)(Math.random()*friendly.size());
            missed -= maxMissed;
          }
          missed-=0.01;
        }
        z = target;
        int space = sp;
        int spaceOffset = spOffset;
        int rotateOffset = rotOffset;
        int strafeOffset = strOffset;
        if (dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY()) > (space*8)+spaceOffset) {
          hyper = true;
        }
        if (dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY()) < (space*8)-spaceOffset) {
          if (hyper) {
            myDirectionX = 0;
            myDirectionY = 0;
          }
          hyper = false;
        }
        radDir=Math.asin((friendly.get(z).getX()-getX())/(dist((float)getX(), (float)getY(), friendly.get(z).getX(), friendly.get(z).getY())))-Math.PI/2;
        if (getY()-friendly.get(z).getY()<0) {
          radDir*=-1;
        }
        //myPointDirection=radDir*180/(Math.PI);
        fill(255);
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY())>space+spaceOffset) { //w
          accelerate(mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(friendly.get(z).getX(), friendly.get(z).getY(), getX(), getY())<space-spaceOffset) { //s

          accelerate(-mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

          accelerate(mTorque/1.5, -90);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

          accelerate(mTorque/1.5, 90);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }

        if ((int)robotShootCool==0&&myPointDirection-(radDir*180/(Math.PI))<rotateOffset/1.5) {
          robotbullet.add(new RobotBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
          robotShootCool = robotShootCoolTime;
        }//shoot
        int rectSizeX = 50;
        float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
        if (currentHealth < maxHealth) {
          //rectangle
          fill(0);
          stroke(150);
          strokeWeight(1);
          rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
          strokeWeight(0.5);
          //bar
          fill(255, 0, 0);
          noStroke();
          rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
        }
        if (currentHealth<maxHealth/3) {
          needHealth = true;
        }
      }
      if (friendly.size()==0||(friendly.size()>0&&target>=friendly.size()+1)) {
        //myColor = color(150, 250, 150);
        int space = sp;
        int spaceOffset = spOffset;
        int rotateOffset = rotOffset;
        int strafeOffset = strOffset;
        if (dist(ship.getX(), ship.getY(), getX(), getY()) > (space*8)+spaceOffset) {
          hyper = true;
        }
        if (dist(ship.getX(), ship.getY(), getX(), getY()) < (space*8)-spaceOffset) {
          if (hyper) {
            myDirectionX = 0;
            myDirectionY = 0;
          }
          hyper = false;
        }
        radDir=Math.asin((ship.getX()-getX())/(dist((float)getX(), (float)getY(), ship.getX(), ship.getY())))-Math.PI/2;
        if (getY()-ship.getY()<0) {
          radDir*=-1;
        }
        //myPointDirection=radDir*180/(Math.PI);
        fill(255);
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), getX(), getY())>space+spaceOffset) { //w
          accelerate(mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(ship.getX(), ship.getY(), getX(), getY())<space-spaceOffset) { //s

          accelerate(-mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

          accelerate(mTorque/1.5, -90);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

          accelerate(mTorque/1.5, 90);
        }
        if (myPointDirection-(radDir*180/(Math.PI))<-rotateOffset) { //d

          rotate(rotateSpeed);
        }
        if (myPointDirection-(radDir*180/(Math.PI))>rotateOffset) { //a

          rotate(-rotateSpeed);
        }
        if ((int)robotShootCool==0&&myPointDirection-(radDir*180/(Math.PI))<rotateOffset/1.5) {
          robotbullet.add(new RobotBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
          robotShootCool = robotShootCoolTime;
        }//shoot
        int rectSizeX = 50;
        float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
        if (currentHealth < maxHealth) {
          //rectangle
          fill(0);
          stroke(150);
          strokeWeight(1);
          rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
          strokeWeight(0.5);
          //bar
          fill(255, 0, 0);
          noStroke();
          rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
        }
        if (currentHealth<maxHealth/3) {
          needHealth = true;
        }
      }
    }
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
  public void setAreaX(float x) {
    robotAreaX = x;
  }
  public float getAreaX() {
    return robotAreaX;
  }
  public void setAreaY(float y) {
    robotAreaY = y;
  }
  public float getAreaY() {
    return robotAreaY;
  }
}


class FriendlyBullet extends Floater
{
  protected double dRadians;
  protected float bulletSize = bulletS;
  public FriendlyBullet(int x, int y, int d, double dX, double dY) {
    myCenterX = x;
    myCenterY = y;
    myPointDirection = d+((Math.random()*6)-3);
    dRadians =myPointDirection*(Math.PI/180);
    myDirectionX=bulletSpeed*Math.cos(dRadians) + dX - ship.getDirectionX();
    myDirectionY=bulletSpeed*Math.sin(dRadians) + dY - ship.getDirectionY();
    myColor = color(255, 255, 0);
  }
  public void show()
  {
    noStroke();
    fill(myColor);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize, bulletSize);
    bulletSize+=bulletSpray;
    noStroke();
    fill(0, 250, 0, 50);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize*5, bulletSize*5);
  }
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
  }   
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class FriendlySpaceShip extends Floater  
{   
  // float currentHealth = 50+(currentLevel*2.5);
  //protected float maxHealth = 50+(currentLevel*2.5);
  protected float currentHealth = health.maxHealth/2;
  protected float maxHealth = health.maxHealth/2;
  protected double intX = screenSize;
  protected double intY = screenSize;
  protected int spaceShipSize = 1;
  protected double radDir =-Math.PI/2;
  protected double radDir1 =-Math.PI/2;
  protected double radDir2 =-Math.PI/2;
  protected int sp;
  protected int spOffset;
  protected int rotOffset;
  protected int strOffset;
  protected boolean needHealth;
  protected float friendlyAreaX = 11;
  protected float friendlyAreaY = 11;
  protected boolean dead = false;
  protected int friendlyShootCool = 0;
  protected int friendlyShootCoolTime = 25;
  protected int target;
  protected double explodeSize, explodeOp;
  protected int expR, expG, expB;
  protected double missed, tSpeed, mTorque, grav;
  protected boolean hyper;
  FriendlySpaceShip(int x, int y) {
    corners = 15;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -5*spaceShipSize;
    yCorners[0] = -6*spaceShipSize;
    xCorners[1] = -4*spaceShipSize;
    yCorners[1] = -10*spaceShipSize;
    xCorners[2] = -2*spaceShipSize;
    yCorners[2] = -1*spaceShipSize;
    xCorners[3] = 9*spaceShipSize;
    yCorners[3] = -1*spaceShipSize;
    xCorners[4] = 9*spaceShipSize;
    yCorners[4] = -4*spaceShipSize;
    xCorners[5] = 10*spaceShipSize;
    yCorners[5] = -4*spaceShipSize;
    xCorners[6] = 10*spaceShipSize;
    yCorners[6] = -1*spaceShipSize;
    //top
    xCorners[7] = 21*spaceShipSize;
    yCorners[7] = 0*spaceShipSize;
    //top
    xCorners[8] = 10*spaceShipSize;
    yCorners[8] = 1*spaceShipSize;
    xCorners[9] = 10*spaceShipSize;
    yCorners[9] = 4*spaceShipSize;
    xCorners[10] = 9*spaceShipSize;
    yCorners[10] = 4*spaceShipSize;
    xCorners[11] = 9*spaceShipSize;
    yCorners[11] = 1*spaceShipSize;
    xCorners[12] = -2*spaceShipSize;
    yCorners[12] = 1*spaceShipSize;
    xCorners[13] = -4*spaceShipSize;
    yCorners[13] = 10*spaceShipSize;
    xCorners[14] = -5*spaceShipSize;
    yCorners[14] = 6*spaceShipSize;
    myColor = color(150, 250, 150);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
    nDegreesOfRotation = 0;
    sp = (int)(Math.random()*200)+100;
    spOffset = (int)(sp/4);
    //rotOffset = (int)(sp/(Math.random()*10)+1);
    //strOffset = (int)(sp/(Math.random()*10)+1);
    rotOffset = (int)(((Math.random()*300)+300)/sp);
    strOffset = (int)(((Math.random()*300)+300)/sp);
    explodeSize = 10;
    explodeOp = 200;
    expR = (int)(Math.random()*50)+200;
    expG = (int)(Math.random()*100)+100;
    expB = (int)(Math.random()*50)+0;
    missed = 0;
    tSpeed = topSpeed;
    mTorque = maxTorque;
    grav = gravity;
    hyper = false;
  }
  public void explode() {
    noStroke();
    fill(expR, expG, expB, (float)explodeOp);
    ellipse((float)myCenterX, (float)myCenterY, (float)explodeSize, (float)explodeSize);
  }
  public void reset() {
    //currentHealth = maxHealth;
    //myCenterX = myCenterX+((areaX)*screenSize);
    //myCenterY = myCenterY+((areaY)*screenSize);
  }
  public void accelerate (double dAmount, double pAdd)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians = (myPointDirection+pAdd)*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }   
  public void rotate (int dAmount)   
  {     
    //rotates the floater by a given number of degrees  
    nDegreesOfRotation+=dAmount;
  }   
  public void move ()   //move the floater in the current direction of travel
  {  
    if (!hyper) {
      tSpeed = topSpeed;
      mTorque = maxTorque;
      grav = gravity;
    } else if (hyper) {
      tSpeed = hyperSpeed;
      mTorque = hyperTorque;
      grav = hypergravity;
    }
    //change the x and y coordinates by myDirectionX and myDirectionY 
    myPointDirection+=nDegreesOfRotation; 
    myPointDirection = myPointDirection/(grav*1.2);
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
    myDirectionX = myDirectionX/grav;
    myDirectionY = myDirectionY/grav; 
    friendlyAreaX = (float)((areaX)+((myCenterX-(screenSize/2))/screenSize));
    friendlyAreaY = (float)((areaY)+((myCenterY-(screenSize/2))/screenSize));
    if ((int)friendlyAreaX == areaSize) {
      if (getX()>height+(((int)friendlyAreaX-areaX)*height)) {
        currentHealth-=abs((float)getDirectionX());
        setDirectionX(-getDirectionX());
      }
    }
    if ((int)friendlyAreaX == 0) {
      if (getX()<0+(((int)friendlyAreaX-areaX)*height)) {
        currentHealth-=abs((float)getDirectionX());
        setDirectionX(-getDirectionX());
      }
    }
    if ((int)friendlyAreaY == areaSize) {
      if (getY()>height+(((int)friendlyAreaY-areaY)*height)) {
        currentHealth-=abs((float)getDirectionY());
        setDirectionY(-getDirectionY());
      }
    }
    if ((int)friendlyAreaY == 0) {
      if (getY()<0+(((int)friendlyAreaY-areaY)*height)) {
        currentHealth-=abs((float)getDirectionY());
        setDirectionY(-getDirectionY());
      }
    }
    noStroke();
    fill(0, 50);
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]*2 * Math.cos(dRadians)) - (yCorners[nI]*2 * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]*2 * Math.sin(dRadians)) + (yCorners[nI]*2 * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }   
  public void reFuel() {
    hyper = false;
    noStroke();
    if (needHealth&&robot.size()>0) {
      if (target>=robot.size()) {
        target = (int)(Math.random()*robot.size());
      }
      int z = target;
      for (int i = 0; i < robot.size ()-1; i++) {
        if (dist((float)robot.get(z).getX(), (float)robot.get(z).getY(), (float)myCenterX, (float)myCenterY)>dist((float)robot.get(i).getX(), (float)robot.get(i).getY(), (float)myCenterX, (float)myCenterY)) {
          target = i;
          break;
        }
      }
      //myColor = color(250, 150, 150);
      int space = (int)(sp/4);
      int spaceOffset = spOffset;
      int rotateOffset = rotOffset*2;
      int strafeOffset = strOffset*2;
      radDir1=Math.asin((robot.get(z).getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, robot.get(z).getX(), robot.get(z).getY())))-Math.PI/2;
      radDir=Math.asin((ship.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, ship.getX(), ship.getY())))-Math.PI/2;
      radDir2=Math.asin((spacestation.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, spacestation.getX(), spacestation.getY())))-Math.PI/2;
      if (getY()-robot.get(z).getY()<0) {
        radDir1*=-1;
      }
      if (getY()-ship.getY()<0) {
        radDir*=-1;
      }
      if (getY()-spacestation.getY()<0) {
        radDir2*=-1;
      }
      fill(255);
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir2*180/(Math.PI))))<90&&dist(spacestation.getX(), spacestation.getY(), getX(), getY())>space+spaceOffset) { //w
        accelerate(mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir2*180/(Math.PI))))<90)==false&&dist(spacestation.getX(), spacestation.getY(), getX(), getY())>space+spaceOffset) { //s

        accelerate(-mTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir2*180/(Math.PI))>strafeOffset) { //q

        accelerate(mTorque/1.5, -90);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir2*180/(Math.PI))<-strafeOffset) { //e

        accelerate(mTorque/1.5, 90);
      }
      if (dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY())<height/1.5) {
        if ((myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir1*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      } else if (dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY())>height/1.5) {
        if ((myPointDirection-(radDir2*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir2*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      }
      if ((int)friendlyShootCool==0&&myPointDirection-(radDir1*180/(Math.PI))<rotateOffset/1.5) {
        friendlybullet.add(new FriendlyBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
        friendlyShootCool = friendlyShootCoolTime;
      }//shoot
      //if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
      //  currentFuel-=0.01;
      //}
      int rectSizeX = 50;
      float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
      if (currentHealth < maxHealth) {
        //rectangle
        fill(0);
        stroke(150);
        strokeWeight(1);
        rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
        strokeWeight(0.5);
        //bar
        fill(255, 0, 0);
        noStroke();
        rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
      }
      if (currentHealth>maxHealth/1.5) {
        needHealth = false;
      }
    }
  }

  public void control() {
    if (!needHealth&&robot.size()>0) {
      int z = target;
      if (missed > 0) {
        if (missed > maxMissed) {
          if (!defend) {
            target = (int)(Math.random()*robot.size());
          }
          if (defend) {
            for (int i = 0; i < robot.size ()-1; i++) {
              if (dist((float)robot.get(z).getX(), (float)robot.get(z).getY(), (float)myCenterX, (float)myCenterY)>dist((float)robot.get(i).getX(), (float)robot.get(i).getY(), (float)myCenterX, (float)myCenterY)) {
                target = i;
                break;
              }
            }
          }
          missed -= maxMissed;
        }
        missed-=0.01;
      }
      if (target>=robot.size()) {
        target = (int)(Math.random()*robot.size());
      }
      z = target;
      if (defend) {
        //myColor = color(150, 250, 150);
        int space = sp;
        int spaceOffset = spOffset;
        int rotateOffset = rotOffset;
        int strafeOffset = strOffset;
        if (dist(ship.getX(), ship.getY(), getX(), getY()) > (space*8)+spaceOffset) {
          hyper = true;
        }
        if (dist(ship.getX(), ship.getY(), getX(), getY()) < (space*8)-spaceOffset) {
          if (hyper) {
            myDirectionX = 0;
            myDirectionY = 0;
          }
          hyper = false;
        }
        radDir1=Math.asin((robot.get(z).getX()-getX())/(dist((float)getX(), (float)getY(), robot.get(z).getX(), robot.get(z).getY())))-Math.PI/2;
        radDir=Math.asin((ship.getX()-getX())/(dist((float)getX(), (float)getY(), ship.getX(), ship.getY())))-Math.PI/2;
        if (getY()-robot.get(z).getY()<0) {
          radDir1*=-1;
        }
        if (getY()-ship.getY()<0) {
          radDir*=-1;
        }
        //myPointDirection=radDir*180/(Math.PI);
        fill(255);
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), getX(), getY())>space+spaceOffset) { //w
          accelerate(mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(ship.getX(), ship.getY(), getX(), getY())<space-spaceOffset) { //s

          accelerate(-mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

          accelerate(mTorque/1.5, -90);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

          accelerate(mTorque/1.5, 90);
        }
        if (dist(ship.getX(), ship.getY(), getX(), getY())>height/1.5) {
          if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
        } 
        if (dist(ship.getX(), ship.getY(), getX(), getY())<height/1.5) {
          if ((myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset)) { //d

            rotate(rotateSpeed);
          }
          if ((myPointDirection-(radDir1*180/(Math.PI))>rotateOffset)) { //a

            rotate(-rotateSpeed);
          }
          if ((int)friendlyShootCool==0&&myPointDirection-(radDir1*180/(Math.PI))<rotateOffset/1.5) {
            friendlybullet.add(new FriendlyBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
            friendlyShootCool = friendlyShootCoolTime;
          }
        }
        //shoot
        //if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
        //  currentFuel-=0.01;
        //}
        int rectSizeX = 50;
        float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
        if (currentHealth < maxHealth) {
          //rectangle
          fill(0);
          stroke(150);
          strokeWeight(1);
          rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
          strokeWeight(0.5);
          //bar
          fill(255, 0, 0);
          noStroke();
          rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
        }
        if (currentHealth<maxHealth/3) {
          needHealth = true;
        }
      } else if (!defend) {
        //myColor = color(150, 250, 150);
        int space = sp;
        int spaceOffset = spOffset;
        int rotateOffset = rotOffset;
        int strafeOffset = strOffset;
        if (dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY()) > (space*8)+spaceOffset) {
          hyper = true;
        }
        if (dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY()) < (space*8)+spaceOffset) {
          if (hyper) {
            myDirectionX = 0;
            myDirectionY = 0;
          }
          hyper = false;
        }
        radDir=Math.asin((robot.get(z).getX()-getX())/(dist((float)getX(), (float)getY(), robot.get(z).getX(), robot.get(z).getY())))-Math.PI/2;
        if (getY()-robot.get(z).getY()<0) {
          radDir*=-1;
        }
        //myPointDirection=radDir*180/(Math.PI);
        fill(255);
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY())>space+spaceOffset) { //w
          accelerate(mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&(abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90)==false&&dist(robot.get(z).getX(), robot.get(z).getY(), getX(), getY())<space-spaceOffset) { //s

          accelerate(-mTorque, 0);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

          accelerate(mTorque/1.5, -90);
        }
        if ((abs((float)myDirectionX)+abs((float)myDirectionY))<tSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

          accelerate(mTorque/1.5, 90);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }

        if ((int)friendlyShootCool==0&&myPointDirection-(radDir*180/(Math.PI))<rotateOffset/1.5) {
          friendlybullet.add(new FriendlyBullet((int)myCenterX, (int)myCenterY, (int)myPointDirection, myDirectionX, myDirectionY));
          friendlyShootCool = friendlyShootCoolTime;
        }//shoot
        int rectSizeX = 50;
        float barSize = (float)(currentHealth/maxHealth)*rectSizeX;
        if (currentHealth < maxHealth) {
          //rectangle
          fill(0);
          stroke(150);
          strokeWeight(1);
          rect((float)getX()-rectSizeX/2, getY()+10, rectSizeX+1, 6);
          strokeWeight(0.5);
          //bar
          fill(255, 0, 0);
          noStroke();
          rect((float)getX()+1-rectSizeX/2, getY()+11, barSize, 5);
        }
        if (currentHealth<maxHealth/3) {
          needHealth = true;
        }
      }
    }
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
  public void setAreaX(float x) {
    friendlyAreaX = x;
  }
  public float getAreaX() {
    return friendlyAreaX;
  }
  public void setAreaY(float y) {
    friendlyAreaY = y;
  }
  public float getAreaY() {
    return friendlyAreaY;
  }
}

class SpaceStation extends Floater
{
  protected double speedRotation; 
  protected int stationSize = 5;
  SpaceStation(int x, int y) {
    corners = 4;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -50*stationSize;
    yCorners[0] = -50*stationSize;
    xCorners[1] = 50*stationSize;
    yCorners[1] = -50*stationSize;
    xCorners[2] = 50*stationSize;
    yCorners[2] = 50*stationSize;
    xCorners[3] = -50*stationSize;
    yCorners[3] = 50*stationSize;
    myColor = color(150);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
    speedRotation = 0.1;
  }
  public void show ()  //Draws the floater at the current position  
  {                
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;   
    noStroke();
    fill(0, 50);   
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.cos(dRadians)) - (yCorners[nI]*1.1 * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.sin(dRadians)) + (yCorners[nI]*1.1 * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
    fill(myColor);   
    stroke(myColor); 
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI] * Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI] * Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
    //double dRadians = (myPointDirection)*(Math.PI/180);
    fill(50);
    noStroke();
    translate((float)myCenterX, (float)myCenterY);
    //rect(-50*stationSize-1, -25*stationSize, 100*stationSize+2, 50*stationSize);
    //rect(-25*stationSize, -50*stationSize-1, 50*stationSize, 100*stationSize+2);
    fill(150+addHealth, 150-addHealth/2, 150-addHealth/2);
    ellipse(0, 0, 100*stationSize, 100*stationSize);
    resetMatrix();
    myPointDirection+=speedRotation;
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class FuelCan extends Floater
{
  protected double speedRotation;
  protected boolean isTouched = false;
  FuelCan() {
    corners = 4;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -20;
    yCorners[0] = -20;
    xCorners[1] = 20;
    yCorners[1] = -20;
    xCorners[2] = 20;
    yCorners[2] = 20;
    xCorners[3] = -20;
    yCorners[3] = 20;
    myColor = color(150, 250, 150);
    myCenterX = (Math.random()*screenSize*2)-screenSize/2;
    myCenterY = (Math.random()*screenSize*2)-screenSize/2;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*1)-.5;
  }
  public void reset() {
    isTouched = false;
    myCenterX = (Math.random()*screenSize*2)-screenSize/2;
    myCenterY = (Math.random()*screenSize*2)-screenSize/2;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*1)-.5;
  }
  public void move() {
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     
    myPointDirection +=speedRotation;
    //wrap around screen    
    if (myCenterX >height+screenSize)
    {   
      reset();
      myCenterX = -screenSize;
    } else if (myCenterX<-screenSize)
    {   
      reset();
      myCenterX = height+screenSize;
    }    
    if (myCenterY >height+screenSize)
    {    
      reset();
      myCenterY = -screenSize;
    } else if (myCenterY < -screenSize)
    {   
      reset();
      myCenterY = height+screenSize;
    }
    noStroke();
    fill(0, 50);
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.cos(dRadians)) - (yCorners[nI]*1.1 * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.sin(dRadians)) + (yCorners[nI]*1.1 * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
}

class Asteroid extends Floater
{
  protected double speedRotation; 
  protected int asteroidSize = (int)(Math.random()*100)+50;
  Asteroid() {
    corners = 8;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -5-asteroidSize;
    yCorners[0] = -10-asteroidSize*2;
    xCorners[1] = 5+asteroidSize;
    yCorners[1] = -10-asteroidSize*2;
    xCorners[2] = 10+asteroidSize*2;
    yCorners[2] = -5-asteroidSize;
    xCorners[3] = 10+asteroidSize*2;
    yCorners[3] = 5+asteroidSize;
    xCorners[4] = 5+asteroidSize;
    yCorners[4] = 10+asteroidSize*2;
    xCorners[5] = -5-asteroidSize;
    yCorners[5] = 10+asteroidSize*2;
    xCorners[6] = -10-asteroidSize*2;
    yCorners[6] = 5+asteroidSize;
    xCorners[7] = -10-asteroidSize*2;
    yCorners[7] = -5-asteroidSize;
    myColor = color((int)(Math.random()*10)+145, (int)(Math.random()*10)+145, (int)(Math.random()*10)+145);
    myCenterX = (Math.random()*screenSize*2)-screenSize/2;
    myCenterY = (Math.random()*screenSize*2)-screenSize/2;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*1)-.5;
  }
  public void reset() {
    int asteroidSize = (int)(Math.random()*5)+2;
    myColor = color((int)(Math.random()*10)+145, (int)(Math.random()*10)+145, (int)(Math.random()*10)+145);
    myCenterX = (Math.random()*screenSize*2)-screenSize/2;
    myCenterY = (Math.random()*screenSize*2)-screenSize/2;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*1)-.5;
  }
  public void move() {
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     
    myPointDirection +=speedRotation;
    //wrap around screen    
    if (myCenterX >width+screenSize)
    {   
      reset();
      myCenterX = -screenSize;
    } else if (myCenterX<-screenSize)
    {   
      reset();
      myCenterX = width+screenSize;
    }    
    if (myCenterY >height+screenSize)
    {    
      reset();
      myCenterY = -screenSize;
    } else if (myCenterY < -screenSize)
    {   
      reset();
      myCenterY = height+screenSize;
    }
    noStroke();
    fill(0, 50);
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.cos(dRadians)) - (yCorners[nI]*1.1 * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]*1.1 * Math.sin(dRadians)) + (yCorners[nI]*1.1 * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }   
  public void setY(int y) {
    myCenterY = y;
  }   
  public int getY() {
    return (int)myCenterY;
  }
  public void setDirectionX(double x) {
    myDirectionX = x;
  }  
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }  
  public double getDirectionY() {
    return myDirectionY;
  } 
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  }
  public void setAsteroidSize(int size) {
    asteroidSize = size;
  }
  public double getAsteroidSize() {
    return asteroidSize;
  }
}

abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  protected int nDegreesOfRotation; 
  abstract public void setX(int x);
  abstract public int getX();
  abstract public void setY(int y);   
  abstract public int getY();
  abstract public void setDirectionX(double x);
  abstract public double getDirectionX();
  abstract public void setDirectionY(double y);
  abstract public double getDirectionY();
  abstract public void setPointDirection(int degrees);
  abstract public double getPointDirection();

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }   
  public void rotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if (myCenterX >width)
    {     
      myCenterX = 0;
    } else if (myCenterX<0)
    {     
      myCenterX = width;
    }    
    if (myCenterY >height)
    {    
      myCenterY = 0;
    } else if (myCenterY < 0)
    {     
      myCenterY = height;
    }
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI] * Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI] * Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
  }
}

class Star 
{
  private int starX, starY, starColor;
  private double starSize;
  public Star() {
    starX = (int)(Math.random()*screenSize);
    starY = (int)(Math.random()*screenSize);
    starColor = (int)(Math.random()*50)+200;
    starSize = Math.random()*5;
  }
  public void show() {
    fill(starColor);
    noStroke();
    ellipse(starX, starY, (float)starSize, (float)starSize);
    starColor = (int)(Math.random()*50)+200;
    starSize = Math.random()*5;
  }
}

class HyperJump extends Gui
{
  protected float hyperCool = 0;
  protected float hyperCoolAdd = 5;
  public HyperJump() {
    rectY = 320;
    barSize = 0;
    barColor = color(0, 0, 255);
    titleName = "Hyperspeed";
    titleY = 310;
  }
  public void interaction() {
    if (!hyperspace) {
      titleName = "Hyperspeed: Off";
    }
    if (hyperspace) {
      titleName = "Hyperspeed: On";
    }
    //NEW HYPERJUMP
    if (hyperspace) {
      if (((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < hyperSpeed*0.7)) {
        barSize = (((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))-topSpeed)/(hyperSpeed*0.7))*rectSizeX;
      }
      if (((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) > hyperSpeed*0.7)) {
        barSize = rectSizeX;
      }
    }
    if (!hyperspace||((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed)) {
      barSize = 0;
    }
    if (hyperCool > 0) {
      hyperCool -= 0.5;
    }
    //OLD HYPERJUMP
    //if (hyperCool > 0) {
    //  hyperCool -= 0.5;
    //  barSize = (hyperCool/hyperCoolAdd)*rectSizeX;
    //}
  }
}

class Speed extends Gui
{
  public Speed() {
    rectY = 280;
    barSize = 0;
    barColor = color(0, 255, 0);
    titleName = "Speed";
    titleY = 270;
  }
  public void interaction() {
    if ((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) < topSpeed) {
      barSize = ((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))/topSpeed)*rectSizeX;
    }
    if ((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY)) > topSpeed) {
      barSize = rectSizeX;
    }
  }
}

class Health extends Gui
{
  protected float currentHealth = 100;
  protected float maxHealth = 100;
  public Health() {
    rectY = 240;
    barSize = (currentHealth/100)*rectSizeX;
    barColor = color(255, 0, 0);
    titleName = "Health";
    titleY = 230;
  }
  public void interaction() {
    barSize = (currentHealth/maxHealth)*rectSizeX;
  }
}

class Fuel extends Gui
{
  protected int maxFuel = 100;
  public Fuel() {
    rectY = 360;
    barSize = (currentFuel/100)*rectSizeX;
    barColor = color(150, 150+addFuel, 150);
    titleName = "Fuel";
    titleY = 350;
  }
  public void show() {
    barColor = color(150, 150+addFuel, 150);
    textSize(12);
    titleX = (width-height)/2;
    rectSizeX = width-height-19;
    //title
    fill(255);
    textAlign(CENTER);
    text(titleName, screenSize+titleX, titleY);
    //rectangle
    fill(0);
    stroke(255);
    rect((float)(screenSize+9), rectY, rectSizeX+1, 10);
    //bar
    fill(barColor);
    noStroke();
    rect((float)(screenSize+10), rectY+1, barSize, 9);
  }
  public void interaction() {
    if (addFuel>0) {
      addFuel-=0.1;
    }
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255, ((maxFuel-currentFuel)-(maxFuel/2))*10);
    text("FUEL LOW. FIND FUEL CANNISTERS.", height/2, 50);
    textSize(12);
    resetMatrix();
    barSize = (currentFuel/maxFuel)*rectSizeX;
  }
}
class BulletCool extends Gui
{
  public BulletCool() {
    rectY = 400;
    barSize = (currentFuel/100)*rectSizeX;
    barColor = color(50, 50, 150);
    titleName = "Cannon";
    titleY = 390;
  }
  public void interaction() {
    barColor = color(50+(shootCool*10), 50+(shootCool*10), 150+(shootCool*10));
    if (bulletCoolDown>=0) {
      if (spacePressed) {
        textAlign(CENTER, CENTER);
        textSize(30);
        fill(255, ((bulletCoolDownMax-bulletCoolDown)-(bulletCoolDownMax/2))*100);
        text("CANNON OVERHEATING", height/2, height-50);
        textSize(12);
        resetMatrix();
      }
      barSize = (bulletCoolDown/bulletCoolDownMax)*rectSizeX;
    }
    if (bulletCoolDown<0) {
      textAlign(CENTER, CENTER);
      textSize(30);
      fill(255, 0, 0, ((bulletCoolDownMax-bulletCoolDown)-(bulletCoolDownMax/2))*100);
      text("CANNON OVERHEATED", height/2, height-50);
      textSize(12);
      resetMatrix();
      barSize = 0;
    }
    fill(255);
    textAlign(CENTER, CENTER);
    text("Level: " + currentLevel, height+(width-height)/2, 430);
    text("Enemies: " + robot.size(), height+(width-height)/2, 450);
    text("Friendlies: " + friendly.size(), height+(width-height)/2, 470);
    String [] shootmode = {
      "Standard", "Burst", "Sniper"
    };
    text("Cannon Mode: " + shootmode[shootMode], height+(width-height)/2, 490);
    if (defend) {
      fill(50, 250, 50);
      text("Friendlies: Defend", height+(width-height)/2, 510);
    }
    if (!defend) {
      fill(250, 50, 50);
      text("Friendlies: Attack", height+(width-height)/2, 510);
    }
  }
}

class areaMap extends Gui
{
  int aSize = 24;
  float aX, aY, apX, apY, rX, rY, rpX, rpY;
  public areaMap() {
    rectY = 30;
    barSize = rectSizeX/aSize;
    barColor = 255;
    titleName = "Map";
    titleY = 20;
  }
  public void show() {
    titleX = (width-height)/2;
    rectSizeX = width-height-19;
    //title
    fill(255);
    textAlign(CENTER);
    text(titleName, screenSize+titleX, titleY);
    //rectangle
    fill(0);
    stroke(255);
    rect((float)(screenSize+9), rectY, rectSizeX+1, rectSizeX+1);
    //spacestation
    fill(150);
    noStroke();
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(1*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(1*7.24)+1.5, rectSizeX/areaSize, rectSizeX/areaSize);
    //spacestation
    fill(150);
    noStroke();
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(23*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(23*7.24)+1.5, rectSizeX/areaSize, rectSizeX/areaSize);
    //ship
    noFill();
    stroke(255);
    strokeWeight(0.5);
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+aX+1.5, (float)rectY+(rectSizeX/areaSize/2)+aY+1.5, rectSizeX/areaSize, rectSizeX/areaSize);
    fill(ship.myColor);
    noStroke();
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+apX+1.5, (float)rectY+(rectSizeX/areaSize/2)+apY+1.5, rectSizeX/2/areaSize, rectSizeX/2/areaSize);
    //robot
    aX = ((areaX)*7.24);
    aY = ((areaY)*7.24);
    apX = ((areaX+posX)*7.24);
    apY = ((areaY+posY)*7.24);
    for (int i = 0; i < robot.size (); i++) {
      fill(robot.get(i).myColor);
      noStroke();
      ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(rAX.get(i)*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(rAY.get(i)*7.24)+1.5, rectSizeX/2/areaSize, rectSizeX/2/areaSize);
    }
    for (int i = 0; i < friendly.size (); i++) {
      fill(friendly.get(i).myColor);
      noStroke();
      ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(fAX.get(i)*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(fAY.get(i)*7.24)+1.5, rectSizeX/2/areaSize, rectSizeX/2/areaSize);
    }
    // rX = (((int)rAX.get(i)+0.5)*7.24);
    // rY = (((int)rAY.get(i)+0.5)*7.24);
    // rpX = (rAX.get(i)*7.24);
    // rpY = (rAY.get(i)*7.24);
  }
}

class helpButton extends Gui
{
  color rectColor;
  helpButton() {
    rectY = 530;
    titleName = "Help";
    titleY = 545;
    rectColor = 150;
  }
  public void show() {
    titleX = (width-height)/2;
    rectSizeX = width-height-19;
    //rectangle
    fill(rectColor);
    stroke(0);
    rect((float)(screenSize+9), rectY, rectSizeX+1, 20);
    //title
    fill(255);
    textAlign(CENTER);
    text(titleName, screenSize+titleX, titleY);
  }
  public void interaction() {
    if (mouseX>(float)(screenSize+9)&&mouseX<(float)(screenSize+9)+rectSizeX+1&&mouseY>rectY&&mouseY<rectY+20) {
      fill(150, 200);
      stroke(255);
      rect(100, 100, height-200, height-200);
      //keys
      stroke(0);
      fill(150, 200);
      //wasd
      rect(160, 160, 40, 40);
      rect(200, 160, 40, 40);
      rect(240, 160, 40, 40);
      rect(160, 200, 40, 40);
      rect(200, 200, 40, 40);
      rect(240, 200, 40, 40);
      //arrow keys
      rect(height-200, 160, 40, 40);
      rect(height-240, 160, 40, 40);
      rect(height-280, 160, 40, 40);
      rect(height-200, 200, 40, 40);
      rect(height-240, 200, 40, 40);
      rect(height-280, 200, 40, 40);
      //shoot
      rect(160, 300, 120, 40);
      //cannon mode
      rect(200, 400, 40, 40);
      //pause
      rect((height/2)-20, 300, 40, 40);
      //hyperjump
      rect(height-240, 300, 40, 40);
      //switch mode
      rect(height-240, 400, 40, 40);
      //skip screen
      rect((height/2)-20, 400, 40, 40);
      //text
      textSize(20);
      fill(0);
      textAlign(CENTER, CENTER);
      text("MOVE", height/2, 140);
      text("SHOOT", 220, 280);
      text("CANNON MODE", 220, 380);
      text("PAUSE", (height/2), 280);
      text("HYPERJUMP", height-220, 280);
      text("SWITCH MODE", height-220, 380);
      text("SKIP MENU", (height/2), 380);
      textSize(20);
      text("Q", 180, 180);
      text("W", 220, 180);
      text("E", 260, 180);
      text("A", 180, 220);
      text("S", 220, 220);
      text("D", 260, 220);
      text("SPACE", 220, 320);
      text("F", 220, 420);
      text("P", height/2, 320);
      text("J", height-220, 320);
      text("L", height-220, 420);
      text("C", height/2, 420);
      text("OR", height/2, 220);
      text("E", height-180, 180);
      text("Q", height-260, 180);
      textSize(14);
      text("UP", height-220, 180);
      textSize(10);
      text("DOWN", height-220, 220);
      text("RIGHT", height-180, 220);
      text("LEFT", height-260, 220);
      textSize(13);
      textAlign(CENTER, TOP);
      text("Attempting to leave the boundaries of the map will result in SHIP DAMAGE.\n \nThe spacestation located at the middle of the map will REPAIR you.\n \nYou MUST scout the map for GREEN fuel cannisters.", height/2, 460);
    }
  }
}

abstract class Gui
{
  protected int rectY; //rectangle position
  protected float barSize;
  protected color barColor; //bar color
  protected String titleName;
  protected int titleX = (screenSize-screenSize)/2;
  protected int titleY;
  protected int rectSizeX;

  public void show() {
    textSize(12);
    titleX = (width-height)/2;
    rectSizeX = width-height-19;
    //title
    fill(255);
    textAlign(CENTER);
    text(titleName, screenSize+titleX, titleY);
    //rectangle
    fill(0);
    stroke(255);
    rect((float)(screenSize+9), rectY, rectSizeX+1, 10);
    //bar
    fill(barColor);
    noStroke();
    rect((float)(screenSize+10), rectY+1, barSize, 9);
  }
}

class Menu
{
  protected int men;
  protected float menuFlash;
  Menu() {
    men = 0;//0=main menu 1=pause 2=game over 3=next level 4=help from main menu
    menuFlash = 100;
  }
  public void mainmenu() {
    noStroke();
    fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
    menuFlash-=0.5;
    rect(0, 0, width, height);
    if (men == 0) {
      noStroke();
      fill(0, 0);
      rect(0, 0, width, height);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("ASTEROIDS", width/2, 100);
      fill(255, 100-menuFlash);
      textSize(30);
      text("HIGH SCORE: " + highestLevel, width/2, 140);
      textSize(30);
      fill(255);
      text("PLAY", width/2, height-180);
      if (crazyMode) {
        textSize(15);
        text("developer mode", 100, 250);
        text("intRobots: " + intRobots, 100, 300);
        text("+", 170, 300);
        text("-", 200, 300);
        text("intFriendlys: " + intFriendlys, 100, 350);
        text("+", 170, 350);
        text("-", 200, 350);
        text("Health: " + health.maxHealth, 100, 400);
        text("+", 170, 400);
        text("-", 200, 400);
        if (menuFlash<=0&&(mousePressed&&mouseX>160&&mouseX<180&&mouseY>290&&mouseY<310)) {
          intRobots+=1;
          menuFlash=3;
        }
        if (menuFlash<=0&&(mousePressed&&mouseX>190&&mouseX<210&&mouseY>290&&mouseY<310&&intRobots>0)) {
          intRobots-=1;
          menuFlash=3;
        }
        if (menuFlash<=0&&(mousePressed&&mouseX>160&&mouseX<180&&mouseY>340&&mouseY<360)) {
          intFriendlys+=1;
          menuFlash=3;
        }
        if (menuFlash<=0&&(mousePressed&&mouseX>190&&mouseX<210&&mouseY>340&&mouseY<360&&intFriendlys>0)) {
          intFriendlys-=1;
          menuFlash=3;
        }
        if (menuFlash<=0&&(mousePressed&&mouseX>160&&mouseX<180&&mouseY>390&&mouseY<410)) {
          health.maxHealth+=50;
          health.currentHealth = health.maxHealth;
          menuFlash=3;
        }
        if (menuFlash<=0&&(mousePressed&&mouseX>190&&mouseX<210&&mouseY>390&&mouseY<410&&health.maxHealth>0)) {
          health.maxHealth-=50;
          health.currentHealth = health.maxHealth;
          menuFlash=3;
        }
      }
      if (menuFlash<=50&&(spacePressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50))) {
        menuFlash=10;
        men = 4;
      }
    }
    if (men == 4) {
      //menuFlash+=0.1;
      noStroke();
      fill(0, 0);
      rect(0, 0, width, height);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      //keys
      stroke(0);
      fill(150, 200);
      //wasd
      rect(160, 160, 40, 40);
      rect(200, 160, 40, 40);
      rect(240, 160, 40, 40);
      rect(160, 200, 40, 40);
      rect(200, 200, 40, 40);
      rect(240, 200, 40, 40);
      //arrow keys
      rect(width-200, 160, 40, 40);
      rect(width-240, 160, 40, 40);
      rect(width-280, 160, 40, 40);
      rect(width-200, 200, 40, 40);
      rect(width-240, 200, 40, 40);
      rect(width-280, 200, 40, 40);
      //shoot
      rect(160, 300, 120, 40);
      //cannon mode
      rect(200, 400, 40, 40);
      //pause
      rect((width/2)-20, 300, 40, 40);
      //hyperjump
      rect(width-240, 300, 40, 40);
      //switch mode
      rect(width-240, 400, 40, 40);
      //skip screen
      rect((width/2)-20, 400, 40, 40);
      //continue
      //text
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("INSTRUCTIONS", width/2, 75);
      textSize(20);
      fill(255);
      textAlign(CENTER, CENTER);
      text("MOVE", width/2, 140);
      text("SHOOT", 220, 280);
      text("CANNON MODE", 220, 380);
      text("PAUSE", (width/2), 280);
      text("HYPERJUMP", width-220, 280);
      text("SWITCH FRIENDLY MODE", width-220, 380);
      text("SKIP MENU", (width/2), 380);
      textSize(20);
      text("Q", 180, 180);
      text("W", 220, 180);
      text("E", 260, 180);
      text("A", 180, 220);
      text("S", 220, 220);
      text("D", 260, 220);
      text("SPACE", 220, 320);
      text("F", 220, 420);
      text("P", width/2, 320);
      text("J", width-220, 320);
      text("L", width-220, 420);
      text("C", width/2, 420);
      text("OR", width/2, 220);
      text("E", width-180, 180);
      text("Q", width-260, 180);
      textSize(14);
      text("UP", width-220, 180);
      textSize(10);
      text("DOWN", width-220, 220);
      text("RIGHT", width-180, 220);
      text("LEFT", width-260, 220);
      textSize(16);
      textAlign(CENTER, TOP);
      text("Attempting to leave the boundaries of the map will result in SHIP DAMAGE.\n \nThe spacestation located at the middle of the map will REPAIR you.\n \nYou MUST scout the map for GREEN fuel cannisters.", width/2, 575);
      textAlign(CENTER, CENTER);
      textSize(30);
      text("CONTINUE", width/2, height-180);
      if (menuFlash<=0&&(spacePressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50))) {
        menuFlash=100;
        gameStop = false;
        for (int i = 0; i<robot.size (); i++) {
          robot.remove(i);
          rAX.remove(i);
          rAY.remove(i);
        }
        for (int i = 0; i<friendly.size (); i++) {
          friendly.remove(i);
          fAX.remove(i);
          fAY.remove(i);
        }
        ship.myColor = color(150, 150, 250);
        intRobotsAlive=intRobots;
        intFriendlysAlive=intFriendlys;
        for (int i = 0; i < intRobotsAlive; i++) {
          //robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
          robot.add(new RobotSpaceShip((height/2)+(height*23), (height/2)+(height*23)));
          rAX.add(i, (float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
          rAY.add(i, (float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
          //rAY.add(i, (float)23);
          //rAY.add(i, (float)23);
        }
        for (int i = 0; i < intFriendlysAlive; i++) {
          friendly.add(new FriendlySpaceShip(height/2, height/2));
          //fAX.add(i, (float)((areaX)+(friendly.get(i).getX()-(screenSize/2))/screenSize));
          //fAY.add(i, (float)((areaY)+(friendly.get(i).getY()-(screenSize/2))/screenSize));
          fAX.add(i, (float)1);
          fAY.add(i, (float)1);
        }
        for (int i = 0; i<robot.size (); i++) {
          robot.get(i).maxHealth = 50;
          robot.get(i).currentHealth = robot.get(i).maxHealth;
        }
        for (int i = 0; i<friendly.size (); i++) {
          friendly.get(i).maxHealth = 50;
          friendly.get(i).currentHealth = friendly.get(i).maxHealth;
          friendly.get(i).target = (int)(Math.random()*robot.size());
        }
        // robot.setX((int)((((areaSize/2)-abs((int)robotAreaX-areaX))*height)-(areaX*height)));
        // robot.setY((int)((((areaSize/2)-abs((int)robotAreaY-areaY))*height)-(areaY*height)));
      }
    }
    if (men == 1) {
      noStroke();
      menuFlash-=99;
      fill(0, 0);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("PAUSED", width/2, 100);
      fill(255, 100-menuFlash);
      textSize(30);
      text("HIGH SCORE: " + highestLevel, width/2, 140);
      fill(255);
      textSize(30);
      text("RESUME", width/2, height-180);
      if (menuFlash<=0&&(spacePressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(height/2)-100+200&&mouseY>height-200&&mouseY<height-200+50))) {
        menuFlash=100;
        gameStop = false;
      }
    }
    if (men == 2) {
      noStroke();
      fill(menuFlash*2.55, 0, 0);
      menuFlash-=0.1;
      rect(0, 0, width, height);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("GAME OVER", width/2, 100);
      textSize(30);
      fill(255, 100-menuFlash);
      text("LEVEL: " + currentLevel, width/2, 140);
      text("HIGH SCORE: " + highestLevel, width/2, 170);
      fill(255);
      textSize(30);
      text("AGAIN?", width/2, height-180);
      for (int i = 0; i<robot.size (); i++) {
        robot.remove(i);
        rAX.remove(i);
        rAY.remove(i);
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.remove(i);
        fAX.remove(i);
        fAY.remove(i);
      }
      if (spacePressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        menuFlash=100;
        men = 0;
        bulletCoolDownMax = 10;
        bulletCoolDown = 10;
        fuel.maxFuel = 100;
        health.maxHealth = 100;
        shootDamage = 5;
        currentLevel = 1;
        robotShootDamage = 5+(currentLevel/5);
        friendlyShootDamage = shootDamage*(0.6);
        health.currentHealth = health.maxHealth;
        currentFuel = fuel.maxFuel;
      }
    }
    if (men == 3) {
      for (int i = 0; i<robot.size (); i++) {
        robot.remove(i);
        rAX.remove(i);
        rAY.remove(i);
      }
      for (int i = 0; i<friendly.size (); i++) {
        friendly.remove(i);
        fAX.remove(i);
        fAY.remove(i);
      }
      noStroke();
      fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
      menuFlash-=1;
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      rect((width/2)-400, height-300, 200, 50);
      rect((width/2)-100, height-300, 200, 50);
      rect((width/2)+200, height-300, 200, 50);
      rect((width/2)-400, height-360, 200, 50);
      rect((width/2)+200, height-360, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("LEVEL: " + currentLevel, width/2, 100);
      textSize(30);
      fill(255, 100-menuFlash);
      text("HIGH SCORE: " + highestLevel, width/2, 140);
      text("POINTS: " + points, width/2, 170);
      fill(255);
      text("CONTINUE", width/2, height-180);
      textAlign(CENTER, CENTER);
      textSize(12);
      text("FUEL+20 (3PT)\nFUEL: "+fuel.maxFuel, (width/2)-300, height-280);
      text("HEALTH+20 (7PT)\nHEALTH: "+(int)health.maxHealth, (width/2), height-280);
      text("DAMAGE+1 (7PT)\nDAMAGE: "+shootDamage, (width/2)+300, height-280);
      text("FRIENDLY SHIP+1 (15PT)\nCAPACITY: "+(int)intFriendlysAlive, (width/2)-300, height-340);
      text("CANNON CAPACITY+5 (5PT)\nCAPACITY: "+(int)bulletCoolDownMax, (width/2)+300, height-340);
      //fuel, health, bullet damage
      //fuel
      if (menuFlash<1&&mousePressed&&mouseX>(width/2)-400&&mouseX<(width/2)-400+200&&mouseY>height-300&&mouseY<height-300+50&&points>2) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=3;
        fuel.maxFuel+=20;
        noStroke();
      }
      if (menuFlash<1&&mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-300&&mouseY<height-300+50&&points>6) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=7;
        health.maxHealth+=20;
        noStroke();
      }
      if (menuFlash<1&&mousePressed&&mouseX>(width/2)+200&&mouseX<(width/2)+200+200&&mouseY>height-300&&mouseY<height-300+50&&points>6) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=7;
        shootDamage+=1;
        noStroke();
      }
      if (menuFlash<1&&mousePressed&&mouseX>(width/2)-400&&mouseX<(width/2)-400+200&&mouseY>height-360&&mouseY<height-360+50&&points>14) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=15;
        intFriendlysAlive+=1;
        noStroke();
      }
      if (menuFlash<1&&mousePressed&&mouseX>(width/2)+200&&mouseX<(width/2)+200+200&&mouseY>height-360&&mouseY<height-360+50&&points>4) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=5;
        bulletCoolDownMax+=5;
        noStroke();
      }
      if (spacePressed||spacePressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        menuFlash=100;
        int randX = (int)Math.random()*areaSize;
        int randY = (int)Math.random()*areaSize;
        gameStop = false;
        intRobotsAlive+=1;
        friendlyShootDamage = shootDamage*(0.6);
        for (int i = 0; i < intRobotsAlive; i++) {
          robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
          rAX.add(i, (float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
          rAY.add(i, (float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
        }
        for (int i = 0; i < intFriendlysAlive; i++) {
          friendly.add(new FriendlySpaceShip(height/2, height/2));
          fAX.add(i, (float)((areaX)+(friendly.get(i).getX()-(screenSize/2))/screenSize));
          fAY.add(i, (float)((areaY)+(friendly.get(i).getY()-(screenSize/2))/screenSize));
        }
        bulletCoolDown = bulletCoolDownMax;
        robotShootDamage += (currentLevel/5);
        health.currentHealth+= (health.maxHealth-health.currentHealth)/4;
        currentFuel += (fuel.maxFuel-currentFuel)/4;
        for (int i = 0; i<robot.size (); i++) {
          robot.get(i).maxHealth += (currentLevel*2.5);
          robot.get(i).currentHealth = robot.get(i).maxHealth;
          robot.get(i).setAreaX((int)(Math.random()*areaSize/2)+(areaSize/4)+0.5);
          robot.get(i).setAreaY((int)(Math.random()*areaSize/2)+(areaSize/4)+0.5);
          robot.get(i).setX((int)((screenSize/2)+(screenSize*(robot.get(i).getAreaX()-areaX))));
          robot.get(i).setY((int)((screenSize/2)+(screenSize*(robot.get(i).getAreaY()-areaY))));
          //myCenterY=(float)((screenSize/2)+(screenSize*(robotAreaY-areaY)));
        }
        for (int i = 0; i<friendly.size (); i++) {
          friendly.get(i).maxHealth += (currentLevel*2.5);
          friendly.get(i).currentHealth = friendly.get(i).maxHealth;
          friendly.get(i).target = (int)(Math.random()*robot.size());
          //myCenterY=(float)((screenSize/2)+(screenSize*(robotAreaY-areaY)));
        }
      }
    }
  }
}


public void keyPressed() 
{
  if (keyCode == 'W' || keyCode == UP) {
    wPressed = true;
  }
  if (keyCode == 'S' || keyCode == DOWN) {
    sPressed = true;
  }
  if (keyCode == 'Q' && currentFuel > 0) {
    qPressed = true;
  }
  if (keyCode == 'E' && currentFuel > 0) {
    ePressed = true;
  }
  if (keyCode == 'D' || keyCode == RIGHT) {
    dPressed = true;
  }
  if (keyCode == 'A' || keyCode == LEFT) {
    aPressed = true;
  }
  //NEW HYPERJUMP
  if (keyCode == 'J' ) {
    if (!hyperspace && (int)hyperjump.hyperCool == 0) {
      hyperspace = true;
      hyperjump.hyperCool += hyperjump.hyperCoolAdd;
    }
    if (hyperspace && (int)hyperjump.hyperCool == 0) {
      hyperspace = false;
      ship.setDirectionX(0);
      ship.setDirectionY(0);
      hyperjump.hyperCool += hyperjump.hyperCoolAdd;
    }
  }
  //OLD HYPERJUMP
  //if (keyCode == 'J' && (int)hyperjump.hyperCool == 0) {
  //  jPressed = true;
  //}
  if (keyCode == ' ' && (int)shootCool == 0) {
    spacePressed = true;
  }
  if (keyCode == 'P') {
    if (!gameStop) {
      gameStop = true;
      menu.men = 1;
      menu.mainmenu();
    }
    if (gameStop&&menu.menuFlash<1) {
      menu.menuFlash= 100;
      gameStop = false;
    }
  }
  if (keyCode == 'L') {
    if (!defend) {
      defend = true;
    } else if (defend) {
      defend = false;
    }
  }
  if (keyCode == 'F') {
    if (shootMode < 2 && (int)shootCool == 0) {
      shootMode += 1;
      shootCool = shootCoolTime;
    }
    if (shootMode == 2 && (int)shootCool == 0) {
      shootMode = 0;
      shootCool = shootCoolTime;
    }
  }
  if (keyCode == 'T') {
    if (gameStop&&menu.men == 0) {
      crazyMode = true;
      menu.menuFlash = 0;
    }
  }
}

public void keyReleased() {
  if (keyCode == 'W' || keyCode == UP) {
    wPressed = false;
  }
  if (keyCode == 'S' || keyCode == DOWN) {
    sPressed = false;
  }
  if (keyCode == 'Q') {
    qPressed = false;
  }
  if (keyCode == 'E') {
    ePressed = false;
  }
  if (keyCode == 'D' || keyCode == RIGHT) {
    dPressed = false;
  }
  if (keyCode == 'A' || keyCode == LEFT) { 
    aPressed = false;
  }
  //OLD HYPERJUMP
  //if (keyCode == 'J' && (int)hyperjump.hyperCool == 0) {
  //  jPressed = false;
  //  fill(255);
  //  ellipse((float)control.fX, (float)control.fY, 100, 100);
  //  ship.setX((int)control.fX);
  //  ship.setY((int)control.fY);
  //  if ((int)hyperjump.hyperCool == 0) {
  //    hyperjump.hyperCool = hyperjump.hyperCoolAdd;
  //  }
  //}
  if (keyCode == ' ') {
    spacePressed = false;
  }
}
