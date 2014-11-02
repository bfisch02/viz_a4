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
   this.dampFactor = .95;
   this.wallFactor = .025;
   this.t = .12;
   this.first = true;
   this.threshold = .5;
   this.prev_width = width;
   this.prev_height = height;
   
   this.controller = controller;
   initializeData(controller.getAllData());
 } 
 
 void initializeData(ArrayList<Firewall> d) {
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
 
 void setMinMaxEdge()
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

 void simulate(boolean pressed, boolean dragged)
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
 
 boolean initialize_nodes(boolean pressed, boolean dragged)
 {
   boolean rVal = false;
   for (int i = 0; i < nodes.size(); i++) {
     if (nodes.get(i).reset(pressed, dragged)) {
       rVal = true; 
     }
   } 
   return rVal;
 }
 
 void setForces()
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
 
 float drawEnergy(float energy)
 {
   fill(0);
   textAlign(LEFT);
   textSize(c.w / 40);
   text("Kinetic energy: " + (str(Math.round(energy * 100) / (float)100)) + "\n", 5 * c.w / 8, c.h - c.h / 10);
   return energy;
 }
 
 float getEnergy()
 {
   float energy = 0;
   for (int i = 0; i < nodes.size(); i++) {
     energy += nodes.get(i).getEnergy(); 
   }
   if (energy < threshold) return 0;
   return energy;
 }
 
 void applyColoumb(Node a, Node b)
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
 
 void drawEdges()
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
 
 void drawNodes()
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
