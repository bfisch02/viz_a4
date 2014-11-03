ArrayList<Firewall> data;
Controller controller;
Canvas network_canvas;
Canvas temporal_canvas;
Canvas categorical_canvas;
Canvas settings_canvas;
Canvas settings_button;
float W_SPLIT = .7;
float H_SPLIT1 = .2;
float H_SPLIT2 = .4;
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
boolean selection_made = false;
boolean mode_changed = false;

void setup()
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

void draw()
{
  //background(255);
  updateCanvases();
  handleSelection();

  network_model.simulate(false, false);
  settings_canvas.drawRect(240);
  temporal_canvas.drawRect(230);
  // categorical_canvas.drawRect(220);
  categoricalView.update();
  // categorical_canvas.drawRect(150);
  drawMode();
  selection_made = false;
  mode_changed = false;
}

void updateCanvases()
{
  network_canvas.update(0, 0, W_SPLIT * width, (H_SPLIT1 + H_SPLIT2) * height);
  settings_canvas.update(W_SPLIT * width, 0, (1 - W_SPLIT) * width, H_SPLIT1 * height);
  settings_button.update(settings_canvas.x + settings_canvas.w / 4, settings_canvas.y + settings_canvas.h / 4,
                         settings_canvas.w / 2, settings_canvas.h / 2);
  categorical_canvas.update(W_SPLIT * width, H_SPLIT1 * height, (1 - W_SPLIT) * width, H_SPLIT2 * height);
  temporal_canvas.update(0, (H_SPLIT1 + H_SPLIT2) * height, width, (1 - (H_SPLIT1 + H_SPLIT2)) * height);
  network_canvas.drawRect(255);
  settings_canvas.drawRect(255);
  categorical_canvas.drawRect(255);
  temporal_canvas.drawRect(255);
  
}

void drawMode()
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

void handleSelection()
{
  if (mousedown && mode != 0 && selecting) {
    stroke(180);
    fill(200);
    rect(selectionX, selectionY, selectionW, selectionH);
  } 
}

void mouseClicked()
{
  if (settings_button.mouseOver()) {
    mode = (mode + 1) % 3; 
    mode_changed = true;
  }
}

void mousePressed()
{
  print("MOUSEPRESSED\n");
  mousedown = true;
  selecting = true;
  if (mode != 0) {
    if (network_canvas.mouseOver()) {
      selectionMode = 0; 
      temporal_canvas.clearSelections();
      categorical_canvas.clearSelections();
    } else if (temporal_canvas.mouseOver()) {
      selectionMode = 1; 
      network_canvas.clearSelections();
      categorical_canvas.clearSelections();
    } else if (categorical_canvas.mouseOver()) {
      selectionMode = 2; 
      network_canvas.clearSelections();
      temporal_canvas.clearSelections();
    } else {
      selectionMode = -1; 
      selecting = false;
      network_canvas.clearSelections();
      temporal_canvas.clearSelections();
      categorical_canvas.clearSelections();
    }
    selectionX = mouseX;
    selectionY = mouseY;
    selectionW = 0;
    selectionH = 0;
  }
}

void mouseReleased()
{
  if (mode != 0 && selecting) {
    selection_made = true;
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

void mouseDragged()
{
  if (mode != 0 && selecting && 
      network_canvas.mouseOver() && selectionMode == 0 ||
      temporal_canvas.mouseOver() && selectionMode == 1 ||
      categorical_canvas.mouseOver() && selectionMode == 2) {
    selectionW = mouseX - selectionX;
    selectionH = mouseY - selectionY;
  }
}

ArrayList<Firewall> getData(String file)
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
