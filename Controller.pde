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
  
}
