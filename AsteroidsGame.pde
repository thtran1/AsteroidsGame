int screenSize = 600;
SpaceShip ship = new SpaceShip(screenSize/2,screenSize/2);
Star[] stars = new Star[50];//your variable declarations here
double gravity = 1.025;
double maxSpeed = 0.25;
int rotateSpeed = 5;
double iX = ship.myCenterX;
double iY = ship.myCenterY;
double fX = iX;
double fY = iY;
double hyperCool = 0;
double hyperCoolAdd = 50;
boolean wPressed = false;
boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
boolean qPressed = false;
boolean ePressed = false;
boolean jPressed = false;

public void setup() 
{
  size(700, 600);
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
}

public void draw() 
{
  fill(0,100);
  rect(-100, -100, screenSize+100, screenSize+100);
  fill(50);
  rect(screenSize, 0, 100,screenSize);
  if (hyperCool > 0) {
    hyperCool -= 0.5;
  }
  for (int i = 0; i < stars.length; i++) {
    stars[i].show();
  }
  if (wPressed) {
    ship.accelerate(maxSpeed,0);
  }
  if (sPressed) {
    ship.accelerate(-maxSpeed,0);
  }
  if (qPressed) {
    ship.accelerate(maxSpeed/2,-90);
  }
  if (ePressed) {
    ship.accelerate(maxSpeed/2,90);
  }
  if (dPressed && !jPressed) {
    ship.rotate(rotateSpeed);
  }
  if (aPressed && !jPressed) {
    ship.rotate(-rotateSpeed);
  }
  if (jPressed) {
    ship.myDirectionX = 0;
    ship.myDirectionY = 0;
    double dRadians = (ship.myPointDirection)*(Math.PI/180);
    if (fX > 50 || fX < screenSize-50 || fY > 50 || fY < screenSize-50)
    fX += ((maxSpeed*100) * Math.cos(dRadians));    
    fY += ((maxSpeed*100) * Math.sin(dRadians));
    stroke(255,0,0);
    line((float)iX, (float)iY, (float)fX, (float)fY);
  }
  if (!jPressed) {
    iX = ship.myCenterX;
    iY = ship.myCenterY;
    fX = iX;
    fY = iY;
  }
  ship.show();
  ship.move();
  //stroke(255);
  //text("Speed: " + (int)abs((float)ship.myDirectionX)+(int)abs((float)ship.myDirectionY), 5, 10);
  text("Hyperspace:",screenSize+10,20);
  fill(0);
  rect((float)(screenSize+15), 30, (float)hyperCoolAdd, 10);
  fill(255,0,0);
  noStroke();
  rect((float)(screenSize+15),31,(float)hyperCool,9);
}

class SpaceShip extends Floater  
{   
  double intX = screenSize;
  double intY = screenSize;
  SpaceShip(int x, int y) {
    corners = 3;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -3;
    yCorners[0] = -3;
    xCorners[1] = 6;
    yCorners[1] = 0;
    xCorners[2] = -3;
    yCorners[2] = 3;
    myColor = 255;
    myCenterX = x;
    myCenterY = y;
    myDirectionX = 0;
    myDirectionY = 0;
    myPointDirection = 270;
  }
  public void setX(int x) {myCenterX = x;}  
  public int getX() {return (int)myCenterX;}   
  public void setY(int y) {myCenterY = y;}   
  public int getY() {return (int)myCenterY;}
  public void setDirectionX(double x) {myDirectionX = x;}  
  public double getDirectionX() {return myDirectionX;}
  public void setDirectionY(double y) {myDirectionY = y;}  
  public double getDirectionY() {return myDirectionY;} 
  public void setPointDirection(int degrees) {myPointDirection = degrees;}  
  public double getPointDirection() {return myPointDirection;} 
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
  public void accelerate (double dAmount, double pAdd)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians = (myPointDirection+pAdd)*(Math.PI/180);     
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
    myDirectionX = myDirectionX/gravity;
    myDirectionY = myDirectionY/gravity; 
    //wrap around screen    
    if(myCenterX >screenSize)
    {     
      myCenterX = 0;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = screenSize;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }        
    }    
    if(myCenterY >screenSize)
    {    
      myCenterY = 0;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }        
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = screenSize;
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }        
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
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
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
    ellipse(starX,starY,(float)starSize,(float)starSize);
    starColor = (int)(Math.random()*50)+200;
    starSize = Math.random()*5;
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
  if (keyCode == 'Q') {
    qPressed = true;
  }
  if (keyCode == 'E') {
    ePressed = true;
  }
  if (keyCode == 'D' || keyCode == RIGHT) {
    dPressed = true;
  }
  if (keyCode == 'A' || keyCode == LEFT) {
    aPressed = true;
  }
  if (keyCode == 'J' && (int)hyperCool == 0) {
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
  if (keyCode == 'J' && (int)hyperCool == 0) {
    jPressed = false;
    fill(255);
    ellipse((float)fX,(float)fY,100,100);
    ship.myCenterX = fX;
    ship.myCenterY = fY;
    if ((int)hyperCool == 0) {
      for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
      }
      hyperCool = hyperCoolAdd;
    }
  }
}
