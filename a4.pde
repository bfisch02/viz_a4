ArrayList<Firewall> data;
Controller controller;
Canvas network_canvas;
Canvas temporal_canvas;
Canvas categorical_canvas;
Canvas settings_canvas;
float W_SPLIT = .7;
float H_SPLIT1 = .2;
float H_SPLIT2 = .4;
int INIT_WIDTH = 1000;
int INIT_HEIGHT = 700;
NodeManager network_model;

void setup()
{
   frame.setResizable(true);
   size(INIT_WIDTH, INIT_HEIGHT);
   data = getData("data_aggregate.csv");
   controller = new Controller(data);
   network_canvas = new Canvas(0, 0, W_SPLIT * width, (H_SPLIT1 + H_SPLIT2) * height);
   settings_canvas = new Canvas(W_SPLIT * width, 0, (1 - W_SPLIT) * width, H_SPLIT1 * height);
   temporal_canvas = new Canvas(W_SPLIT * width, H_SPLIT1 * height, (1 - W_SPLIT) * width, H_SPLIT2 * height);
   categorical_canvas = new Canvas(0, (H_SPLIT1 + H_SPLIT2) * height, width, (1 - (H_SPLIT1 + H_SPLIT2)) * height);
   network_model = new NodeManager(controller, network_canvas);
}

void draw()
{
  background(255);
  network_canvas.update(0, 0, W_SPLIT * width, (H_SPLIT1 + H_SPLIT2) * height);
  settings_canvas.update(W_SPLIT * width, 0, (1 - W_SPLIT) * width, H_SPLIT1 * height);
  temporal_canvas.update(W_SPLIT * width, H_SPLIT1 * height, (1 - W_SPLIT) * width, H_SPLIT2 * height);
  categorical_canvas.update(0, (H_SPLIT1 + H_SPLIT2) * height, width, (1 - (H_SPLIT1 + H_SPLIT2)) * height);
  network_model.simulate(false, false);
  settings_canvas.drawRect(200);
  temporal_canvas.drawRect(100);
  categorical_canvas.drawRect(150);
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
