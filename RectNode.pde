public class RectNode {
 ArrayList<Edge> edges;
 String time,id;
 String source_port;
 float x,y,w,h;
 int freq;
 Canvas c;

 
 RectNode(String source_port, String time, Canvas c){
   this.source_port = source_port;
   this.time = time;
   this.c = c;
   this.id = source_port+","+time;
   freq = 0;
   x=10;
   y=30;
  
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
 
void drawRect(int s,int t, int num_SP, int num_time, int max){
 /* print(s);
  print(" ");
 print(t); 
 print("    ");*/
 float ratio = freq/float(max);
 
 float r_sub = ratio* 255;
 float r_val = 255.0 - r_sub;
 
 float g_sub = ratio * 76;
 float g_val = 255 - g_sub;
  
 fill(r_val,g_val,255);
  rect(c.x+10+(t*40),c.y+20+(s*10),40,10);
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
