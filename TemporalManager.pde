import java.util.Collections;
import java.util.Comparator;

public class TemporalManager {
 Canvas c;
 ArrayList<RectNode> rects;
 HashMap<String, RectNode> RectMap;
 ArrayList<String> SP;
 HashMap<String,Integer> SPMap;
 ArrayList<String> time;
 HashMap<String,Integer> timeMap;
 int num_SP,num_time;
 int Max_Freq;
 

 
 Controller controller;
 ArrayList<Firewall> data;
 
 TemporalManager(Controller controller, Canvas c)
 {
   this.c = c;
   this.controller = controller;
   initializeData(controller.getAllData());
   Max_Freq = 1;
 } 
 

 void initializeData(ArrayList<Firewall> d) {
 
   this.data = d;
   rects = new ArrayList<RectNode>();
   RectMap = new HashMap<String, RectNode>();  
   Firewall cur;
   RectNode cur_rect;
   for (int i = 0; i < this.data.size(); i++) {
     cur = this.data.get(i);
     cur_rect = RectMap.get(cur.sourcePort+","+cur.time);
     if(cur_rect == null) {
       cur_rect = new RectNode(cur.sourcePort, cur.time, c);
       rects.add(cur_rect);
       RectMap.put(cur_rect.get_ID(), cur_rect);
     }
     else{
       cur_rect.Add_Freq();
     }
   
   }
   
   for(RectNode node: rects){//set Max_Freq
     if(node.get_freq() > Max_Freq){
       Max_Freq = node.get_freq();
     }
   }
   
  
   //get sourceports into SP arraylist
   Integer freq;
   SP = new ArrayList<String>();
   SPMap = new HashMap<String,Integer>();
   for(int i=0; i< this.data.size(); i++){
     cur = this.data.get(i);
     freq = SPMap.get(cur.sourcePort);
     if(freq == null){
       SP.add(cur.sourcePort);
       SPMap.put(cur.sourcePort,1);
     }
   }
   
   

   
      Collections.sort(SP, new Comparator<String>() {
        @Override
        public int compare(String s1, String s2)
        {
            String sp1_lower = s1.split(":")[0];
            String sp2_lower = s2.split(":")[0];
            return sp1_lower.compareTo(sp2_lower);
        }
    });
 
   for(String x:SP){
     
     
   }
   
  num_SP = SP.size();
//get times into time arraylist

   time = new ArrayList<String>();
   timeMap = new HashMap<String,Integer>();
   for(int i=0; i< this.data.size(); i++){
     cur = this.data.get(i);
     freq = SPMap.get(cur.time);
     if(freq == null){
       timeMap.put(cur.time,1);
     }
   }
   int i = 0;
   for ( String key : timeMap.keySet() ) {
    time.add(key);
}
  num_time = time.size();
  
  
  
     Collections.sort(time, new Comparator<String>() {
        @Override
        public int compare(String s1, String s2)
        {
            String s1_total = s1.split(":")[0]+s1.split(":")[1]+s1.split(":")[2];
            String s2_total = s2.split(":")[0]+s2.split(":")[1]+s2.split(":")[2];
            return s1_total.compareTo(s2_total);
        }
    });
   
   

  /* for(String x: time){
     print(x);
   }*/

   drawRects();
  

 }

void drawRects()
{
  int snum=SP.size();
  int tnum=0;
  for(String s: SP){
    snum-=1;
    tnum = time.size();
    for(String t: time){
      tnum-=1;
      RectNode temp = RectMap.get(s+","+t);
      if(temp!= null){
        temp.drawRect(snum,tnum,num_SP,num_time,Max_Freq);   
      }
    else{
      temp = new RectNode(s,t,c);
      temp.drawRect(snum,tnum,num_SP,num_time,Max_Freq);
    }
  
  } 

 }
}
int get_num_SP(){
  return num_SP;
}

int get_num_time(){
  return num_time;
}

void drawTable(){

   int i=0;
   for(String s: SP){
//   for(int i=0; i<num_SP; i++){
   fill(220,220,220);
   rect(c.x, c.y + c.h / 15 +(i*c.h / 27), c.w / 20, c.h / 27); // 40 to 50
   fill(0,0,0);
   textSize(c.w / 150);
   text(s,c.x + c.w/40,c.y+c.h / 15 +((i+1)*c.h / 27 - 3));
   i++;
   }
   i=0;

for(String t: time){
//   for(int i=0; i<num_time; i++){
     fill(220,220,220);
     rect(c.x+ c.w / 20 + i*(c.w / 34),c.y+c.h / 15+((num_SP) * c.h / 27),c.w / 34, c.h / 27);// 30 to 40
     fill(0,0,0);
     textSize(c.w / 150);
     text(t,c.x+ c.w / 20 + i*(c.w / 34) + c.w/68, c.y+c.h / 15+((num_SP) * c.h / 27 + c.h / 54 + 2));
     
     
     i++;
   }
   

   drawRects();
 }
   
 

 
}
