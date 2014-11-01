public class Canvas {
  float x;
  float y;
  float w;
  float h;
  
  Canvas(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  } 
  
  void update(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void drawRect(float val)
  {
    fill(val);
    rect(x, y, w, h); 
  }
  
  boolean mouseOver()
  {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h); 
  }
}
