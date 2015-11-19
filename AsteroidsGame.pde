int screenSize = 700;
int areaSize = 24;
float areaX = (areaSize/2);
float areaY = (areaSize/2);
float posX = screenSize/2;
float posY = screenSize/2;
int currentLevel = 1;
int points = 0;
SpaceShip ship = new SpaceShip(screenSize/2, screenSize/2);
SpaceShipControl control = new SpaceShipControl();
//RobotSpaceShip robot = new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
ArrayList <RobotSpaceShip> robot = new ArrayList <RobotSpaceShip>();
SpaceStation spacestation = new SpaceStation(screenSize/2, screenSize/2);
//Asteroid[] asteroid = new Asteroid[50];
ArrayList <Bullet> bullet = new ArrayList <Bullet>();
ArrayList <RobotBullet> robotbullet = new ArrayList <RobotBullet>();
ArrayList <Asteroid> asteroid;
ArrayList <Float> rAX;
ArrayList <Float> rAY;
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
double gravity = 1.015;
double maxTorque = 0.2;
int rotateSpeed = 1;
int topSpeed = 10;
int bulletSpeed = 12;
float bulletCoolDown = 10;
float bulletCoolDownMax = 10;
float bulletS = 2;
float bulletSpray = 0;
int shootCool = 0;
int shootCoolTime = 5; //delay bullets
double shootDamage = 10;
double robotShootDamage = 1+(currentLevel/5);
int robotsAlive, intRobotsAlive;
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
boolean pPressed = false;
boolean cPressed = false;
boolean spacePressed = false;
boolean gameStop = true;

public void setup() 
{
  size(900, 700);
  background(0);
  screenSize = height;
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  asteroid = new ArrayList <Asteroid>();
  rAX = new ArrayList <Float>();
  rAY = new ArrayList <Float>();
  for (int i = 0; i < 10; i++) {
    asteroid.add(new Asteroid());
  }
  for (int i = 0; i < 1; i++) {
    robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
    rAX.add(i, (float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
    rAY.add(i, (float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
  }
  robotsAlive = robot.size();
  intRobotsAlive = robot.size();
}

public void draw() 
{
  //fill((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))*5,100);
  if (gameStop) {
    menu.mainmenu();
  } else if (!gameStop) {
    if (pPressed) {
      gameStop = true;
      menu.men = 1;
      menu.mainmenu();
    }
    if ((int)health.currentHealth > 0) {
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
      for (int i = 0; i<robot.size(); i++) {
        if (dist(spacestation.getX(), spacestation.getY(), robot.get(i).getX(), robot.get(i).getY())<50*spacestation.stationSize)
        {
          if (robot.get(i).currentHealth < robot.get(i).maxHealth && robot.get(i).currentHealth>0) {
            robot.get(i).currentHealth += 0.001*robot.get(i).maxHealth;
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
      for (int i = 0; i <robot.size(); i++) {
        if ((int)robot.get(i).robotShootCool>0) {
          robot.get(i).robotShootCool-=1;
        }
      }
      //if (areaX != areaSize/2 || areaY != areaSize/2) {
      for (int i = 0; i < asteroid.size(); i++) {
        asteroid.get(i).show();
        asteroid.get(i).move();
      }

      if (dist(fuelcan.getX(), fuelcan.getY(), ship.getX(), ship.getY())<40) {
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
          fuelcan.reset();
        }
      }
      if (fuelcan.isTouched == false) {
        fuelcan.show();
        fuelcan.move();
      }
      //}
      if (areaX == areaSize/2 && areaY == areaSize/2) {
        spacestation.show();
      }
      for (int i = 0; i<bullet.size(); i++) {
        bullet.get(i).move();
        bullet.get(i).show();
        if (abs(bullet.get(i).getX()-height/2)>=height/2||abs(bullet.get(i).getY()-height/2)>=height/2) {
          bullet.remove(i);
        }
      }
      for (int i = 0; i<robotbullet.size(); i++) {
        robotbullet.get(i).move();
        robotbullet.get(i).show();
        if (abs(robotbullet.get(i).getX()-height/2)>=height/2||abs(robotbullet.get(i).getY()-height/2)>=height/2) {
          robotbullet.remove(i);
        }
      }
      for (int i = 0; i < robot.size(); i++) {
        for (int x = 0; x <bullet.size(); x++) {
          if (dist(bullet.get(x).getX(), bullet.get(x).getY(), robot.get(i).getX(), robot.get(i).getY()) < 15+bullet.get(x).bulletSize) {
            robot.get(i).currentHealth-=shootDamage;
            bullet.remove(x);
            break;
          }
        }
      }
      for (int x = 0; x < robotbullet.size(); x++) {
        if (dist(robotbullet.get(x).getX(), robotbullet.get(x).getY(), ship.getX(), ship.getY()) < 15+robotbullet.get(x).bulletSize) {
          health.currentHealth-=robotShootDamage;
          robotbullet.remove(x);
        }
      }
      control.control(); //spaceship controls
      for (int i = 0; i < robot.size(); i++) {
        if (robot.get(i).dead == false) {
          if (robot.get(i).currentHealth<=0) {
            robot.get(i).dead = true;
            robot.get(i).myColor = 200;
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
          robot.get(i).myColor-=1;
          if (robot.get(i).myColor<50) {
            robot.remove(i);
            rAX.remove(i);
            rAY.remove(i);
          }
        }
      }
      if (robot.size() == 0) {
        noStroke();
        fill(0);
        rect(0, 0, width, height);
        points+=1;
        currentLevel+=1;
        gameStop = true;
        menu.men = 3;
      }
      ship.show();
      ship.move();
      fill(50);
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
      fill(255, 0, 0, ((health.maxHealth-health.currentHealth)-(health.maxHealth/2))*2);
      //fill(255,0,0,-200);
      rect(-100, -100, screenSize+100, screenSize+100);
      fill(255);
    } else if ((int)health.currentHealth <= 0) {
      for (int i = 0; i<robot.size(); i++) {
        robot.remove(i);
        rAX.remove(i);
        rAY.remove(i);
      }
      noStroke();
      fill(0);
      rect(0, 0, width, height);
      gameStop = true;
      menu.men = 2;
    }
  }
}

class SpaceShipControl
{
  double fX = ship.myCenterX;
  double fY = ship.myCenterY;
  public void control() {
    noStroke();
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
    if (jPressed) {
      ship.myDirectionX = 0;
      ship.myDirectionY = 0;
      double dRadians = (ship.myPointDirection)*(Math.PI/180);
      if (fX > 5 && fX < screenSize-5 && fY > 5 && fY < screenSize-5) {
        fX += ((maxTorque*100) * Math.cos(dRadians));    
        fY += ((maxTorque*100) * Math.sin(dRadians));
      }
      stroke(0, 0, 255);
      line((float)ship.getX(), (float)ship.getY(), (float)fX, (float)fY);
    }
    if (!jPressed) {
      fX = ship.myCenterX;
      fY = ship.myCenterY;
      //fX = iX;
      //fY = iY;
    }
    if (spacePressed && (int)shootCool == 0) {
      if (bulletCoolDown > 0) {
        bulletCoolDown-=0.4;
        bullet.add(new Bullet(ship));
        shootCool = shootCoolTime;
      }
      if (bulletCoolDown<= 0) {
        bulletCoolDown = -2;
      }
    }
    if (bulletCoolDown<bulletCoolDownMax) {
      bulletCoolDown+=0.04;
    }
    if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
      currentFuel-=0.02;
    }
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
  public Bullet(SpaceShip x) {
    myCenterX = x.getX();
    myCenterY = x.getY();
    myPointDirection = x.getPointDirection()+((Math.random()*6)-3);
    dRadians =myPointDirection*(Math.PI/180);
    myDirectionX=bulletSpeed*Math.cos(dRadians) + x.getDirectionX() - ship.myDirectionX;
    myDirectionY=bulletSpeed*Math.sin(dRadians) + x.getDirectionY() - ship.myDirectionY;
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
    myDirectionX = myDirectionX/gravity;
    myDirectionY = myDirectionY/gravity; 
    posX = (float)((myCenterX-(screenSize/2))/screenSize);
    posY = (float)((myCenterY-(screenSize/2))/screenSize);
    //wrap around screen    
    if (myCenterX>screenSize && areaX<areaSize)
    {     
      areaX++;
      myCenterX = 0;
      fuelcan.isTouched = false;
      fuelcan.setX(fuelcan.getX()-screenSize);
      for (int i = 0; i<robot.size(); i++) {
        robot.get(i).reset();
        robot.get(i).setX(robot.get(i).getX()-(screenSize));
      }
      spacestation.setX(spacestation.getX()-(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }   
      for (int i = 0; i < asteroid.size(); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size(); i++) {
        bullet.remove(i);
      }
      for (int i = 0; i < robotbullet.size(); i++) {
        robotbullet.remove(i);
      }
    } else if (myCenterX<0 && areaX>0)
    {     
      areaX--;
      myCenterX = screenSize;
      fuelcan.isTouched = false;
      fuelcan.setX(fuelcan.getX()+screenSize);
      for (int i = 0; i<robot.size(); i++) {
        robot.get(i).reset();
        robot.get(i).setX(robot.get(i).getX()+(screenSize));
      }
      spacestation.setX(spacestation.getX()+(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }
      for (int i = 0; i < asteroid.size(); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size(); i++) {
        bullet.remove(i);
      }
      for (int i = 0; i < robotbullet.size(); i++) {
        robotbullet.remove(i);
      }
    }    
    if (myCenterY >screenSize && areaY<areaSize)
    {    
      areaY++;
      myCenterY = 0;
      fuelcan.isTouched = false;
      fuelcan.setY(fuelcan.getY()-screenSize);
      for (int i = 0; i<robot.size(); i++) {
        robot.get(i).reset();
        robot.get(i).setY(robot.get(i).getY()-(screenSize));
      }
      spacestation.setY(spacestation.getY()-(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      } 
      for (int i = 0; i < asteroid.size(); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size(); i++) {
        bullet.remove(i);
      }
      for (int i = 0; i < robotbullet.size(); i++) {
        robotbullet.remove(i);
      }
    } else if (myCenterY < 0 && areaY>0)
    {     
      areaY--;
      myCenterY = screenSize;
      fuelcan.isTouched = false;
      fuelcan.setY(fuelcan.getY()+screenSize);
      for (int i = 0; i<robot.size(); i++) {
        robot.get(i).reset();
        robot.get(i).setY(robot.get(i).getY()+(screenSize));
      }
      spacestation.setY(spacestation.getY()+(screenSize));
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }     
      for (int i = 0; i < asteroid.size(); i++) {
        asteroid.get(i).reset();
      }
      for (int i = 0; i < bullet.size(); i++) {
        bullet.remove(i);
      }
      for (int i = 0; i < robotbullet.size(); i++) {
        robotbullet.remove(i);
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
  protected float currentHealth = 100+(currentLevel*2.5);
  protected float maxHealth = 100+(currentLevel*2.5);
  protected double intX = screenSize;
  protected double intY = screenSize;
  protected int spaceShipSize = 1;
  protected double radDir =-Math.PI/2;
  protected double radDir1 =-Math.PI/2;
  protected int sp;
  protected int spOffset;
  protected int rotOffset;
  protected int strOffset;
  protected float fuel;
  protected boolean needHealth;
  protected float robotAreaX = 11;
  protected float robotAreaY = 11;
  protected boolean dead = false;
  protected int robotShootCool = 0;
  protected int robotShootCoolTime = 5;
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
    fuel = 10;
    sp = (int)(Math.random()*200)+100;
    spOffset = (int)(sp/4);
    rotOffset = (int)(sp/(Math.random()*20)+10);
    strOffset = (int)(sp/(Math.random()*20)+10);
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
    //change the x and y coordinates by myDirectionX and myDirectionY 
    myPointDirection+=nDegreesOfRotation; 
    myPointDirection = myPointDirection/(gravity*1.2);
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
    myDirectionX = myDirectionX/gravity;
    myDirectionY = myDirectionY/gravity; 
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
    noStroke();
    if (needHealth) {
      //myColor = color(250, 150, 150);
      int space = (int)(sp/4);
      int spaceOffset = spOffset;
      int rotateOffset = rotOffset*2;
      int strafeOffset = strOffset*2;
      radDir1=Math.asin((ship.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, ship.getX(), ship.getY())))-Math.PI/2;
      radDir=Math.asin((spacestation.getX()-myCenterX)/(dist((float)myCenterX, (float)myCenterY, spacestation.getX(), spacestation.getY())))-Math.PI/2;
      if (getY()-spacestation.getY()<0) {
        radDir*=-1;
      }
      if (dist(spacestation.getX(), spacestation.getY(), getX(), getY())<space+spaceOffset) {
        fuel+=0.02;
      }
      fill(255);
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(spacestation.getX(), spacestation.getY(), getX(), getY())>space+spaceOffset) { //w
        accelerate(maxTorque/2, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))>90&&dist(spacestation.getX(), spacestation.getY(), getX(), getY())>space+spaceOffset) { //s

        accelerate(-maxTorque/2, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

        accelerate(maxTorque/3, -90);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

        accelerate(maxTorque/3, 90);
      }
      if (dist(ship.getX(), ship.getY(), getX(), getY())<height/1.5) {
        if ((myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir1*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      }
      if (dist(ship.getX(), ship.getY(), getX(), getY())>height/1.5) {
        if ((myPointDirection-(radDir*180/(Math.PI))<-rotateOffset)) { //d

          rotate(rotateSpeed);
        }
        if ((myPointDirection-(radDir*180/(Math.PI))>rotateOffset)) { //a

          rotate(-rotateSpeed);
        }
      }
      if ((int)robotShootCool==0&&myPointDirection-(radDir1*180/(Math.PI))<rotateOffset/1.5) {
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
      //myColor = color(150, 250, 150);
      int space = sp;
      int spaceOffset = spOffset;
      int rotateOffset = rotOffset;
      int strafeOffset = strOffset;
      radDir=Math.asin((ship.getX()-getX())/(dist((float)getX(), (float)getY(), ship.getX(), ship.getY())))-Math.PI/2;
      if (getY()-ship.getY()<0) {
        radDir*=-1;
      }
      //myPointDirection=radDir*180/(Math.PI);
      fill(255);
      if (dist(spacestation.getX(), spacestation.getY(), getX(), getY())>screenSize/2) {
        int x = (int)(Math.random()*1000);
        if (x%250==0) {
          fuel = 0;
        }
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), getX(), getY())>space+spaceOffset) { //w
        accelerate(maxTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&abs((float)(myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), getX(), getY())<space-spaceOffset) { //s

        accelerate(-maxTorque, 0);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q

        accelerate(maxTorque/1.5, -90);
      }
      if ((abs((float)myDirectionX)+abs((float)myDirectionY))<topSpeed&&myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e

        accelerate(maxTorque/1.5, 90);
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
  protected float hyperCoolAdd = 50;
  public HyperJump() {
    rectY = 320;
    barSize = 0;
    barColor = color(0, 0, 255);
    titleName = "Hyperjump";
    titleY = 310;
  }
  public void interaction() {

    if (hyperCool > 0) {
      hyperCool -= 0.5;
      barSize = (hyperCool/hyperCoolAdd)*rectSizeX;
    }
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
    barSize = ((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))/topSpeed)*rectSizeX;
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
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(areaSize/2*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(areaSize/2*7.24)+1.5, rectSizeX/areaSize, rectSizeX/areaSize);
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
    for (int i = 0; i < robot.size(); i++) {
      fill(robot.get(i).myColor);
      noStroke();
      ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+(rAX.get(i)*7.24)+1.5, (float)rectY+(rectSizeX/areaSize/2)+(rAY.get(i)*7.24)+1.5, rectSizeX/2/areaSize, rectSizeX/2/areaSize);
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
    rectY = 510;
    titleName = "Help";
    titleY = 525;
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
      //pause
      rect((height/2)-20, 300, 40, 40);
      //hyperjump
      rect(height-240, 300, 40, 40);
      //continue
      rect((height/2)-20, 400, 40, 40);
      //text
      textSize(20);
      fill(0);
      textAlign(CENTER, CENTER);
      text("MOVE", height/2, 140);
      text("SHOOT", 220, 280);
      text("PAUSE", (height/2), 280);
      text("HYPERJUMP", height-220, 280);
      text("SKIP MENU", (height/2), 380);
      textSize(20);
      text("Q", 180, 180);
      text("W", 220, 180);
      text("E", 260, 180);
      text("A", 180, 220);
      text("S", 220, 220);
      text("D", 260, 220);
      text("SPACE", 220, 320);
      text("P", height/2, 320);
      text("J", height-220, 320);
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
      textSize(30);
      text("PLAY", width/2, height-180);
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
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
      //pause
      rect((width/2)-20, 300, 40, 40);
      //hyperjump
      rect(width-240, 300, 40, 40);
      //skip screen
      rect((width/2)-20, 400, 40, 40);
      //continue
      //text
      textSize(50);
      textAlign(CENTER, CENTER);
      text("INSTRUCTIONS", width/2, 75);
      textSize(20);
      fill(255);
      textAlign(CENTER, CENTER);
      text("MOVE", width/2, 140);
      text("SHOOT", 220, 280);
      text("PAUSE", (width/2), 280);
      text("HYPERJUMP", width-220, 280);
      text("SKIP MENU", (width/2), 380);
      textSize(20);
      text("Q", 180, 180);
      text("W", 220, 180);
      text("E", 260, 180);
      text("A", 180, 220);
      text("S", 220, 220);
      text("D", 260, 220);
      text("SPACE", 220, 320);
      text("P", width/2, 320);
      text("J", width-220, 320);
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
      if (menuFlash<=0&&(cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50))) {
        menuFlash=100;
        gameStop = false;
      }
    }
    if (men == 1) {
      noStroke();
      menuFlash-=100;
      fill(0, 0);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("PAUSED", width/2, 100);
      textSize(30);
      text("RESUME", width/2, height-180);
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(height/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
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
      text("LEVEL: " + currentLevel, width/2, 140);
      textSize(30);
      text("AGAIN?", width/2, height-180);
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        menuFlash=100;
        gameStop = false;
        intRobotsAlive=1;
        for (int i = 0; i < intRobotsAlive; i++) {
          robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
          rAX.add(i,(float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
          rAY.add(i,(float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
        }
        bulletCoolDownMax = 10;
        bulletCoolDown = 10;
        fuel.maxFuel = 100;
        health.maxHealth = 100;
        shootDamage = 5;
        currentLevel = 1;
        robotShootDamage = 1;
        health.currentHealth = health.maxHealth;
        currentFuel = fuel.maxFuel;
        for (int i = 0; i<robot.size(); i++) {
          robot.get(i).currentHealth = robot.get(i).maxHealth;
        }
        // robot.setX((int)((((areaSize/2)-abs((int)robotAreaX-areaX))*height)-(areaX*height)));
        // robot.setY((int)((((areaSize/2)-abs((int)robotAreaY-areaY))*height)-(areaY*height)));
      }
    }
    if (men == 3) {
      noStroke();
      fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
      menuFlash-=1;
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      rect((width/2)-400, height-300, 200, 50);
      rect((width/2)-100, height-300, 200, 50);
      rect((width/2)+200, height-300, 200, 50);
      rect((width/2)+200, height-360, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("LEVEL: " + currentLevel, width/2, 100);
      textSize(30);
      text("POINTS: " + points, width/2, 140);
      text("CONTINUE", width/2, height-180);
      textAlign(CENTER, CENTER);
      textSize(12);
      text("FUEL+20\nFUEL: "+fuel.maxFuel, (width/2)-300, height-280);
      text("HEALTH+10\nHEALTH: "+(int)health.maxHealth, (width/2), height-280);
      text("DAMAGE+0.5\nDAMAGE: "+shootDamage, (width/2)+300, height-280);
      text("CANNON CAPACITY+2\nCAPACITY: "+(int)bulletCoolDownMax, (width/2)+300, height-340);
      //fuel, health, bullet damage
      //fuel
      if (mousePressed&&mouseX>(width/2)-400&&mouseX<(width/2)-400+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=1;
        fuel.maxFuel+=20;
        noStroke();
      }
      if (mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=1;
        health.maxHealth+=10;
        noStroke();
      }
      if (mousePressed&&mouseX>(width/2)+200&&mouseX<(width/2)+200+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=1;
        shootDamage+=0.5;
        noStroke();
      }
      if (mousePressed&&mouseX>(width/2)+200&&mouseX<(width/2)+200+200&&mouseY>height-360&&mouseY<height-360+50&&points>0) {
        menuFlash=100;
        fill(menuFlash*2.55, menuFlash*2.55, menuFlash*2.55);
        menuFlash-=10;
        points-=1;
        bulletCoolDownMax+=2;
        noStroke();
      }
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        menuFlash=100;
        int randX = (int)Math.random()*areaSize;
        int randY = (int)Math.random()*areaSize;
        gameStop = false;
        intRobotsAlive+=1;
        for (int i = 0; i < intRobotsAlive; i++) {
          robot.add(new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize));
          rAX.add(i,(float)((areaX)+(robot.get(i).getX()-(screenSize/2))/screenSize));
          rAY.add(i,(float)((areaY)+(robot.get(i).getY()-(screenSize/2))/screenSize));
        }
        bulletCoolDown = bulletCoolDownMax;
        robotShootDamage = 1+(currentLevel/5);
        health.currentHealth+= (health.maxHealth-health.currentHealth)/4;
        currentFuel += (fuel.maxFuel-currentFuel)/4;
        for (int i = 0; i<robot.size(); i++) {
          robot.get(i).maxHealth = 100+(currentLevel*2.5);
          robot.get(i).currentHealth = robot.get(i).maxHealth;
          robot.get(i).setX(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
          robot.get(i).setY(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
          robot.get(i).setAreaX((float)((areaX)+((robot.get(i).getX()-(screenSize/2))/screenSize)));
          robot.get(i).setAreaY((float)((areaY)+((robot.get(i).getY()-(screenSize/2))/screenSize)));
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
  if (keyCode == 'J' && (int)hyperjump.hyperCool == 0) {
    jPressed = true;
  }
  if (keyCode == ' ' && (int)shootCool == 0) {
    spacePressed = true;
  }
  if (keyCode == 'P') {
    pPressed = true;
  }
  if (keyCode == 'C') {
    cPressed = true;
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
  if (keyCode == 'J' && (int)hyperjump.hyperCool == 0) {
    jPressed = false;
    fill(255);
    ellipse((float)control.fX, (float)control.fY, 100, 100);
    ship.setX((int)control.fX);
    ship.setY((int)control.fY);
    if ((int)hyperjump.hyperCool == 0) {
      hyperjump.hyperCool = hyperjump.hyperCoolAdd;
    }
  }
  if (keyCode == ' ') {
    spacePressed = false;
  }
  if (keyCode == 'P') {
    pPressed = false;
  }
  if (keyCode == 'C') {
    cPressed = false;
  }
}
