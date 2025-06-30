class SimonBat extends Bat
{
  void initialiseAppearance()
  {
    setWingAppearance("11110011");
    setBodyAppearance("00010011");
    setColour(170, 170, 220);
  }

  void manoeuvre()
  {
    setSpeed(1.0);
    PingEcho echo = mediumPing();
    if (echo.distance > 10) turnLeft();
  }
}
