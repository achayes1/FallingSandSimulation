/** Created by Andrew Hayes and Carl Liu. COMP 221 Final Project. 
"Elementalist Sandbox" Version 2.4


5/4 toolbar added
TODO: fix combustion/growth, nullpointers
*/


import java.util.List;
import java.util.ArrayList;
import java.util.Random;

//Sandbox Parameters
static final int width = 600;
static final int height = 600;
//Particle Colors
static final int sandCol = 0xFFFED4;
static final int waterCol = 0x0066CC;
static final int steelCol = 0xE0DFDB;
static final int oilCol = 0x372A0A;
static final int dirtCol = 0x987628;
static final int fireCol = 0xE25822;
static final int plantCol = 0x76a912;
//Particle Types
static final int P_SAND = 1;
static final int P_WATER = 2;
static final int P_STEEL = 3;
static final int P_OIL = 4;
static final int P_DIRT = 5;
static final int P_FIRE = 6;
static final int P_PLANT = 7;
static final int P_NUM = 8; //numParticleTypes

//________________________Element Interface and Particle Class___________________________

/**Element interface - implemented by each type of Particle */
interface Element {
  int flags = 0; 
  int type = 0;
  
  // Updates particle movement and reaction
  void Update (Particle p, int x, int y, List<Particle> particles, Particle[][] pmap);
  //Drawing method
  int Draw (Particle p, int x, int y, Particle[][] pmap);
}

/**Particle class - used by the Particle Type classes implementing the Element interface*/
class Particle {
  int x, y, life, flags;
  int type;
  
  // Move a particle to a new place forcefully
  void moveTo(int x, int y, Particle[][] pmap) {
    if (x > 0 && x < width  &&
        y > 0 && y < height && 
        pmap[x][y] == null) {
      pmap[this.x][this.y] = null;
      this.x = x;
      this.y = y;
      pmap[x][y] = this;
    }
  }
  
  // Creates a particle
  public Particle (int x, int y, int type) {
   this.x = x; 
   this.y = y; 
   this.type = type;
  } 
}
//___________________________________PHYSICS METHODS____________________________________

/** Dictates the falling behavior of solid particles*/
public void solidFall(Particle p, int x, int y) {
  Random rnd = new Random();
  Particle q;
  q = pmap[x][y+1];
  if (q == null){
      p.moveTo(x, y+1, pmap);
  }
  else {
    int i = rnd.nextInt(1);
    switch(i) {
      case 0:
      p.moveTo(x+1, y+1, pmap);
      case 1:
      p.moveTo(x-1, y+1, pmap);
    }
  }
}

/**Dictates the falling behavior of liquid particles*/
public void fluidFall(Particle p, int x, int y) {
  Random rand = new Random();
  if (x > 594 || x < 5) {
    solidFall(p,x,y);
  }
  else {
    Particle q, r, s, t, u, v, w, a, b, c, d;
    q = pmap[x][y+1];
    r = pmap[x+1][y+1];
    s = pmap[x-1][y+1];
    t = pmap[x+2][y+1];
    u = pmap[x-2][y+1];
    v = pmap[x+3][y+1];
    w = pmap[x-3][y+1];
    a = pmap[x+4][y+1];
    b = pmap[x-4][y+1];
    c = pmap[x+5][y+1];
    d = pmap[x-5][y+1];
    //more cases, more fluid-like
    if (q == null){
      p.moveTo(x, y+1, pmap);
      return;
    }
    else if (r == null && s != null) {
      p.moveTo(x+1, y+1, pmap);
    }
    else if (s == null && r != null) {
      p.moveTo(x-1, y+1, pmap);
    }
    else if (t == null && u != null) {
      p.moveTo(x+2, y+1, pmap);
    }
    else if (u == null && t != null) {
      p.moveTo(x-2, y+1, pmap);
    }
    else if (v == null && w != null) {
      p.moveTo(x+3, y+1, pmap);
    }
    else if (w == null && v != null) {
      p.moveTo(x-3, y+1, pmap);
    }
    else if (a == null && b != null) {
      p.moveTo(x+4, y+1, pmap);
    }
    else if (b == null && a != null) {
      p.moveTo(x-4, y+1, pmap);
    }
    else if (c == null && d != null) {
      p.moveTo(x+5, y+1, pmap);
    }
    else if (d == null && c != null) {
      p.moveTo(x-5, y+1, pmap);
    }
    //add more cases here
    else{
      if (x < 598 && y < 598){
        int i = rand.nextInt(9);
        int j;
        if (i == 0){
          j = -1;
        }
        if (i == 1){
          j = 1;
        }
        if (i == 2) {
          j = -2;
        }
        if (i == 3) {
          j = 2;
        }
        if (i == 4) {
          j = 3;
        }
        if (i == 5) {
          j = -3;
        }
        if (i == 6) {
          j = 4;
        }
        if (i == 7) {
          j = -4;
        }
        if (i == 8) {
          j = 5;
        }
        else {
          j = -5;
        }
        //add more cases here
        p.moveTo(x+j, y, pmap);
      }
    }
  }
}

///** Dictates Combustion reaction between oil and fire */
//public void checkCombustion(Particle p, int x, int y, Particle[][] pmap) {
//  if (pmap != null) {
//  if (p.type == P_OIL) {
//    if (pmap[x+1][y].type == P_FIRE || pmap[x][y].type == P_FIRE || pmap[x-1][y].type == P_FIRE ||
//    pmap[x+1][y+1].type == P_FIRE || pmap[x][y+1].type == P_FIRE || pmap[x-1][y+1].type == P_FIRE ||
//    pmap[x+1][y-1].type == P_FIRE || pmap[x][y-1].type == P_FIRE || pmap[x-1][y-1].type == P_FIRE) {
//      p = new Particle(x, y, P_FIRE);
//    }
//    else {
//      return;
//    }
//  }
//  else {
//    return;
//  }
//  }
//}

///** Dictates Growth reaction between dirt and water */
//public void checkGrowth(Particle p, int x, int y, Particle[][] pmap) {
//  if (pmap != null) {
//  if (p.type == P_DIRT) {
//    if (pmap[x+1][y].type == P_WATER || pmap[x][y].type == P_WATER || pmap[x-1][y].type == P_WATER ||
//    pmap[x+1][y+1].type == P_WATER || pmap[x][y+1].type == P_WATER || pmap[x-1][y+1].type == P_WATER ||
//    pmap[x+1][y-1].type == P_WATER || pmap[x][y-1].type == P_WATER || pmap[x-1][y-1].type == P_WATER) {
//      p = new Particle(x, y, P_PLANT);
//    }
//    else {
//      return;
//    }
//  }
//  else {
//    return;
//  }
//  }
//}

//_________________________________PARTICLE TYPES_______________________________________
/** Sand Particle */
public class Sand implements Element {
  public Sand() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    if (y > 598){ //y-bound
      return;
    }
    else {
      solidFall(p, x, y); //falls like solid particle
    }
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return sandCol; //particle color
  }
}

/** Water Particle */
public class Water implements Element {
  public Water() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    if (y > 598){
      return;
    }
    else {
        fluidFall(p, x, y); //falls like liquid particle
    }
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return waterCol; //particle color
  }
}

/** Steel Particle */
public class Steel implements Element {
  public Steel() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    //solid, can float, no falling physics needed
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return steelCol; //particle color
  }
}

/** Oil Particle */
public class Oil implements Element {
  public Oil() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    //checkCombustion(p, x, y, pmap);
    if (y > 598){
      return;
    }
    else {
      fluidFall(p, x, y); //falls like liquid particle
    }
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return oilCol; //particle color
  }
}

/** Dirt Particle */
public class Dirt implements Element {
  public Dirt() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    if (y > 598){ //y-bound
      return;
    }
    else {
      solidFall(p, x, y); //falls like solid particle
    }
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return dirtCol; //particle color
  }
}

/** Fire Particle */
public class Fire implements Element {
  public Fire() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    //can float, no falling physics needed
    //needs flame animation (hovers only while mouse is pressed, then fades)
  }

  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return fireCol; //particle color
  }
}

/** Plant Particle */
public class Plant implements Element {
  public Plant() {
  }
  void Update (Particle p, int x, int y, List<Particle> ps, Particle[][] pmap) {
    //checkGrowth(p, x, y, pmap);
    //can float, no falling physics needed
  }
  int Draw (Particle p, int x, int y, Particle[][] pmap) {
    return plantCol; //particle color
  }
}

//__________________________________BUTTON CLASS________________________________________
public class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  //CDraws rectangle button with centered text
  void Draw() {
    fill(218);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
  //Allows program to detect when mouse is over the button
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}

//__________________________________GAME SET UP_________________________________________

//Setting default booleans
boolean paused = false, drawing = false, deleting = false;
//Setting default brush values
int colstate = 0, brushsize = 5, brushstate = P_SAND;
//Setting variables
List<Particle> particles; 
List<Element> elements;
Particle[][] pmap;
//Tips String
String tipsString;
//Buttons
Button sandButton, waterButton, steelButton, oilButton, dirtButton, fireButton, plantButton;
/**Sets up user interface, initializes variables*/
void setup () {
  size(800, 600, P2D); //windowsize
  background(0);
  noStroke();
  fill(0, 0, 0);
  
  tipsString = 
  "Click a button to select an element" + "\n" + 
  "Left-click to create particles" + "\n" + 
  "Right-click to delete particles" + "\n" +
  "Scroll up/down to change brush size" + "\n" +
  "Spacebar to pause the action" + "\n" +
  "Certain elements have different behaviors" + "\n" +
  "Experiment and enjoy!";
  
  particles = new ArrayList<Particle>();
  elements = new ArrayList<Element>(P_NUM);
  pmap = new Particle[width][height];
  
  // add new elements here for cross-referencing
  elements.add(0, null);
  elements.add(P_SAND, new Sand());
  elements.add(P_WATER, new Water());
  elements.add(P_STEEL, new Steel());
  elements.add(P_OIL, new Oil());
  elements.add(P_DIRT, new Dirt());
  elements.add(P_FIRE, new Fire());
  elements.add(P_PLANT, new Plant());
  
  //creates buttons]
  sandButton = new Button("sand", 600, 0, 100, 100);
  waterButton = new Button("water", 700, 0, 100, 100);
  steelButton = new Button("steel", 600, 100, 100, 100);
  oilButton = new Button("oil", 700, 100, 100, 100);
  dirtButton = new Button("dirt", 600, 200, 100, 100);
  fireButton = new Button("fire", 700, 200, 100, 100);
  plantButton = new Button("plant", 600, 300, 100, 100);
}

//___________________________DRAW + ACTION METHODS_______________________________________
/**Drawing method*/
void draw () {
  background(0,0,0);
  
  //Title
  text("WELCOME TO ELEMENTALIST SANDBOX", 300, 20);
  //Tips (middle)
  text(tipsString, 300, 300);
  
  //Buttons
  sandButton.Draw();
  waterButton.Draw();
  steelButton.Draw();
  oilButton.Draw();
  dirtButton.Draw();
  fireButton.Draw();
  plantButton.Draw();
  
  // Brushing
  if (drawing) {
    for (int sy = (int) - Math.ceil(brushsize/2) ; 
             sy <= Math.floor(brushsize/2) ; sy++) {
      for (int sx = (int) -Math.ceil(brushsize/2); 
               sx<=Math.floor(brushsize/2); sx++) {
        if (mouseX+sx > 0 && mouseX+sx < width && 
            mouseY+sy > 0 && mouseY+sy < height) {
              
          Particle p = new Particle(mouseX+sx, mouseY+sy, brushstate);
          particles.add(p);
          // now the topmost particle in the pmap array
          pmap[mouseX+sx][mouseY+sy] = p; 
        }
      }      
    }
  }
  // Deleting
  else if (deleting) {
    for (int sy = (int) - Math.ceil(brushsize/2) ; 
             sy <= Math.floor(brushsize/2) ; sy++) {
      for (int sx = (int) -Math.ceil(brushsize/2); 
               sx<=Math.floor(brushsize/2); sx++) {
        if (mouseX+sx > 0 && mouseX+sx < width && 
            mouseY+sy > 0 && mouseY+sy < height) {
          if (pmap[mouseX+sx][mouseY+sy] == null) continue;
          
          particles.remove(particles.indexOf(pmap[mouseX+sx][mouseY+sy]));
          pmap[mouseX+sx][mouseY+sy] = null;
        }
      }      
    }
  }
  // Particle update
  if (!paused && particles.size() > 0) {
    for (Particle p : particles) {
      if (p.type > 0) {
        elements.get(p.type).Update(p, p.x, p.y, particles, pmap);
      }
    }
  }
  // Drawing
  for (int y=0;y<height;y++) {
    for (int x=0;x<width;x++) {
      if (pmap[x][y] == null)
        continue;
      colstate = elements.get(pmap[x][y].type).Draw(pmap[x][y], x, y, pmap);
      fill((colstate>>16)&0xFF, (colstate>>8)&0xFF, colstate&0xFF);
      rect(x, y, 1, 1);
    }
  }
}
/** Detects key pressed */
void keyPressed () {
  switch (key) {
    case ' ': //spacebar activates pause
      paused = !paused;
      break;
  }
}
/** Mouse methods*/
void mousePressed () {
  if (mouseButton == LEFT){
    drawing = true;
    //detects if mouse is over button then changes element if clicked accordingly
    if (sandButton.MouseIsOver()){
      brushstate = P_SAND;
    }
    if (waterButton.MouseIsOver()){
      brushstate = P_WATER;
    }
    if (steelButton.MouseIsOver()){
      brushstate = P_STEEL;
    }
    if (oilButton.MouseIsOver()){
      brushstate = P_OIL;
    }
    if (dirtButton.MouseIsOver()){
      brushstate = P_DIRT;
    }
    if (fireButton.MouseIsOver()){
      brushstate = P_FIRE;
    }
    if (plantButton.MouseIsOver()){
      brushstate = P_PLANT;
    }
  }
  else if (mouseButton == RIGHT){
    deleting = true;
  }
}
void mouseReleased () {
  if (mouseButton == LEFT)
    drawing = false;
  else if (mouseButton == RIGHT) 
    deleting = false;
}
void mouseWheel (MouseEvent evt) {
  float e = evt.getAmount();
  if (e < 0)
    brushsize += 2; 
    
  else if (e > 0 && brushsize-2>1)
    brushsize -= 2;
  
  // Visual indicator of about how large the brush is.
  stroke(170);
  fill(0, 0, 0, 0);
  rect(mouseX-(brushsize/2), 
       mouseY-(brushsize/2), 
       brushsize,brushsize); 
  noStroke();
}