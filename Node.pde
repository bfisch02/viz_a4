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
 boolean selected;
 
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
   this.selected = false;
 }
 
 void addEdge(Node dest, Firewall data)
 {
   Edge curEdge = edgeMap.get(dest.getId());
   if (curEdge == null) {
     curEdge = new Edge(this, dest, c, data);
     edgeMap.put(dest.getId(), curEdge);
     print("destID: " + dest.getId() + "\n");
     edges.add(curEdge);
   } else {
     curEdge.addNew(data); 
   }
 }
 
 void drawNode()
 {
   fill(0, 0, 255);
   if (mode == 0 && mouseOver()) {
     fill(255, 255, 0);
     selected = true;
   } else if (mode == 1 && c.selections.size() > 0 && checkSelections()) {
     fill(255, 255, 0);
     selected = true;
   } else {
     selected = false; 
   }
   stroke(0);
   ellipse(c.x + x, c.y + y, radius * 20, radius * 20); 
   textAlign(CENTER);
 }
 
 boolean checkSelections()
 {
   Canvas cur;
   for (int i = 0; i < c.selections.size(); i++) {
     cur = c.selections.get(i);
     
     if (cur.covers(c.x + x, c.y + y)) {
       return true; 
     }
   } 
   return false;
 }
 
 void drawNodeName()
 {
   fill(255, 0, 0); 
   textSize(12);
   text(id, c.x + x, c.y + y + 5);
 }
 
 boolean reset(boolean pressed, boolean dragged)
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
 
 void update(float dampFactor, float t)
 {
    velocityX *= dampFactor;
    velocityY *= dampFactor;
    accelerationX = forceX / mass;
    accelerationY = forceY / mass;
    velocityX += accelerationX * t;
    velocityY += accelerationY * t;
    x += velocityX * t;
    y += velocityY * t;
 }
 
 boolean isSelected()
 {
   return selected; 
 }
 
 String getId()
 {
   return id; 
 }
 
 float getMass()
 {
   return mass; 
 }
 
 float distance(Node n)
 {
   return sqrt(pow((y - n.y), 2) + pow((x - n.x), 2));
 }
 
 void applyForce(float fx, float fy)
 {
   forceX += fx;
   forceY += fy;
 }
 
 boolean mouseOver()
 {
   float diff_x = x - mouseX;
   float diff_y = y - mouseY;
   float distance = sqrt(diff_x * diff_x + diff_y * diff_y);
   return distance < (radius * 10);
 }
 
 float getEnergy()
 {
   float velocity = sqrt(velocityX * velocityX + velocityY * velocityY);
   return .5 * mass * velocity * velocity; 
 }
 
 float xForce()
 {
   float outOfBounds = 0;
   if (x < c.x) {
     outOfBounds = c.w * 50; 
   } else if (x > c.w) {
     outOfBounds = c.w * -50; 
   }
   return outOfBounds + c.w / 2 - x;
 }
 
 float yForce()
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
