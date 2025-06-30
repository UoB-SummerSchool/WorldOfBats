private ArrayList<Bat> bats = new ArrayList();
private ArrayList<Insect> insects = new ArrayList();
private boolean showScores = false;
private boolean playing = true;
private PImage background;

void setup()
{
  size(1000, 640);
  frameRate(15);
  textSize(26);
  imageMode(CENTER);
  textAlign(CENTER,CENTER);  
  background = loadImage("background.jpg");
  for(Class possibleBatClass: WorldOfBats.class.getDeclaredClasses()) {
    if(possibleBatClass.getSuperclass().equals(Bat.class)) {
      bats.add(dynamicallyInstantiateClass(possibleBatClass));
    }
  }
  for (int i=0; i<30; i++) createNewInsect();
}

private Bat dynamicallyInstantiateClass(Class theClass)
{
  try {
    return (Bat) theClass.getDeclaredConstructors()[0].newInstance(this);
  } catch(Exception e) {
    println("Can't instantiate " + theClass + ": " + e);
  }
  return null;
}

void draw()
{
  tint(255);
  // Image mode is CENTER, so need to draw background positioned at the centre of the screen
  image(background, width/2, height/2, width, height);
  if(playing) {
    updatePositions();
    performEatDetection();
    for (Insect insect : insects) insect.drawYourself();
    for (Bat bat : bats) bat.drawYourself();
  }
}

private void createNewInsect()
{
  float size = random(2, 4);
  insects.add(new Insect(color(255, 255, 255), size));
}

private void updatePositions()
{
  for (Bat bat : bats) {
    bat.moveYourself();
    performCollisionDetection(bat);
    for (Insect insect : insects) {
      // Every now and then move the insects
      if (everyNowAndThen()) insect.moveYourself();
    }
  }
}

private void performCollisionDetection(Bat bat)
{
  for (Bat other : bats) {
    if (!bat.equals(other)) {
      if ((diff(bat.x, other.x) < 20) && (diff(bat.y, other.y) < 20)) {
        bat.x += random(-5, 5);
        bat.y += random(-5, 5);
      }
    }
  }
}

private void performEatDetection()
{
  ArrayList<Insect> consumed = new ArrayList();
  for (Bat bat : bats) {
    for (Insect insect : insects) {
      if ((diff(bat.x, insect.x) < 15) && (diff(bat.y, insect.y) < 15)) {
        consumed.add(insect);
        bat.eat(insect.size);
      }
    }
  }
  for (Insect insect : consumed) {
    insects.remove(insect);
    createNewInsect();
  }
}

PingEcho sendWidePing(Bat bat)
{
  return sendPing(bat,20);
}

PingEcho sendMediumPing(Bat bat)
{
  return sendPing(bat,10);
}

PingEcho sendNarrowPing(Bat bat)
{
  return sendPing(bat,5);
}

PingEcho sendPing(Bat bat, int beamWidth)
{
  float angle = -1;
  float closestDistance = -1;
  float closestSize = 0;
  if (playing) {
    for (Insect insect : insects) {
      angle = - degrees(atan2(bat.x-insect.x, bat.y-insect.y));
      if (degreeDifference(angle, bat.direction) < beamWidth) {
        float x_dist = insect.x-bat.x;
        float y_dist = insect.y-bat.y;
        float distance = sqrt((x_dist * x_dist) + (y_dist * y_dist));
        if ((closestDistance == -1) || (distance < closestDistance)) {
          closestDistance = distance;
          closestSize = insect.size;
        }
      }
    }
  }
  return new PingEcho(closestDistance, closestSize);
}

private boolean everyNowAndThen()
{
  return random(0, 10) > 6;
}

private float diff(float a, float b)
{
  if (a < b) return b-a;
  else return a-b;
}

private float degreeDifference(float a, float b)
{
  float difference = abs(a-b);
  if (difference > 180) difference = 360 - difference;
  return difference;
}

private String getNameOfBat(Bat bat)
{
  String fullName = bat.getClass().getName();
  return fullName.split("\\$")[1];
}

void keyPressed()
{
  if (key=='q') {
    playing = false;
    for (Bat bat : bats) println(getNameOfBat(bat) + ": " + str(bat.score));
  }
  if (keyCode==TAB) showScores = !showScores;
}
