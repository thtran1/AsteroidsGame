int screenSize = 700;
SpaceShip ship = new SpaceShip(screenSize/2, screenSize/2);
SpaceStation spacestation = new SpaceStation(screenSize/2, screenSize/2);
Asteroid[] asteroid = new Asteroid[50];
HyperJump hyperjump = new HyperJump();
Speed speed = new Speed();
Health health = new Health();
Fuel fuel = new Fuel();
areaMap map = new areaMap();
helpButton help = new helpButton();
Star[] stars = new Star[screenSize/10];//your variable declarations here
double gravity = 1.015;
double maxTorque = 0.2;
int rotateSpeed = 1;
int topSpeed = 10;
int areaSize = 14;
int areaX = 7;
int areaY = 7;
float currentFuel = 100;
double iX = ship.myCenterX;
double iY = ship.myCenterY;
double fX = iX;
double fY = iY;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
boolean qPressed = false;
boolean ePressed = false;
boolean jPressed = false;
boolean mouseClick = false;

public void setup() 
{
  size(900, 700);
  screenSize = height;
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  for (int i = 0; i < asteroid.length; i++) {
    asteroid[i] = new Asteroid();
  }
}

public void draw() 
{
  //fill((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))*5,100);
  fill(0);
  rect(-100, -100, screenSize+100, screenSize+100);
  for (int i = 0; i < stars.length; i++) {
    stars[i].show();
  }
  if(areaX == 7 && areaY == 7) {
    spacestation.show();
    if (dist(spacestation.getX(), spacestation.getY(), ship.getX(), ship.getY())<25*spacestation.stationSize && currentFuel < fuel.maxFuel)
    {
      currentFuel += 0.1;
    }
  }
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
    line((float)iX, (float)iY, (float)fX, (float)fY);
  }
  if (!jPressed) {
    iX = ship.myCenterX;
    iY = ship.myCenterY;
    fX = iX;
    fY = iY;
  }
  if ((wPressed || aPressed || sPressed || dPressed || qPressed || ePressed) && currentFuel > 0) {
    currentFuel-=0.1;
  }
  if (areaX > areaSize) {
    areaX = 0;
  }
  if (areaX < 0) {
    areaX = areaSize;
  }
  if (areaY > areaSize) {
    areaY = 0;
  }
  if (areaY < 0) {
    areaY = areaSize;
  }
  ship.show();
  ship.move();
  if (areaX != 7 || areaY != 7) {
    for (int i = 0; i < asteroid.length; i++) {
      asteroid[i].show();
      asteroid[i].move();
    }
  }
  fill(50);
  noStroke();
  rect(screenSize, 0, width-height, screenSize);
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
  fill(255);
  text(areaX + " " + areaY, 10, 10);
  //stroke(255);
  //text("Speed: " + (int)abs((float)ship.myDirectionX)+(int)abs((float)ship.myDirectionY), 5, 10);
}

class SpaceShip extends Floater  
{   
  protected double intX = screenSize;
  protected double intY = screenSize;
  SpaceShip(int x, int y) {
    corners = 15;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -5;
    yCorners[0] = -6;
    xCorners[1] = -4;
    yCorners[1] = -10;
    xCorners[2] = -2;
    yCorners[2] = -1;
    xCorners[3] = 9;
    yCorners[3] = -1;
    xCorners[4] = 9;
    yCorners[4] = -4;
    xCorners[5] = 10;
    yCorners[5] = -4;
    xCorners[6] = 10;
    yCorners[6] = -1;
    //top
    xCorners[7] = 21;
    yCorners[7] = 0;
    //top
    xCorners[8] = 10;
    yCorners[8] = 1;
    xCorners[9] = 10;
    yCorners[9] = 4;
    xCorners[10] = 9;
    yCorners[10] = 4;
    xCorners[11] = 9;
    yCorners[11] = 1;
    xCorners[12] = -2;
    yCorners[12] = 1;
    xCorners[13] = -4;
    yCorners[13] = 10;
    xCorners[14] = -5;
    yCorners[14] = 6;
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
    //wrap around screen    
    if (myCenterX>screenSize && areaX<areaSize+1)
    {     
      areaX++;
      myCenterX = 0;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }   
      for (int i = 0; i < asteroid.length; i++) {
        asteroid[i].reset();
      }
    } else if (myCenterX<0 && areaX>-1)
    {     
      areaX--;
      myCenterX = screenSize;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }
      for (int i = 0; i < asteroid.length; i++) {
        asteroid[i].reset();
      }
    }    
    if (myCenterY >screenSize && areaY<areaSize+1)
    {    
      areaY++;
      myCenterY = 0;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      } 
      for (int i = 0; i < asteroid.length; i++) {
        asteroid[i].reset();
      }
    } else if (myCenterY < 0 && areaY>-1)
    {     
      areaY--;
      myCenterY = screenSize;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }     
      for (int i = 0; i < asteroid.length; i++) {
        asteroid[i].reset();
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

class SpaceStation extends Floater
{
  protected int stationSize = 4;
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
    //rotate((int)dRadians);
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
    rectY = 310;
    barSize = 0;
    barColor = color(0, 0, 255);
    titleName = "Hyperjump";
    titleY = 300;
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
    rectY = 270;
    barSize = 0;
    barColor = color(0, 255, 0);
    titleName = "Speed";
    titleY = 260;
  }
  public void interaction() {
    barSize = ((abs((float)ship.myDirectionX)+abs((float)ship.myDirectionY))/topSpeed)*rectSizeX;
  }
}

class Health extends Gui
{
  protected int currentHealth = 100;
  protected int maxHealth = 100;
  public Health() {
    rectY = 230;
    barSize = (currentHealth/100)*rectSizeX;
    barColor = color(255, 0, 0);
    titleName = "Health";
    titleY = 220;
  }
  public void interaction() {
    barSize = (currentHealth/maxHealth)*rectSizeX;
  }
}

class Fuel extends Gui
{
  protected int maxFuel = 100;
  public Fuel() {
    rectY = 350;
    barSize = (currentFuel/100)*rectSizeX;
    barColor = color(150, 150, 150);
    titleName = "Fuel";
    titleY = 340;
  }
  public void interaction() {
    barSize = (currentFuel/maxFuel)*rectSizeX;
  }
}

class areaMap extends Gui
{
  int aSize = 14;
  float aX = areaX/aSize*rectSizeX;
  float aY = areaY/aSize*rectSizeX;
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
    //bar
    noFill();
    stroke(255);
    rect((float)(screenSize+10)+aX, (float)rectY+1+aY, rectSizeX/areaSize, rectSizeX/areaSize);
    aX = (areaX*8.733);
    aY = (areaY*8.733);
  }
}

class helpButton extends Gui
{
  color rectColor;
  helpButton() {
    rectY = 500;
    titleName = "Help";
    titleY = 515;
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
    ellipse((float)fX, (float)fY, 100, 100);
    ship.setX((int)fX);
    ship.setY((int)fY);
    if ((int)hyperjump.hyperCool == 0) {
      hyperjump.hyperCool = hyperjump.hyperCoolAdd;
    }
  }
}

public void mousePressed() {
  if(mousePressed) {
    mouseClick = true;
  }else {mouseClick = false;}
}
