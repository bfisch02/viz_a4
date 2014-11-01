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
   this.ks = .7;
 }
 
 void incrementThickness()
 {
   this.thickness += 1; 
 }
 
 void drawEdge(int thickMin, int thickMax)
 {
   fill(0);
   float percent = (float)(this.thickness - thickMin) / (float)(thickMax - thickMin);
   
   strokeWeight(percent * 5);
   stroke(0, 255, 0);
   curve(b.x, b.y, a.x, a.y, b.x, b.y, a.x, a.y); 
 }
 
 void applyForce()
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
