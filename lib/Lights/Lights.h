/*
  Lights.h - Library for flashing NeoPixels.
*/
#ifndef Lights_h
#define Lights_h
#define PIN            6
#define NUMPIXELS      19
#include "Arduino.h"
#include "../Adafruit_NeoPixel-master/Adafruit_NeoPixel.h"

class Lights
{
  public:
    Lights();
    void left();
    void glow();
    void off();
    void begin();
    void setAccelIntensity(int _val);
    void setDaylightIntensity(int _val);

  private:
    Adafruit_NeoPixel pixels;
    int delayval;
    int daylight_multiplier;
    float accel_max;
};

#endif
