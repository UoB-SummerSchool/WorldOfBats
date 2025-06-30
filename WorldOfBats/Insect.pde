private class Insect
{
  private int colour;
  private float size;
  private float x, y;

  Insect(int c, float s)
  {
    colour = c;
    size = s;
    x = random(0, width);
    y = random(0, height);
  }

  private void moveYourself()
  {
    x += random(-size, size);
    y += random(-size, size);
    if (x > width) x = 0.0;
    if (x < 0) x = width;
    if (y > height) y = 0.0;
    if (y < 0) y = height;
  }

  private void drawYourself()
  {
    int leftWing = int(x - (size/2) - 1);
    int rightWing = int(x + (size/2) + 1);
    fill(colour);
    ellipse(leftWing, int(y), size*2, size*2);
    ellipse(rightWing, int(y), size*2, size*2);
  }
}
