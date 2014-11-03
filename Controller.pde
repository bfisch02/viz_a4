import java.util.Map;

class Controller {
  ArrayList<Firewall> full_data;
  ArrayList<Firewall> selected_data;
  
  Controller(ArrayList<Firewall> data) {
    this.full_data = data;
    this.selected_data = null; 
  }
  
  ArrayList<Firewall> getAllData()
  {
     return full_data;
  }
  
  ArrayList<Firewall> getSelectedData()
  {
    return selected_data; 
  }

  HashMap<String,Integer> getCategoryStat(String category, boolean selected) {
    ArrayList<Firewall> d;
    if (selected) d = this.getSelectedData();
    else d = this.getAllData();
    HashMap<String,Integer> categoryCnt = new HashMap<String,Integer>();


    for (Firewall f : d) {
      try {
        Field field = f.getClass().getDeclaredField(category);
        field.setAccessible(true);
        Object obj = field.get(f);
        String key = obj.toString();

        if (categoryCnt.containsKey(key)) {
          int newValue = categoryCnt.get(key) + 1;
          categoryCnt.put(key, newValue);
        } else {
          categoryCnt.put(key, 1);
        }

      } catch (Exception e) {
          println(e);        
      }
    }

    // println(category + " - categoryCnt: "+categoryCnt);

    return categoryCnt;
  }
  
  void setAll()
  {
    selected_data = full_data;
    categoricalView.useSelected();
  }
  
  void setFilterCategorical(HashMap<String, ArrayList<String>> map, int index)
  {
    if (index == 0)
    {
      setSelectedCategorical(map); 
      return;
    }
    print("CALLED SET FILTER CATEGORICAL..\n");
    String cur_spec;
    Firewall cur_data;
    ArrayList<Firewall> new_selected = new ArrayList<Firewall>();
    ArrayList<String> operationList;
    ArrayList<String> syslogList;
    ArrayList<String> protocolList;
    for (int i = 0; i < selected_data.size(); i++) {
       cur_data = selected_data.get(i);
       operationList = map.get("Operation");
       syslogList = map.get("Syslog priority");
       protocolList = map.get("Protocol");
       if (operationList != null && operationList.contains(cur_data.operation) ||
           syslogList != null && syslogList.contains(cur_data.syslog) ||
           protocolList != null && protocolList.contains(cur_data.protocol)) {
         new_selected.add(cur_data);
       }
    }
    selected_data = new_selected;
    network_model.highlightSelectedEdges();
  }
  
  void setSelectedCategorical(HashMap<String, ArrayList<String>> map)
  {
    print("CALLED SET SELECTED CATEGORICAL..\n");
    String cur_spec;
    Firewall cur_data;
    selected_data = new ArrayList<Firewall>();
    ArrayList<String> operationList;
    ArrayList<String> syslogList;
    ArrayList<String> protocolList;
    for (int i = 0; i < full_data.size(); i++) {
       cur_data = full_data.get(i);
       operationList = map.get("Operation");
       syslogList = map.get("Syslog priority");
       protocolList = map.get("Protocol");
       if (operationList != null && operationList.contains(cur_data.operation) ||
           syslogList != null && syslogList.contains(cur_data.syslog) ||
           protocolList != null && protocolList.contains(cur_data.protocol)) {
         selected_data.add(cur_data);
       }
    }
    network_model.highlightSelectedEdges();
  }
  
  void setFilterNetwork(HashMap<String, Boolean> ips, int index)
  {
    if (index == 0) {
      setSelectedNetwork(ips);
    } else {
      Firewall cur_data;
      String cur_ip;
      ArrayList<Firewall> newSelected = new ArrayList<Firewall>();
      print("SETTING FILTER... SIZE = " + selected_data.size() + "\n");
      for (int i = 0; i < selected_data.size(); i++) {
       cur_data = selected_data.get(i);
       if (ips.get(cur_data.sourceIP) != null || ips.get(cur_data.destIP) != null) {
         newSelected.add(cur_data); 
       }
      }
      selected_data = newSelected; 
      categoricalView.useSelected();
    }
  }
  
  void setSelectedNetwork(HashMap<String, Boolean> ips)
  {
    String cur_ip;
    Firewall cur_data;
    selected_data = new ArrayList<Firewall>();
    for (int i = 0; i < full_data.size(); i++) {
       cur_data = full_data.get(i);
       if (ips.get(cur_data.sourceIP) != null || ips.get(cur_data.destIP) != null) {
         selected_data.add(cur_data); 
       }
    }
    if (selected_data.size() == 0) {
      setAll(); 
    }
    categoricalView.useSelected();
  }
  
}
