import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.lang.reflect.*; 
import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class a4 extends PApplet {

ArrayList<Firewall> data;
Controller controller;
Canvas network_canvas;
Canvas temporal_canvas;
Canvas categorical_canvas;
Canvas settings_canvas;
Canvas settings_button;
float W_SPLIT = .7f;
float H_SPLIT1 = .2f;
float H_SPLIT2 = .4f;
int INIT_WIDTH = 1000;
int INIT_HEIGHT = 700;
NodeManager network_model;
int mode = 0;
boolean selecting;
float selectionX;
float selectionY;
float selectionW;
float selectionH;
int selectionMode = -1;
boolean mousedown = false;
CategoricalView categoricalView;

public void setup()
{
   frame.setResizable(true);
   size(INIT_WIDTH, INIT_HEIGHT);
   data = getData("data_aggregate.csv");
   controller = new Controller(data);
   textAlign(CENTER);
   network_canvas = new Canvas(0, 0, W_SPLIT * width, (H_SPLIT1 + H_SPLIT2) * height);
   settings_canvas = new Canvas(W_SPLIT * width, 0, (1 - W_SPLIT) * width, H_SPLIT1 * height);
   settings_button = new Canvas(settings_canvas.x + settings_canvas.w / 4, settings_canvas.y + settings_canvas.h / 4,
                                settings_canvas.w / 2, settings_canvas.h / 2);
   categorical_canvas = new Canvas(W_SPLIT * width, H_SPLIT1 * height, (1 - W_SPLIT) * width, H_SPLIT2 * height);
   temporal_canvas = new Canvas(0, (H_SPLIT1 + H_SPLIT2) * height, width, (1 - (H_SPLIT1 + H_SPLIT2)) * height);
   network_model = new NodeManager(controller, network_canvas);
   categoricalView = new CategoricalView(controller, categorical_canvas);

}

public void draw()
{
  background(255);
  updateCanvases();
    handleSelection();

  network_model.simulate(false, false);
  settings_canvas.drawRect(240);
  temporal_canvas.drawRect(230);
  // categorical_canvas.drawRect(220);
  categoricalView.update();
  // categorical_canvas.drawRect(150);
  drawMode();
}

public void updateCanvases()
{
  network_canvas.update(0, 0, W_SPLIT * width, (H_SPLIT1 + H_SPLIT2) * height);
  settings_canvas.update(W_SPLIT * width, 0, (1 - W_SPLIT) * width, H_SPLIT1 * height);
  settings_button.update(settings_canvas.x + settings_canvas.w / 4, settings_canvas.y + settings_canvas.h / 4,
                         settings_canvas.w / 2, settings_canvas.h / 2);
  categorical_canvas.update(W_SPLIT * width, H_SPLIT1 * height, (1 - W_SPLIT) * width, H_SPLIT2 * height);
  temporal_canvas.update(0, (H_SPLIT1 + H_SPLIT2) * height, width, (1 - (H_SPLIT1 + H_SPLIT2)) * height);
}

public void drawMode()
{
  String text;
  if (mode == 0) {
    text = "Hover"; 
  } else if (mode == 1) {
    text = "Selection"; 
  } else {
    text = "Filter"; 
  }
  stroke(0);
  fill(200);
  strokeWeight(1);
  Canvas c = settings_button;
  settings_button.drawRect(200);
  fill(0);
  text(text, c.x + c.w / 2, c.y + c.h / 2);
}

public void handleSelection()
{
  if (mousedown && mode != 0 && selecting) {
    stroke(180);
    fill(200);
    rect(selectionX, selectionY, selectionW, selectionH);
  } 
}

public void mouseClicked()
{
  if (settings_button.mouseOver()) {
    mode = (mode + 1) % 3; 
  }
}

public void mousePressed()
{
  print("MOUSEPRESSED\n");
  mousedown = true;
  selecting = true;
  if (mode != 0) {
    if (network_canvas.mouseOver()) {
      selectionMode = 0; 
    } else if (temporal_canvas.mouseOver()) {
      selectionMode = 1; 
    } else if (categorical_canvas.mouseOver()) {
      selectionMode = 2; 
    } else {
      selectionMode = -1; 
      selecting = false;
    }
    selectionX = mouseX;
    selectionY = mouseY;
    selectionW = 0;
    selectionH = 0;
  }
}

public void mouseReleased()
{
  if (mode != 0 && selecting) {
    if (selectionMode == 0) {
      network_canvas.addSelection(selectionX, selectionY, selectionW, selectionH);
    } else if (selectionMode == 1) {
      temporal_canvas.addSelection(selectionX, selectionY, selectionW, selectionH);
    } else if (selectionMode == 2) {
      categorical_canvas.addSelection(selectionX, selectionY, selectionW, selectionH);
    }
  }
  selecting = false;
  mousedown = false;
}

public void mouseDragged()
{
  if (mode != 0 && selecting && 
      network_canvas.mouseOver() && selectionMode == 0 ||
      temporal_canvas.mouseOver() && selectionMode == 1 ||
      categorical_canvas.mouseOver() && selectionMode == 2) {
    selectionW = mouseX - selectionX;
    selectionH = mouseY - selectionY;
  }
}

public ArrayList<Firewall> getData(String file)
{
  ArrayList<Firewall> d = new ArrayList<Firewall>();
  String [] filedata = loadStrings(file);
  int len = filedata.length - 1;
  String [] cur;
   for (int i = 1; i <= len; i++) {
     cur = splitTokens(filedata[i], ",");
     d.add(new Firewall(cur[0], cur[1], cur[2], cur[3],
                        cur[4], cur[5], cur[6], cur[7]));
   }
   return d;
}

public class Canvas {
  float x;
  float y;
  float w;
  float h;
  ArrayList<Canvas> selections;
  
  Canvas(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.selections = new ArrayList<Canvas>();
  } 
  
  public void addSelection(float x, float y, float w, float h)
  {
    selections.add(new Canvas(x, y, w, h));
    print("ADDED SELECTION\n");
  }
  
  public void drawSelections()
  {
    stroke(0, 255, 0);
    for (int i = 0; i < selections.size(); i++) {
      selections.get(i).drawRect(0, 150, 0);
    } 
  }
  
  public void update(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public void drawRect(float val)
  {
    stroke(0);
    fill(val);
    strokeWeight(1);
    rect(x, y, w, h); 
  }
  
  public void drawRect(float v1, float v2, float v3)
  {
    stroke(0);
    fill(v1, v2, v3);
    strokeWeight(1);
    rect(x, y, w, h); 
  }
  
  public boolean mouseOver()
  {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h); 
  }
}


public class CategoricalView {
  Canvas canvas;
  HashMap<String,Integer> protocolStat;
  HashMap<String,Integer> operationStat;
  HashMap<String,Integer> syslogStat;
  IntList colors;


  public CategoricalView (Controller controller, Canvas canvas) {
    this.canvas = canvas;
    this.protocolStat = controller.getCategoryStat("protocol");
    this.operationStat = controller.getCategoryStat("operation");
    this.syslogStat = controller.getCategoryStat("syslog");
    colors = new IntList();
    colors.append((Integer) color(78,179,221));
    colors.append((Integer) color(168,221,181));
    colors.append((Integer) color(213,177,79));
  }

  public void update() {
    pushMatrix();
    translate(this.canvas.x, this.canvas.y);
    fill(255);
    stroke(0);
    rect(0, 0, this.canvas.w, this.canvas.h);
    fill(10);
    translate(this.canvas.w*0.05f, 0);
    drawStat(operationStat, this.canvas.w*0.3f, this.canvas.h, "Operation");
    translate(this.canvas.w*0.3f, 0);
    drawStat(syslogStat, this.canvas.w*0.3f, this.canvas.h, "Syslog priority");
    translate(this.canvas.w*0.3f, 0);
    drawStat(protocolStat, this.canvas.w*0.3f, this.canvas.h, "Protocol");
    popMatrix();
  }

  public void drawStat(HashMap<String,Integer> stat, float w, float h, String title) {
    pushMatrix();
    translate(w/5, h/10);
    fill(0);
    textAlign(CENTER);
    text(title, w*3/10, -5);
    fill(200,100,0);
    float w_bar = w*3/5;
    float h_bar = h*9/10;

    int sum = 0;
    IntList col = this.colors.copy();
    for (int i : stat.values()) {
      sum += i;
    }
    
    for (Map.Entry entry : stat.entrySet()) {
      int c = col.get(0);
      col.remove(0);

      fill(c);
      float h_part = h_bar*(Integer)entry.getValue()/sum;
      rect(0, 0, w_bar, h_part);
      
      fill(255);
      text((String)entry.getKey(), w_bar/2, min(12.0f, h_part));

      translate(0, h_part);
    }

    popMatrix();
  }

  
}
  


class Controller {
  ArrayList<Firewall> full_data;
  ArrayList<Firewall> selected_data;
  
  Controller(ArrayList<Firewall> data) {
    this.full_data = data;
    this.selected_data = null; 
  }
  
  public ArrayList<Firewall> getAllData()
  {
     return full_data;
  }
  
  public ArrayList<Firewall> getSelectedData()
  {
    return selected_data; 
  }

  public HashMap<String,Integer> getCategoryStat(String category) {
    ArrayList<Firewall> allData = this.getAllData();
    HashMap<String,Integer> categoryCnt = new HashMap<String,Integer>();


    for (Firewall f : allData) {
      try {
        Field field = f.getClass().getDeclaredField(category);
        field.setAccessible(true);
        Object obj = field.get(f);
        String key = obj.toString();

        if (categoryCnt.containsKey(key)) {
          int newValue = categoryCnt.get(key) + 1;
          categoryCnt.put(key, newValue);
        } else {
          categoryCnt.put(key, 1);
        }

      } catch (Exception e) {
          println(e);        
      }
    }

    // println(category + " - categoryCnt: "+categoryCnt);

    return categoryCnt;
  }
  
}
public class Edge {
 Node a;
 Node b;
 float len = 100;
 int thickness;
 float ks; // Spring constant
 Canvas c;
 
 
 Edge(Node a, Node b, Canvas c)
 {
   this.a = a;
   this.b = b;
   this.thickness = 1;
   this.c = c;
   this.ks = .7f;
 }
 
 public void incrementThickness()
 {
   this.thickness += 1; 
 }
 
 public void drawEdge(int thickMin, int thickMax)
 {
   fill(0);
   float percent = (float)(this.thickness - thickMin) / (float)(thickMax - thickMin);
   
   strokeWeight(percent * 5);
   stroke(0, 255, 0);
   curve(b.x, b.y, a.x, a.y, b.x, b.y, a.x, a.y); 
 }
 
 public void applyForce()
 {
   float distance = a.distance(b);
   float x = distance - len;
   float force = -1 * ks * x;
   float diff_x = b.x - a.x;
   float diff_y = b.y - a.y;
   float hyp = sqrt(diff_x * diff_x + diff_y * diff_y);
   float forceX = force * diff_x / hyp;
   float forceY = force * diff_y / hyp;
   a.applyForce(-1 * forceX, -1 * forceY);
   b.applyForce(forceX, forceY);
 }
  
}
class Firewall {
  String time;
  String sourceIP;
  String sourcePort;
  String destIP;
  String destPort;
  String syslog;
  String operation;
  String protocol;
  boolean mouseover;
  
  Firewall(String time, String sourceIP, String sourcePort,
           String destIP, String destPort, String syslog,
           String operation, String protocol)
  {
    this.time = time;
    this.sourceIP = sourceIP;
    this.sourcePort = sourcePort;
    this.destIP = destIP;
    this.destPort = destPort;
    this.syslog = syslog;
    this.operation = operation;
    this.protocol = protocol; 
  }
  
  
  
}
public class Node {
 HashMap<String, Edge> edgeMap;
 ArrayList<Edge> edges;
 String id;
 float x;
 float y;
 float radius;
 float mass;
 Canvas c;
 float forceX;
 float forceY;
 float velocityX;
 float velocityY;
 float accelerationX;
 float accelerationY;
 boolean holding;
 
 Node(String id, float mass, Canvas c)
 {
   this.id = id;
   this.mass = mass;
   this.radius = sqrt(mass / PI);
   this.c = c;
   this.x = c.x + (float)(Math.random() * c.w);
   this.y = c.y + (float)(Math.random() * c.h);
   this.forceX = 0;
   this.forceY = 0;
   this.velocityX = 0;
   this.velocityY = 0;
   this.accelerationX = 0;
   this.accelerationY = 0;
   this.holding = false;
   this.edgeMap = new HashMap<String, Edge>();
   this.edges = new ArrayList<Edge>();
 }
 
 public void addEdge(Node dest)
 {
   Edge curEdge = edgeMap.get(dest.getId());
   if (curEdge == null) {
     curEdge = new Edge(this, dest, c);
     edgeMap.put(dest.getId(), curEdge);
     edges.add(curEdge);
   } else {
     curEdge.incrementThickness(); 
   }
 }
 
 public void drawNode()
 {
   fill(0, 0, 255);
   if (mouseOver()) {
     fill(0, 0, 0); 
   }
   stroke(0);
   ellipse(c.x + x, c.y + y, radius * 20, radius * 20); 
   textAlign(CENTER);
 }
 
 public void drawNodeName()
 {
   fill(255, 0, 0); 
   textSize(12);
   text(id, c.x + x, c.y + y + 5);
 }
 
 public boolean reset(boolean pressed, boolean dragged)
 {
   forceX = 0;
   forceY = 0; 
   if (pressed && mouseOver()) {
     this.holding = true;
   } else if (!dragged) {
     this.holding = false; 
   }
   if (this.holding) {
     this.x = mouseX;
     this.y = mouseY; 
     return true;  
   } else {
     return false; 
   }
 }
 
 public void update(float dampFactor, float t)
 {
    velocityX *= dampFactor;
    velocityY *= dampFactor;
    accelerationX = forceX / mass;
    accelerationY = forceY / mass;
    velocityX += accelerationX * t;
    velocityY += accelerationY * t;
    x += velocityX * t;
    y += velocityY * t;
    /*if (x < 0) {
      x = 0;
      velocityX = 0; 
    } else if (x >= width) {
      x = width - 1;
      velocityX = 0; 
    }
    if (y < 0) {
      y = 0;
      velocityY = 0; 
    } else if (y >= height) {
      y = height - 1;
      velocityY = 0; 
    }*/
 }
 
 public String getId()
 {
   return id; 
 }
 
 public float getMass()
 {
   return mass; 
 }
 
 public float distance(Node n)
 {
   return sqrt(pow((y - n.y), 2) + pow((x - n.x), 2));
 }
 
 public void applyForce(float fx, float fy)
 {
   forceX += fx;
   forceY += fy;
 }
 
 public boolean mouseOver()
 {
   float diff_x = x - mouseX;
   float diff_y = y - mouseY;
   float distance = sqrt(diff_x * diff_x + diff_y * diff_y);
   return distance < (radius * 10);
 }
 
 public float getEnergy()
 {
   float velocity = sqrt(velocityX * velocityX + velocityY * velocityY);
   return .5f * mass * velocity * velocity; 
 }
 
 public float xForce()
 {
   float outOfBounds = 0;
   if (x < c.x) {
     outOfBounds = c.w * 50; 
   } else if (x > c.w) {
     outOfBounds = c.w * -50; 
   }
   return outOfBounds + c.w / 2 - x;
 }
 
 public float yForce()
 {
   float outOfBounds = 0;
   if (y < c.y) {
     outOfBounds = c.h * 50; 
   } else if (y > c.h) {
     outOfBounds = c.h * -50; 
   }
   return outOfBounds + c.h / 2 - y;
 }
 
 
  
}
public class NodeManager {
 Canvas c;
 HashMap<String, Node> nodeMap;
 ArrayList<Node> nodes;
 int numEdges;
 float cK; // Coulomb's constant
 float dampFactor;
 float wallFactor;
 float t;
 boolean first;
 float threshold;
 int prev_width;
 int prev_height;
 float NODE_SIZE = 7;
 int thickMin = 0;
 int thickMax = 0;
 
 Controller controller;
 ArrayList<Firewall> data;
 
 NodeManager(Controller controller, Canvas c)
 {
   this.c = c;
   this.cK = 700; // Definitely change this
   this.dampFactor = .95f;
   this.wallFactor = .025f;
   this.t = .12f;
   this.first = true;
   this.threshold = .5f;
   this.prev_width = width;
   this.prev_height = height;
   
   this.controller = controller;
   initializeData(controller.getAllData());
 } 
 
 public void initializeData(ArrayList<Firewall> d) {
   this.data = d;
   nodes = new ArrayList<Node>();
   nodeMap = new HashMap<String, Node>();
   Firewall cur;
   Node curSource;
   Node curDest;
   for (int i = 0; i < this.data.size(); i++) {
      cur = this.data.get(i);
      curSource = nodeMap.get(cur.sourceIP);
      if (curSource == null) {
        curSource = new Node(cur.sourceIP, NODE_SIZE, c);
        nodes.add(curSource);
        nodeMap.put(curSource.getId(), curSource);
      }
      curDest = nodeMap.get(cur.destIP);
      if (curDest == null) {
        curDest = new Node(cur.destIP, NODE_SIZE, c);
        nodes.add(curDest);
        nodeMap.put(curDest.getId(), curDest);
      }
      if (curSource != curDest) curSource.addEdge(curDest);
   }
   setMinMaxEdge();
 }
 
 public void setMinMaxEdge()
 {
   int min = data.size() + 1;
   int max = -1;
   Node curNode;
   Edge curEdge;
   int thickness;
   for (int i = 0; i < nodes.size(); i++) {
     curNode = nodes.get(i);
     for (int j = 0; j < curNode.edges.size(); j++) {
       curEdge = curNode.edges.get(j);
       thickness = curEdge.thickness;
       if (thickness < min) min = thickness;
       if (thickness > max) max = thickness;
     }
   } 
   thickMin = min;
   thickMax = max;
 }

 public void simulate(boolean pressed, boolean dragged)
 {
   float energy = getEnergy();
   boolean dim_changed = false;
   if (width != prev_width || height != prev_height) {
     dim_changed = true;
     prev_width = width;
     prev_height = height; 
   }
   boolean holding = initialize_nodes(pressed, dragged);
   if (first || holding || dim_changed || energy > 0) {
     setForces();
   }
   drawEdges();
   drawNodes();
   //drawEnergy(energy);
   first = false;
 }
 
 public boolean initialize_nodes(boolean pressed, boolean dragged)
 {
   boolean rVal = false;
   for (int i = 0; i < nodes.size(); i++) {
     if (nodes.get(i).reset(pressed, dragged)) {
       rVal = true; 
     }
   } 
   return rVal;
 }
 
 public void setForces()
 {
   Node curA;
   Node curB;
   Edge curEdge;
   
   // Apply coulomb's law
   float coulomb_force;
   for (int i = 0; i < nodes.size(); i++) {
     curA = nodes.get(i);
     for (int j = i + 1; j < nodes.size(); j++) {
       if (i == j) continue;
       curB = nodes.get(j);
       applyColoumb(curA, curB);
     }
     
     // Apply spring forces
     for (int j = 0; j < curA.edges.size(); j++) {
       curEdge = curA.edges.get(j);
       curEdge.applyForce(); 
     }
   }
   
   // Apply wall forces
   float forceX;
   float forceY;
   for (int i = 0; i < nodes.size(); i++) {
     curA = nodes.get(i);
     curA.applyForce(curA.xForce() * wallFactor, 
                     curA.yForce() * wallFactor);
   }
   
   // Update accelerations and velocities
   for (int i = 0; i < nodes.size(); i++) {
     nodes.get(i).update(dampFactor, t); 
   }
   
 }
 
 public float drawEnergy(float energy)
 {
   fill(0);
   textAlign(LEFT);
   textSize(c.w / 40);
   text("Kinetic energy: " + (str(Math.round(energy * 100) / (float)100)) + "\n", 5 * c.w / 8, c.h - c.h / 10);
   return energy;
 }
 
 public float getEnergy()
 {
   float energy = 0;
   for (int i = 0; i < nodes.size(); i++) {
     energy += nodes.get(i).getEnergy(); 
   }
   if (energy < threshold) return 0;
   return energy;
 }
 
 public void applyColoumb(Node a, Node b)
 {
   float distance = a.distance(b);
   float force = cK * a.getMass() * b.getMass() / (distance * distance);
   float diff_x = b.x - a.x;
   float diff_y = b.y - a.y;
   float hyp = sqrt(diff_x * diff_x + diff_y * diff_y);
   float forceX = force * diff_x / hyp;
   float forceY = force * diff_y / hyp;
   a.applyForce(-1 * forceX, -1 * forceY);
   b.applyForce(forceX, forceY);
 }
 
 public void drawEdges()
 {
   Node curNode;
   Edge curEdge;
   for (int i = 0; i < nodes.size(); i++) {
     curNode = nodes.get(i);
     for (int j = 0; j < curNode.edges.size(); j++) {
       curEdge = curNode.edges.get(j);
       curEdge.drawEdge(thickMin, thickMax); 
     }
   } 
 }
 
 public void drawNodes()
 {
   Node cur;
   for (int i = 0; i < nodes.size(); i++) {
     cur = nodes.get(i);
     cur.drawNode();
   }
   for (int i = 0; i < nodes.size(); i++) {
     cur = nodes.get(i);
     cur.drawNodeName();
   }
 }
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a4" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
