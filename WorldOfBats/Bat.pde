private abstract class Bat
{
  private float x, y;
  private float direction;
  private float speed = 0.1;
  private float energy = 10.0;
  private int score = 0;
  private PImage wingImage;
  private PImage bodyImage;
  private float flapCounter;
  private float wingScaling;
  private float bodyScaling;
  private int colour;

  Bat()
  {
    x = random(0, width);
    y = random(0, height);
    direction = random(-180, 180);
    flapCounter = random(0, 10);
    initialiseAppearance();
  }

  abstract void initialiseAppearance();

  void setWingAppearance(String wingDescriptor)
  {
    // Convert size bit pattern to an int
    int userSpecifiedSize = Integer.parseInt(wingDescriptor.substring(0, 4), 2);
    // Add 7 to any size passed in by user - to stop bat being too small !
    float size = userSpecifiedSize + 7.0;
    // Convert size into a scaling float between 0 and 1 (max size is 1111 + 7 = 22)
    wingScaling = size / 22.0;
    wingImage = loadImage("Wings" + File.separator + wingDescriptor.substring(4) + ".png");
  }

  void setBodyAppearance(String bodyDescriptor)
  {
    // Convert size bit pattern to an int
    int userSpecifiedSize = Integer.parseInt(bodyDescriptor.substring(0, 4), 2);
    // Add 7 to any size passed in by user - to stop bat being too small !
    float size = userSpecifiedSize + 7.0;
    // Convert size into a scaling float between 0 and 1 (max size is 1111 + 7 = 22)
    bodyScaling = size / 22.0;
    bodyImage = loadImage("Bodies" + File.separator + bodyDescriptor.substring(4) + ".png");
  }

  void setColour(int r, int g, int b)
  {
    colour = color(r,g,b);
  }

  PingEcho narrowPing()
  {
    return sendNarrowPing(this);
  }

  PingEcho mediumPing()
  {
    return sendMediumPing(this);
  }

  PingEcho widePing()
  {
    return sendWidePing(this);
  }

  void turnLeft()
  {
    // Turn left by one degree
    direction -= 1.0;
    if (direction < -180) direction += 360;
    // Sleep a bit to prevent bat turning too quickly !
    delay(2);
  }

  void turnRight()
  {
    // Turn right by one degree
    direction += 1.0;
    if (direction > 180) direction -= 360;
    // Sleep a bit to prevent bat turning too quickly !
    delay(2);
  }

  private void eat(float insectSize)
  {
    score += insectSize;
    energy += insectSize;
  }

  void setSpeed(float s)
  {
    speed = s;
    // Don't allow speed to be set above 1.0
    if (speed > 1.0) speed = 1.0;
    // Don't allow speed to be set below 0.1
    if (speed < 0.1) speed = 0.1;
    // If we have run out of energy, set speed to crawl
    if (energy <= 0) speed = 0.1;
  }

  void moveYourself()
  {
    // Use up energy proportional to speed
    energy -= speed/10.0;
    // If there is no energy left, go at crawling speed
    if (energy <= 0) {
      speed = 0.1;
      energy = 0;
    }
    x += (speed*20.0) * sin(radians(direction));
    y -= (speed*20.0) * cos(radians(direction));
    if (x > width) x = 0.0;
    if (x < 0) x = width;
    if (y > height) y = 0.0;
    if (y < 0) y = height;
    manoeuvre();
  }

  abstract void manoeuvre();

  void drawYourself()
  {
    if ((wingImage != null) &&  (bodyImage != null)) {
      pushMatrix();
      translate(x, y);
      rotate(radians(direction));
      tint(colour);
      if (flapCounter != 0) image(wingImage, 0, 0, wingImage.width*wingScaling, wingImage.height*wingScaling);
      image(bodyImage, 0, 0, bodyImage.width*bodyScaling, bodyImage.height*bodyScaling);
      rotate(-radians(direction));
      if (showScores) text(score, 0, 0);
      popMatrix();
    }
    flapCounter += sqrt(speed);
    if (flapCounter > 3.0) flapCounter = 0.0;
  }
}
