public class RectNode {
 ArrayList<Edge> edges;
 String time,id;
 String source_port;
 float x,y,w,h;
 int freq;
 Canvas c;
 boolean selected;

 
 RectNode(String source_port, String time, Canvas c){
   this.source_port = source_port;
   this.time = time;
   this.c = c;
   this.id = source_port+","+time;
   freq = 0;
   x=10;
   y=30;
   this.selected = false;
  
 }
 
 void Add_Freq(){
  freq+=1; 
 }
 
 int get_freq(){
   return freq;
 }
 
 String get_time(){
   return time;
 }
 
 String get_ID(){
   return id;
 }
 
 String get_sp(){
   return source_port;
 }
 
boolean drawRect(int s,int t, int num_SP, int num_time, int max){
 /* print(s);
  print(" ");
 print(t); 
 print("    ");*/
 float ratio = freq/float(max);
 
 float r_sub = ratio* 255;
 float r_val = 255.0 - r_sub;
 
 float g_sub = ratio * 76;
 float g_val = 255 - g_sub;
  
  float red = 255 - ratio * 255;
  float green = 255 - ratio * 180;
 fill(red,green,255);
  //rect(c.x+10+(t*40),c.y+20+(s*10),40,10);
  
  //rect(c.x, c.y + c.h / 15 +(i*c.h / 15), c.w / 20, c.h / 15); // 40 to 50
  float my_x = c.x+ c.w / 20 + t*(c.w / 34);
  float my_y = c.y+c.h / 15+((num_SP - 1 - s) * c.h / 15);
  float my_w = c.w / 34;
  float my_h = c.h / 15;
  boolean rVal = false;
  if (mode == 0) {
    if (mouseX > my_x && mouseX < my_x + my_w && mouseY > my_y && mouseY < my_y + my_h) {
      fill(255, 255, 0);
      rVal = true;
    }
  } else if (mode != 0) {
    Canvas cur;
    for (int i = 0; i < c.selections.size(); i++) {
      cur = c.selections.get(i); 
      if (my_x + my_w / 2 > cur.x && my_x + my_w / 2 < cur.x + cur.w &&
          my_y + my_h / 2 > cur.y && my_y + my_h / 2 < cur.y + cur.h) {
        fill(255, 255, 0);
        rVal = true;  
      }
    }
  }
  rect(my_x, my_y, my_w, my_h);
  return rVal;
  
  
  //print("hey");
    
 }
 


 
 /*
 boolean mouseOver()
 {
   float diff_x = x - mouseX;
   float diff_y = y - mouseY;
   float distance = sqrt(diff_x * diff_x + diff_y * diff_y);
   return distance < (radius * 10);
 }
 
 */
 
 
  
}
