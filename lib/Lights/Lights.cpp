/*
  Lights.cpp - Library for flashing NeoPixels.
*/
#include <Arduino.h>
#include <Lights.h>

Lights::Lights(int _NEOPIXELPIN, int _NUMPIXELS)
{
  NUMPIXELS = _NUMPIXELS;
  NEOPIXELPIN = _NEOPIXELPIN;
  pixels = Adafruit_NeoPixel(NUMPIXELS, NEOPIXELPIN, NEO_GRB + NEO_KHZ800);
  delayval = 50;
  accel_max = 0;
  daylight_multiplier = 0;
}

void Lights::begin()
{
  pixels.begin(); // cant call begin in the constructor for whatever reason
}

void Lights::setDaylightIntensity(int _val)
{
  _val = pow(_val, -2) * 1000000;
  daylight_multiplier = _val;
  //Serial.print(daylight_multiplier);
  //Serial.print("\t");
  //Serial.print(accel_max);
  //Serial.println();
}

void Lights::activateAll(float _val)
{
  if (_val != 0 && daylight_multiplier == 0) {
    daylight_multiplier = 1;
  }
  else if (_val == 0 && daylight_multiplier != 0){
    _val = 1;
  }
  _val *=daylight_multiplier;

  for(int i=0;i<NUMPIXELS;i++)
  {
    pixels.setPixelColor(i, pixels.Color(_val,0,0));
  }
  pixels.show();
}

void Lights::setAccelIntensity(float _val)
{
  if(_val > accel_max)
  {
    accel_max = _val;
    activateAll(accel_max);
  }
  else if ( accel_max>=0)
  {
    accel_max = .5*log10(accel_max);
    activateAll(accel_max);
  }
}

void Lights::left()
{
  pixels.setPixelColor(7, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(1, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(0, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(4, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(11, pixels.Color(255,155,0));
  pixels.setPixelColor(12, pixels.Color(255,155,0));
  pixels.setPixelColor(13, pixels.Color(255,155,0));
  pixels.setPixelColor(14, pixels.Color(255,155,0));
  pixels.setPixelColor(15, pixels.Color(255,155,0));
  pixels.show();
  delay(delayval * 5);
  off();
  delay(delayval * 10);
}


void Lights::right()
{
  pixels.setPixelColor(13, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(4, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(0, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(1, pixels.Color(255,155,0));
  delay(delayval);
  pixels.show();
  pixels.setPixelColor(7, pixels.Color(255,155,0));
  pixels.setPixelColor(8, pixels.Color(255,155,0));
  pixels.setPixelColor(9, pixels.Color(255,155,0));
  pixels.setPixelColor(17, pixels.Color(255,155,0));
  pixels.setPixelColor(18, pixels.Color(255,155,0));
  pixels.show();
  delay(delayval * 5);
  off();
  delay(delayval * 10);
}

void Lights::off()
{
  activateAll(0);
}
