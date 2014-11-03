import java.lang.reflect.*;

public class CategoricalView {
  Canvas canvas;
  HashMap<String,Integer> protocolStat;
  HashMap<String,Integer> operationStat;
  HashMap<String,Integer> syslogStat;
  IntList colors;
  StringList mouseOverBar;
  HashMap<String, ArrayList<String>> selected;
  int num_selected;
  String hover_name;
  String hover_value;
  boolean hovering;

  public CategoricalView (Controller controller, Canvas canvas) {
    this.canvas = canvas;
    this.protocolStat = controller.getCategoryStat("protocol", false);
    this.operationStat = controller.getCategoryStat("operation", false);
    this.syslogStat = controller.getCategoryStat("syslog", false);
    colors = new IntList();
    colors.append((Integer) color(78,179,221));
    colors.append((Integer) color(168,221,181));
    colors.append((Integer) color(213,177,79));
    this.mouseOverBar = new StringList();
    this.mouseOverBar.append("null");
    this.mouseOverBar.append("null");
    this.selected = new HashMap<String, ArrayList<String>>();
    this.hover_name = "";
    this.hover_value = "";
    this.hovering = false;
  }

  void useSelected()
  {
    this.protocolStat = controller.getCategoryStat("protocol", true);
    this.operationStat = controller.getCategoryStat("operation", true);
    this.syslogStat = controller.getCategoryStat("syslog", true);
  }

  void useAll()
  {
    this.protocolStat = controller.getCategoryStat("protocol", false);
    this.operationStat = controller.getCategoryStat("operation", false);
    this.syslogStat = controller.getCategoryStat("syslog", false);
  }

  void update() {
    this.hovering = false;
    this.mouseOverBar.set(0,null);
    this.mouseOverBar.set(1,null);
    pushMatrix();
    translate(this.canvas.x, this.canvas.y);
    fill(255);
    stroke(0);
    //rect(0, 0, this.canvas.w, this.canvas.h);
    fill(10);
    selected = new HashMap<String, ArrayList<String>>();
    translate(this.canvas.w*0.05, 0);
    drawStat(operationStat, this.canvas.w*0.3, this.canvas.h, "Operation");
    translate(this.canvas.w*0.3, 0);
    drawStat(syslogStat, this.canvas.w*0.3, this.canvas.h, "Syslog priority");
    translate(this.canvas.w*0.3, 0);
    drawStat(protocolStat, this.canvas.w*0.3, this.canvas.h, "Protocol");

    //println("this.mouseOverBar: "+this.mouseOverBar);
    popMatrix();
    if (mode == 0 && !this.hovering && hover_name != "") {
       hover_name = "";
       hover_value = "";
       print("Resetting\n");
       controller.setSelectedCategorical(selected);
    }
  }

 void drawSelections()
 {
   for (int i = 0; i < canvas.selections.size(); i++) {
     canvas.selections.get(i).drawRect(100);
   } 
 }

  void drawStat(HashMap<String,Integer> stat, float w, float h, String title) {
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
      color c = col.get(0);
      col.remove(0);

      fill(c);
      float h_part = h_bar*(Integer)entry.getValue()/sum;

      float tmpX = mouseX - screenX(0, 0);
      float tmpY = mouseY - screenY(0, 0);
      if (tmpX >= 0 && tmpX <= w_bar &&
          tmpY >= 0 && tmpY <= h_part) {
        this.mouseOverBar.set(0,title);
        this.mouseOverBar.set(1,(String)entry.getKey());
        if (mode == 0) {
          fill(255, 255, 0);
          this.hovering = true;
          ArrayList<String> l = new ArrayList<String>();
          l.add((String)entry.getKey());
          selected.put(title, l);
          if (title != hover_name || (String)entry.getKey() != hover_value) {
            print("New selection!\n");
            hover_name = title;
            hover_value = (String)entry.getKey();
            controller.setSelectedCategorical(selected);
          }
        }
        
      }
      rect(0, 0, w_bar, h_part);
      fill(255);
      text((String)entry.getKey(), w_bar/2, min(12.0, h_part));

      translate(0, h_part);
    }

    popMatrix();
  }


}

