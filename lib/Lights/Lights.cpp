/*
  Lights.cpp - Library for flashing NeoPixels.
*/
#include "Arduino.h"
#include "Lights.h"

Lights::Lights()
{
  pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
  delayval = 50;
  accel_max = 0;
  daylight_multiplier = 1;
}

void Lights::begin()
{
  pixels.begin(); // cant call begin in the constructor for whatever reason
}

void Lights::setDaylightIntensity(int _val){
// daylightlight multiplier goes heres
}

void Lights::setAccelIntensity(int _val){
  Serial.println(_val);
  if(_val > accel_max){
    accel_max = _val;
    for(int i=0;i<19;i++){
      pixels.setPixelColor(i, pixels.Color((int)accel_max,0,0));
    }
    pixels.show();
  }
  else if ( accel_max>=0) {
    accel_max = .5*log10(accel_max);
    for(int i=0;i<19;i++){
      pixels.setPixelColor(i, pixels.Color((int)accel_max,0,0));
    }
    pixels.show();
  }
}

void Lights::left() // left turn signal
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

void Lights::off() // just a quick way to turn off all NeoPixels
{
  for(int i=0;i<19;i++){pixels.setPixelColor(i, pixels.Color(0,0,0));}
  pixels.show();
}

void Lights::glow() // glows all pixels
{
  for(int i=0; i<250; i+=10){ // outside pixels on
    for(int j=0;j<19;j++){ // inside pixels on
      pixels.setPixelColor(j, pixels.Color(i,0,0));
    }
    pixels.show();
    delay(10);
  }

  for(int i=250; i>=0; i-=10){ // outside pixels off
    for(int j=0;j<19;j++){ // inside pixels on
      pixels.setPixelColor(j, pixels.Color(i,0,0));
    }
    pixels.show();
    delay(10);
  }
}
