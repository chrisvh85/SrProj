/*
  Lights.h - Library for flashing NeoPixels.
*/
#ifndef Lights_h
#define Lights_h
#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

class Lights
{
  public:
    Lights(int _NEOPIXELPIN, int _NUMPIXELS);
    void left();
    void right();
    void off();
    void begin();
    void setAccelIntensity(float _val);
    void setDaylightIntensity(int _val);

  private:
    int NEOPIXELPIN;
    int NUMPIXELS;
    int delayval;
    int daylight_multiplier;
    float accel_max;
    Adafruit_NeoPixel pixels;
    void activateAll(float _val);
};

#endif
