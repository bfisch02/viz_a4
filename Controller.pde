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

  HashMap<String,Integer> getCategoryStat(String category) {
    ArrayList<Firewall> allData = this.getAllData();
    HashMap<String,Integer> categoryCnt = new HashMap<String,Integer>();


    for (Firewall f : allData) {
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
  
}
