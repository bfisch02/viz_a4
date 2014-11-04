import java.util.Collections;
import java.util.Comparator;

public class TemporalManager {
 Canvas c;
 ArrayList<RectNode> rects;
 HashMap<String, RectNode> RectMap;
 ArrayList<String> DP;
 HashMap<String,Integer> DPMap;
 ArrayList<String> time;
 HashMap<String,Integer> timeMap;
 int num_DP,num_time;
 int Max_Freq;
 HashMap<String, ArrayList<String>> selected;
 boolean hovers;
 boolean selecting;
 

 
 Controller controller;
 ArrayList<Firewall> data;
 
 TemporalManager(Controller controller, Canvas c)
 {
   print("Initializing!\n");
   this.c = c;
   this.controller = controller;
   Max_Freq = -1;
   initializeData(controller.getAllData());
   selected = new HashMap<String, ArrayList<String>>();
   this.hovers = false;
   this.selecting = false;
 } 
 
 void useSelected()
 {
   initializeData(controller.getSelectedData()); 
 }

 void initializeData(ArrayList<Firewall> d) {
   //print("CALLED INITIALIZE, data size = " + d.size() + "\n");
   this.Max_Freq = -1;
   this.data = d;
   rects = new ArrayList<RectNode>();
   RectMap = new HashMap<String, RectNode>();  
   Firewall cur;
   RectNode cur_rect;
   for (int i = 0; i < this.data.size(); i++) {
     cur = this.data.get(i);
     cur_rect = RectMap.get(cur.destPort+","+cur.time);
     if(cur_rect == null) {
       cur_rect = new RectNode(cur.destPort, cur.time, c);
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
   
  
   //get destPorts into DP arraylist
   Integer freq;
   DP = new ArrayList<String>();
   DPMap = new HashMap<String,Integer>();
   for(int i=0; i< this.data.size(); i++){
     cur = this.data.get(i);
     freq = DPMap.get(cur.destPort);
     if(freq == null){
       DP.add(cur.destPort);
       DPMap.put(cur.destPort,1);
     }
   }
   
   

   
      Collections.sort(DP, new Comparator<String>() {
        @Override
        public int compare(String s1, String s2)
        {
            String sp1_lower = s1.split(":")[0];
            String sp2_lower = s2.split(":")[0];
            return sp1_lower.compareTo(sp2_lower);
        }
    });
 
   for(String x:DP){
     
     
   }
   
  num_DP = DP.size();
//get times into time arraylist

   time = new ArrayList<String>();
   timeMap = new HashMap<String,Integer>();
   for(int i=0; i< this.data.size(); i++){
     cur = this.data.get(i);
     freq = DPMap.get(cur.time);
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

void drawSelections()
 {
   for (int i = 0; i < c.selections.size(); i++) {
     c.selections.get(i).drawRect(100);
   } 
 }

void drawRects()
{
  selected = new HashMap<String, ArrayList<String>>();
  
  boolean hovering;
  boolean keep_hovering = false;
  int snum=DP.size();
  int tnum=0;
  for(String s: DP){
    snum-=1;
    tnum = 0;
    for(String t: time){
      RectNode temp = RectMap.get(s+","+t);
      if(temp == null){
        temp = new RectNode(s, t, c);

      }
      hovering = temp.drawRect(snum,tnum,num_DP,num_time,Max_Freq);
      if (hovering) {

         ArrayList<String> l = selected.get(t);
         if (l == null) {
           l = new ArrayList<String>(); 
         }
         l.add(s);
         selected.put(t, l);
         if (mode == 0) {
           keep_hovering = true;
           this.hovers = true;
           controller.setSelectedTemporal(selected);
         }
      } 
      tnum+=1;
  
    } 
  }
  if (mode == 0 && this.hovers && keep_hovering == false) {
    this.hovers = false;
    controller.setAll(); 
  } else if (mode == 1) {
    if (selectionMode == 1 && selection_made) {
      controller.setSelectedTemporal(selected);
      selecting = true;
    } else if (selecting && c.selections.size() == 0) {
      print("HERE!\n");
      selecting = false;
      controller.setAll(); 
    }
  }
}
int get_num_DP(){
  return num_DP;
}

int get_num_time(){
  return num_time;
}

void drawTable(){
  
  if (mode_changed) {
    initializeData(controller.getAllData()); 
  }
  if (mode != 0) {
   drawSelections(); 
  }
   int i=0;
   for(String s: DP){
//   for(int i=0; i<num_DP; i++){
   fill(220,220,220);
   rect(c.x, c.y + c.h / 15 +(i*c.h / 15), c.w / 20, c.h / 15); // 40 to 50
   fill(0,0,0);
   textSize(c.w / 150);
   text(s,c.x + c.w/40,c.y+c.h / 15 +((i+1)*c.h / 15 - 3));
   i++;
   }
   i=0;

for(String t: time){
//   for(int i=0; i<num_time; i++){
     fill(220,220,220);
     rect(c.x+ c.w / 20 + i*(c.w / 34),c.y+c.h / 15+((num_DP) * c.h / 15),c.w / 34, c.h / 15);// 30 to 40
     fill(0,0,0);
     textSize(c.w / 150);
     text(t,c.x+ c.w / 20 + i*(c.w / 34) + c.w/68, c.y+c.h / 15+((num_DP) * c.h / 15 + c.h / 30 + 2));
     
     
     i++;
   }
   

   drawRects();
 }
   
 

 
}
