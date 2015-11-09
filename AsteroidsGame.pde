int screenSize = 700;
int areaSize = 24;
float areaX = (areaSize/2);
float areaY = (areaSize/2);
float posX = screenSize/2;
float posY = screenSize/2;
float robotAreaX = 11;
float robotAreaY = 11;
int currentLevel = 1;
int points = 0;
SpaceShip ship = new SpaceShip(screenSize/2, screenSize/2);
SpaceShipControl control = new SpaceShipControl();
RobotSpaceShip robot = new RobotSpaceShip(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize, ((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
RobotSpaceShipControl robotcontrol = new RobotSpaceShipControl();
SpaceStation spacestation = new SpaceStation(screenSize/2, screenSize/2);
//Asteroid[] asteroid = new Asteroid[50];
ArrayList <Bullet> bullet = new ArrayList <Bullet>();
ArrayList <RobotBullet> robotbullet = new ArrayList <RobotBullet>();
ArrayList <Asteroid> asteroid;
HyperJump hyperjump = new HyperJump();
Speed speed = new Speed();
Health health = new Health();
Fuel fuel = new Fuel();
areaMap map = new areaMap();
helpButton help = new helpButton();
Menu menu = new Menu();
Star[] stars = new Star[screenSize/10];//your variable declarations here
double gravity = 1.015;
double maxTorque = 0.2;
int rotateSpeed = 1;
int topSpeed = 10;
int bulletSpeed = 15;
float bulletS = 2;
float bulletSpray = 0;
int shootCool = 0;
int shootCoolTime = 5; //delay bullets
double shootDamage = 5;
int robotShootCool = 0;
int robotShootCoolTime = 5;
double robotShootDamage = 1+(currentLevel/5);
float currentFuel = 100;
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
  //for (int i = 0; i < asteroid.size(); i++) {
  //  asteroid = new Asteroid();
  //}
  asteroid = new ArrayList <Asteroid>();
  for (int i = 0; i < 50; i++) {
    asteroid.add(new Asteroid());
  }
}

public void draw() 
{
  //fill((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))*5,100);
  if (gameStop) {
    menu.mainmenu();
  } else if (!gameStop) {
    if (pPressed) {
      noStroke();
      fill(0);
      rect(0, 0, width, height);
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
      if (areaX == areaSize/2 && areaY == areaSize/2) {
        spacestation.show();
        if (dist(spacestation.getX(), spacestation.getY(), ship.getX(), ship.getY())<25*spacestation.stationSize && currentFuel < fuel.maxFuel)
        {
          currentFuel += 0.002*fuel.maxFuel;
        }
        if (dist(spacestation.getX(), spacestation.getY(), ship.getX(), ship.getY())<25*spacestation.stationSize && health.currentHealth < health.maxHealth)
        {
          health.currentHealth += 0.001*health.maxHealth;
        }
        if (dist(spacestation.getX(), spacestation.getY(), robot.getX(), robot.getY())<25*spacestation.stationSize && robot.currentHealth < robot.maxHealth)
        {
          robot.currentHealth += 0.001*robot.maxHealth;
        }
      }
      control.control(); //spaceship controls
      if ((int)robot.currentHealth>robot.maxHealth/10-(currentLevel/5)) {
        robotcontrol.control();//robot spaceship controls
        //text("Attack", 50, 300);
      }
      if ((int)robot.currentHealth<=robot.maxHealth/10-(currentLevel/5)&&(int)robot.currentHealth>0) {
        robotcontrol.reFuel();//robot spaceship controls
        //text("Need Health", 50, 300);
      }
      for (int i = 0; i<bullet.size(); i++) {
        bullet.get(i).show();
        bullet.get(i).move();
        if (abs(bullet.get(i).getX()-height/2)>=height/2||abs(bullet.get(i).getY()-height/2)>=height/2) {
          bullet.remove(i);
        }
      }
      for (int i = 0; i<robotbullet.size(); i++) {
        robotbullet.get(i).show();
        robotbullet.get(i).move();
        if (abs(robotbullet.get(i).getX()-height/2)>=height/2||abs(robotbullet.get(i).getY()-height/2)>=height/2) {
          robotbullet.remove(i);
        }
      }
      if ((int)shootCool>0) {
        shootCool-=1;
      }
      if ((int)robotShootCool>0) {
        robotShootCool-=1;
      }
      if ((areaX != areaSize/2 || areaY != areaSize/2) && areaX==robotAreaX && areaY == robotAreaY) {
      }
      robot.show();
      robot.move();
      ship.show();
      ship.move();
      if (areaX != areaSize/2 || areaY != areaSize/2) {
        for (int i = 0; i < asteroid.size(); i++) {
          asteroid.get(i).show();
          asteroid.get(i).move();

          for (int x = 0; x < bullet.size()-1; x++) {
            if (dist(bullet.get(x).getX(), bullet.get(x).getY(), asteroid.get(i).getX(), asteroid.get(i).getY())<10) {
              //asteroid.remove(i);
              //bullet.remove(x);
            }
          }
        }
      }
      if (areaX != areaSize/2 || areaY != areaSize/2) {
        for (int i = 0; i < asteroid.size(); i++) {
          for (int x = 0; x < robotbullet.size(); x++) {
            if (dist(robotbullet.get(x).getX(), robotbullet.get(x).getY(), asteroid.get(i).getX(), asteroid.get(i).getY())<10) {
              //asteroid.remove(i);
              //robotbullet.remove(x);
            }
          }
        }
      }
      for (int x = 0; x < bullet.size(); x++) {
        if (dist(bullet.get(x).getX(), bullet.get(x).getY(), robot.getX(), robot.getY()) < 15+bullet.get(x).bulletSize/2) {
          robot.currentHealth-=shootDamage;
          bullet.remove(x);
        }
      }
      for (int x = 0; x < robotbullet.size(); x++) {
        if (dist(robotbullet.get(x).getX(), robotbullet.get(x).getY(), ship.getX(), ship.getY()) < 15+robotbullet.get(x).bulletSize/2) {
          health.currentHealth-=robotShootDamage;
          robotbullet.remove(x);
        }
      }
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
      map.show();
      help.show();
      help.interaction();
      if ((int)robot.currentHealth<=0) {
        noStroke();
        fill(0);
        rect(0, 0, width, height);
        robotcontrol.nextLevel();//robot spaceship controls
      }
    } else if ((int)health.currentHealth <= 0) {
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
    if (qPressed && currentFuel > 0) {
      double dRadiansR = (ship.myPointDirection+90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)ship.myCenterX, (float)ship.myCenterY);
      rotate((float)dRadiansR);
      ellipse(5, -9, 10, 2);
      resetMatrix();
      ship.accelerate(maxTorque/1.5, -90);
    }
    if (ePressed && currentFuel > 0) {
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
      bullet.add(new Bullet(ship));
      shootCool = shootCoolTime;
    }
    if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
      currentFuel-=0.02;
    }
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
    myPointDirection = x.getPointDirection();
    dRadians =myPointDirection*(Math.PI/180);
    myDirectionX=bulletSpeed*Math.cos(dRadians) + x.getDirectionX();
    myDirectionY=bulletSpeed*Math.sin(dRadians) + x.getDirectionY();
    myColor = color(255, 255, 0);
  }
  public void show()
  {
    noStroke();
    fill(myColor);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize, bulletSize);
    bulletSize+=bulletSpray;
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
      robot.reset();
      robot.setX(robot.getX()-(screenSize));
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
      robot.reset();
      robot.setX(robot.getX()+(screenSize));
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
      robot.reset();
      robot.setY(robot.getY()-(screenSize));
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
      robot.reset();
      robot.setY(robot.getY()+(screenSize));
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

class RobotSpaceShipControl
{
  protected double radDir =-Math.PI/2;
  protected double radDir1 =-Math.PI/2;
  protected int space;
  protected int spaceOffset;
  protected int rotateOffset;
  protected int strafeOffset;
  protected float fuel;
  RobotSpaceShipControl() {
    fuel = 10;
    space = 200;
    spaceOffset = (int)space/4;
    rotateOffset = (int)space/8;
    strafeOffset = (int)space/8;
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
    robot.myColor = color(250, 150, 150);
    space = 50;
    spaceOffset = (int)space/4;
    rotateOffset = (int)(space/(40+(currentLevel)));
    strafeOffset = (int)(space/(40+(currentLevel)));
    radDir1=Math.asin((ship.getX()-robot.getX())/(dist((float)robot.getX(), (float)robot.getY(), ship.getX(), ship.getY())))-Math.PI/2;
    radDir=Math.asin((spacestation.getX()-robot.getX())/(dist((float)robot.getX(), (float)robot.getY(), spacestation.getX(), spacestation.getY())))-Math.PI/2;
    if (robot.getY()-spacestation.getY()<0) {
      radDir*=-1;
    }
    if (dist(spacestation.getX(), spacestation.getY(), robot.getX(), robot.getY())<space+spaceOffset) {
      fuel+=0.02;
    }
    fill(255);
    text((int)(radDir*180/(Math.PI)), 50, 10);
    if ((abs((float)robot.myDirectionX)+abs((float)robot.myDirectionY))<topSpeed&&abs((float)(robot.myPointDirection-(radDir*180/(Math.PI))))<90&&dist(spacestation.getX(), spacestation.getY(), robot.getX(), robot.getY())>space+spaceOffset) { //w
      double dRadians = (robot.myPointDirection)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadians);
      ellipse(-7, -3, 10, 2);
      ellipse(-7, 3, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque, 0);
    }
    if ((abs((float)robot.myDirectionX)+abs((float)robot.myDirectionY))<topSpeed&&abs((float)(robot.myPointDirection-(radDir*180/(Math.PI))))>90&&dist(spacestation.getX(), spacestation.getY(), robot.getX(), robot.getY())>space+spaceOffset) { //s
      double dRadiansR = (robot.myPointDirection+30)*(Math.PI/180);
      double dRadiansL = (robot.myPointDirection-30)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(1, 4, 10, 2);
      resetMatrix();
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(1, -4, 10, 2);
      resetMatrix();
      robot.accelerate(-maxTorque, 0);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q
      double dRadiansR = (robot.myPointDirection+90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(5, -9, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque/10, -90);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e
      double dRadiansL = (robot.myPointDirection-90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(5, 9, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque/10, 90);
    }
    if (robot.myPointDirection-(radDir1*180/(Math.PI))<-rotateOffset&&dist(ship.getX(), ship.getY(), robot.getX(), robot.getY())<space*5-spaceOffset) { //d
      double dRadiansL = (robot.myPointDirection-90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(3, 20, 8, 2);
      resetMatrix();
      robot.rotate(rotateSpeed);
    }
    if (robot.myPointDirection-(radDir1*180/(Math.PI))>rotateOffset&&dist(ship.getX(), ship.getY(), robot.getX(), robot.getY())<space*5-spaceOffset) { //a
      double dRadiansR = (robot.myPointDirection+90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(3, -20, 8, 2);
      resetMatrix();
      robot.rotate(-rotateSpeed);
    }
    if ((int)robotShootCool==0&&robot.myPointDirection-(radDir1*180/(Math.PI))<rotateOffset/2) {
      robotbullet.add(new RobotBullet(robot));
      robotShootCool = robotShootCoolTime;
    }//shoot
    //if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
    //  currentFuel-=0.01;
    //}
    noStroke();
    fill(0, 50);
    double dRadians = robot.myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < robot.corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((robot.xCorners[nI]*2 * Math.cos(dRadians)) - (robot.yCorners[nI]*2 * Math.sin(dRadians))+robot.myCenterX);     
      yRotatedTranslated = (int)((robot.xCorners[nI]*2 * Math.sin(dRadians)) + (robot.yCorners[nI]*2 * Math.cos(dRadians))+robot.myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
    int rectSizeX = 50;
    float barSize = (float)(robot.currentHealth/robot.maxHealth)*rectSizeX;
    if (robot.currentHealth < robot.maxHealth) {
      //rectangle
      fill(0);
      stroke(150);
      strokeWeight(1);
      rect((float)robot.getX()-rectSizeX/2, robot.getY()+10, rectSizeX+1, 6);
      strokeWeight(0.5);
      //bar
      fill(255, 0, 0);
      noStroke();
      rect((float)robot.getX()+1-rectSizeX/2, robot.getY()+11, barSize, 5);
    }
  }

  public void control() {
    robot.myColor = color(150, 250, 150);
    space = 200;
    spaceOffset = (int)space/4;
    rotateOffset = (int)(space/(16+(currentLevel*4)));
    strafeOffset = (int)(space/(16+(currentLevel*2)));
    radDir=Math.asin((ship.getX()-robot.getX())/(dist((float)robot.getX(), (float)robot.getY(), ship.getX(), ship.getY())))-Math.PI/2;
    if (robot.getY()-ship.getY()<0) {
      radDir*=-1;
    }
    //robot.myPointDirection=radDir*180/(Math.PI);
    fill(255);
    text((int)(radDir*180/(Math.PI)), 50, 10);
    if (dist(spacestation.getX(), spacestation.getY(), robot.getX(), robot.getY())>screenSize/2) {
      int x = (int)(Math.random()*1000);
      if (x%250==0) {
        fuel = 0;
      }
    }
    if ((abs((float)robot.myDirectionX)+abs((float)robot.myDirectionY))<topSpeed&&abs((float)(robot.myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), robot.getX(), robot.getY())>space+spaceOffset) { //w
      double dRadians = (robot.myPointDirection)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadians);
      ellipse(-7, -3, 10, 2);
      ellipse(-7, 3, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque, 0);
    }
    if ((abs((float)robot.myDirectionX)+abs((float)robot.myDirectionY))<topSpeed&&abs((float)(robot.myPointDirection-(radDir*180/(Math.PI))))<90&&dist(ship.getX(), ship.getY(), robot.getX(), robot.getY())<space-spaceOffset) { //s
      double dRadiansR = (robot.myPointDirection+30)*(Math.PI/180);
      double dRadiansL = (robot.myPointDirection-30)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(1, 4, 10, 2);
      resetMatrix();
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(1, -4, 10, 2);
      resetMatrix();
      robot.accelerate(-maxTorque, 0);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))>strafeOffset) { //q
      double dRadiansR = (robot.myPointDirection+90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(5, -9, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque/1.5, -90);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))<-strafeOffset) { //e
      double dRadiansL = (robot.myPointDirection-90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(5, 9, 10, 2);
      resetMatrix();
      robot.accelerate(maxTorque/1.5, 90);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))<-rotateOffset) { //d
      double dRadiansL = (robot.myPointDirection-90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansL);
      ellipse(3, 20, 8, 2);
      resetMatrix();
      robot.rotate(rotateSpeed);
    }
    if (robot.myPointDirection-(radDir*180/(Math.PI))>rotateOffset) { //a
      double dRadiansR = (robot.myPointDirection+90)*(Math.PI/180);
      fill(255, 0, 0);
      translate((float)robot.myCenterX, (float)robot.myCenterY);
      rotate((float)dRadiansR);
      ellipse(3, -20, 8, 2);
      resetMatrix();
      robot.rotate(-rotateSpeed);
    }
    if ((int)robotShootCool==0&&robot.myPointDirection-(radDir*180/(Math.PI))<rotateOffset/2) {
      robotbullet.add(new RobotBullet(robot));
      robotShootCool = robotShootCoolTime;
    }//shoot
    noStroke();
    fill(0, 50);
    double dRadians = robot.myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < robot.corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((robot.xCorners[nI]*2 * Math.cos(dRadians)) - (robot.yCorners[nI]*2 * Math.sin(dRadians))+robot.myCenterX);     
      yRotatedTranslated = (int)((robot.xCorners[nI]*2 * Math.sin(dRadians)) + (robot.yCorners[nI]*2 * Math.cos(dRadians))+robot.myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
    int rectSizeX = 50;
    float barSize = (float)(robot.currentHealth/robot.maxHealth)*rectSizeX;
    if (robot.currentHealth < robot.maxHealth) {
      //rectangle
      fill(0);
      stroke(150);
      strokeWeight(1);
      rect((float)robot.getX()-rectSizeX/2, robot.getY()+10, rectSizeX+1, 6);
      strokeWeight(0.5);
      //bar
      fill(255, 0, 0);
      noStroke();
      rect((float)robot.getX()+1-rectSizeX/2, robot.getY()+11, barSize, 5);
    }
  }
}

class RobotBullet extends Floater
{
  protected double dRadians;
  protected float bulletSize = bulletS;
  public RobotBullet(RobotSpaceShip x) {
    myCenterX = x.getX();
    myCenterY = x.getY();
    myPointDirection = x.getPointDirection();
    dRadians =myPointDirection*(Math.PI/180);
    myDirectionX=bulletSpeed*Math.cos(dRadians) + x.getDirectionX();
    myDirectionY=bulletSpeed*Math.sin(dRadians) + x.getDirectionY();
    myColor = color(255, 255, 0);
  }
  public void show()
  {
    noStroke();
    fill(myColor);
    ellipse((int)myCenterX, (int)myCenterY, bulletSize, bulletSize);
    bulletSize+=bulletSpray;
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
      if (robot.getX()>height+(((int)robotAreaX-areaX)*height)) {
        robot.currentHealth-=abs((float)robot.getDirectionX());
        robot.setDirectionX(-robot.getDirectionX());
      }
    }
    if ((int)robotAreaX == 0) {
      if (robot.getX()<0+(((int)robotAreaX-areaX)*height)) {
        robot.currentHealth-=abs((float)robot.getDirectionX());
        robot.setDirectionX(-robot.getDirectionX());
      }
    }
    if ((int)robotAreaY == areaSize) {
      if (robot.getY()>height+(((int)robotAreaY-areaY)*height)) {
        robot.currentHealth-=abs((float)robot.getDirectionY());
        robot.setDirectionY(-robot.getDirectionY());
      }
    }
    if ((int)robotAreaY == 0) {
      if (robot.getY()<0+(((int)robotAreaY-areaY)*height)) {
        robot.currentHealth-=abs((float)robot.getDirectionY());
        robot.setDirectionY(-robot.getDirectionY());
      }
    }
    //wrap around screen   
    //if (myCenterX+((robotAreaX-areaX)*screenSize)>height+((robotAreaX-areaX)*screenSize))
    //{     
    // robotAreaX++;
    // myCenterX = 0+(robotAreaX-areaX)*screenSize;
    //} 
    //else if (myCenterX+((robotAreaX-areaX)*screenSize)<0+((robotAreaX-areaX)*screenSize))
    //{     
    // robotAreaX--;
    // myCenterX = height+((robotAreaX-areaX)*screenSize);
    //}    
    //if (myCenterY+((robotAreaY-areaY)*screenSize)>height+((robotAreaY-areaY)*screenSize))
    //{   
    // robotAreaY++;
    // myCenterY = 0;
    //} else if (myCenterY+((robotAreaY-areaY)*screenSize)<0+((robotAreaY-areaY)*screenSize))
    //{     
    // robotAreaY--;
    // myCenterY = height+((robotAreaY-areaY)*screenSize);
    //}
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

class SpaceStation extends Floater
{
  protected int stationSize = 5;
  SpaceStation(int x, int y) {
    corners = 8;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -25*stationSize;
    yCorners[0] = -50*stationSize;
    xCorners[1] = 25*stationSize;
    yCorners[1] = -50*stationSize;
    xCorners[2] = 50*stationSize;
    yCorners[2] = -25*stationSize;
    xCorners[3] = 50*stationSize;
    yCorners[3] = 25*stationSize;
    xCorners[4] = 25*stationSize;
    yCorners[4] = 50*stationSize;
    xCorners[5] = -25*stationSize;
    yCorners[5] = 50*stationSize;
    xCorners[6] = -50*stationSize;
    yCorners[6] = 25*stationSize;
    xCorners[7] = -50*stationSize;
    yCorners[7] = -25*stationSize;
    myColor = color(150);
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
    nDegreesOfRotation = 0;
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
    //double dRadians = (myPointDirection)*(Math.PI/180);
    fill(50);
    noStroke();
    translate((float)myCenterX, (float)myCenterY);
    //rotate((int)nDegreesOfRotation);
    rect(-50*stationSize-1, -25*stationSize, 100*stationSize+2, 50*stationSize);
    rect(-25*stationSize, -50*stationSize-1, 50*stationSize, 100*stationSize+2);
    resetMatrix();
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
  Asteroid() {
    corners = (int)(Math.random()*3)+3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    for (int i = 0; i < corners; i++) {
      xCorners[i] = (-abs((int)((corners/2)-(i))))*((int)(Math.random()*6)+6);
      yCorners[i] = (-abs((int)((corners*0.75)-(i))))*((int)(Math.random()*6)+6);
    }
    myColor = 150;
    myCenterX = (Math.random()*screenSize*2)-screenSize;
    myCenterY = (Math.random()*screenSize*2)-screenSize;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*2)-1;
  }
  public void reset() {
    corners = (int)(Math.random()*3)+3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    for (int i = 0; i < corners; i++) {
      xCorners[i] = (-abs((int)((corners/2)-(i))))*((int)(Math.random()*5)+10);
      yCorners[i] = (-abs((int)((corners*0.75)-(i))))*((int)(Math.random()*5)+10);
    }
    myCenterX = (Math.random()*screenSize*2)-screenSize;
    myCenterY = (Math.random()*screenSize*2)-screenSize;
    myDirectionX = (Math.random()*1)-0.5;
    myDirectionY = (Math.random()*1)-0.5;
    myPointDirection = (int)Math.random()*360;
    speedRotation = (Math.random()*2)-1;
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
    barColor = color(150, 150, 150);
    titleName = "Fuel";
    titleY = 350;
  }
  public void interaction() {
    barSize = (currentFuel/maxFuel)*rectSizeX;
    fill(255);
    text("Level: " + currentLevel, height+(width-height)/2, 390);
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
    fill(robot.myColor);
    noStroke();
    ellipse((float)(screenSize+9)+(rectSizeX/areaSize/2)+rpX+1.5, (float)rectY+(rectSizeX/areaSize/2)+rpY+1.5, rectSizeX/2/areaSize, rectSizeX/2/areaSize);
    aX = ((areaX)*7.24);
    aY = ((areaY)*7.24);
    apX = ((areaX+posX)*7.24);
    apY = ((areaY+posY)*7.24);
    rX = (((int)robotAreaX+0.5)*7.24);
    rY = (((int)robotAreaY+0.5)*7.24);
    rpX = (robotAreaX*7.24);
    rpY = (robotAreaY*7.24);
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
      //text
      textSize(20);
      fill(0);
      textAlign(CENTER, CENTER);
      text("MOVE", height/2, 140);
      text("SHOOT", 220, 280);
      text("PAUSE", (height/2), 280);
      text("HYPERJUMP", height-220, 280);
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
      text("OR", height/2, 220);
      text("E", height-180, 180);
      text("Q", height-260, 180);
      textSize(14);
      text("UP", height-220, 180);
      textSize(10);
      text("DOWN", height-220, 220);
      text("RIGHT", height-180, 220);
      text("LEFT", height-260, 220);
      textSize(12);
      textAlign(CENTER, TOP);
      text("Shoot the enemy spaceship and avoid death.\nAttempting to leave the boundaries of the map will result in ship damage.\nThe middle of the spaceship will repair and refuel you.", height/2, 360);
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
  Menu() {
    men = 0;//0=main menu 1=pause 2=game over 3=next level 4=help from main menu
  }
  public void mainmenu() {
    noStroke();
    fill(0, 0);
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
        gameStop = false;
      }
    } else if (men == 1) {
      noStroke();
      fill(0, 0);
      rect(0, 0, height, height);
      stroke(255);
      rect((height/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("PAUSED", height/2, 100);
      textSize(30);
      text("RESUME", height/2, height-180);
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(height/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        gameStop = false;
      }
    } else if (men == 2) {
      noStroke();
      fill(0, 0);
      rect(0, 0, width, height);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      fill(255);
      textSize(50);
      textAlign(CENTER, CENTER);
      text("GAME OVER", width/2, 100);
      textSize(30);
      text("AGAIN?", width/2, height-180);
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        gameStop = false;
        currentLevel = 1;
        robotShootDamage = 1;
        health.currentHealth = health.maxHealth;
        currentFuel = fuel.maxFuel;
        robot.currentHealth = robot.maxHealth;
        robot.setX((int)((((areaSize/2)-abs((int)robotAreaX-areaX))*height)-(areaX*height)));
        robot.setY((int)((((areaSize/2)-abs((int)robotAreaY-areaY))*height)-(areaY*height)));
      }
    } else if (men == 3) {
      noStroke();
      fill(0);
      rect(0, 0, width, height);
      stroke(255);
      rect((width/2)-100, height-200, 200, 50);
      rect((width/2)-400, height-300, 200, 50);
      rect((width/2)-100, height-300, 200, 50);
      rect((width/2)+200, height-300, 200, 50);
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
      text("HEALTH+10\nHEALTH: "+health.maxHealth, (width/2), height-280);
      text("DAMAGE+0.5\nDAMAGE: "+shootDamage, (width/2)+300, height-280);
      //fuel, health, bullet damage
      //fuel
      if (mousePressed&&mouseX>(width/2)-400&&mouseX<(width/2)-400+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        points-=1;
        fuel.maxFuel+=20;
        noStroke();
        fill(0);
        rect(0, 0, width, height);
      }
      if (mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        points-=1;
        health.maxHealth+=10;
        noStroke();
        fill(0);
        rect(0, 0, width, height);
      }
      if (mousePressed&&mouseX>(width/2)+200&&mouseX<(width/2)+200+200&&mouseY>height-300&&mouseY<height-300+50&&points>0) {
        points-=1;
        shootDamage+=0.5;
        noStroke();
        fill(0, 0);
        rect(0, 0, width, height);
      }
      if (cPressed||(mousePressed&&mouseX>(width/2)-100&&mouseX<(width/2)-100+200&&mouseY>height-200&&mouseY<height-200+50)) {
        int randX = (int)Math.random()*areaSize;
        int randY = (int)Math.random()*areaSize;
        gameStop = false;
        robotShootDamage = 1+(currentLevel/5);
        robot.maxHealth = 100+(currentLevel*2.5);
        health.currentHealth+= (health.maxHealth-health.currentHealth)/4;
        currentFuel += (fuel.maxFuel-currentFuel)/4;
        robot.currentHealth = robot.maxHealth;
        robot.setX(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
        robot.setY(screenSize/2+((int)(Math.random()*areaSize)-(areaSize/2))*screenSize);
        robotAreaX = (float)((areaX)+((robot.myCenterX-(screenSize/2))/screenSize));
        robotAreaY = (float)((areaY)+((robot.myCenterY-(screenSize/2))/screenSize));
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
