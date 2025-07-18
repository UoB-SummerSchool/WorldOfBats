class Simon extends Bat
{
  void initialiseAppearance()
  {
    setWingAppearance("11110011");
    setBodyAppearance("00010011");
    setColour(170, 170, 220);
  }

  void manoeuvre()
  {
    setSpeed(0.1);
    PingEcho echo = narrowPing();
    println(echo.distance);
    if ((echo.distance != -1) && (echo.distance<200)) setSpeed(1.0);
    else turnLeft();
  }
}
