#include <BMI160.h>
#include <CurieIMU.h>
#include <Math.h>
#include <Lights.h>
#ifdef __AVR__
  #include <avr/power.h> // power saving library?
#endif
const int NEOPIXELPIN =6;
const int NUMPIXELS =19;
const int LIGHT_PIN =A0;
Lights light = Lights(NEOPIXELPIN, NUMPIXELS);



//------breadboard buttons (delete later)-------//
const int leftButtonPin = 4;
const int rightButtonPin = 2;
const int leftLedPin = 13;
const int rightLedPin = 12;
int leftButtonState = 0;
int rightButtonState = 0;
//---------------------------------------------------//


void setup() {
  //while (!Serial) { ;} // wait for serial monitor to start
  Serial.begin(9600);
  CurieIMU.begin();
  CurieIMU.setAccelerometerRange(2);
  pinMode(LIGHT_PIN, INPUT);
  light.begin();
  
 
//------breadboard buttons (delete later)-------//
  pinMode(leftLedPin, OUTPUT);
  pinMode(leftButtonPin, INPUT);
  pinMode(rightLedPin, OUTPUT);
  pinMode(rightButtonPin, INPUT);
//---------------------------------------------------//
  
  
}

void loop() {
  light.setAccelIntensity(getAccelVal());
  light.setDaylightIntensity(analogRead(LIGHT_PIN));


  leftButtonState = digitalRead(leftButtonPin);
  rightButtonState = digitalRead(rightButtonPin);
  if (leftButtonState == HIGH) {
    digitalWrite(leftLedPin, HIGH);
	digitalWrite(rightLedPin, LOW);
	light.left();
	}
	else if (rightButtonState == HIGH) {
	digitalWrite(rightButtonPin, HIGH);
	digitalWrite(leftButtonPin, LOW);
	light.right();
	}
  
}

float getAccelVal()
{
  // will need to redo this, should only turn on when brakes are applied
  // im guessing the -z vector since the chip will be on its side.
  int rawX, rawY, rawZ;
  float accelX, accelY, accelZ;
  CurieIMU.readAccelerometer(rawX, rawY, rawZ);
  accelX = (float) rawX * 2.0 / 32768;
  accelY = (float) rawY * 2.0 / 32768;
  accelZ = (float) rawZ * 2.0 / 32768;
  return sq(sq(accelX) + sq(accelY) + sq(accelZ) - .3);
}
