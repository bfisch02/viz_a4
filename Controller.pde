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
