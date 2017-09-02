#include <BMI160.h>
#include <CurieIMU.h>
#include <Math.h>
#include <Lights.h>
#ifdef __AVR__
  #include <avr/power.h> // power saving library?
#endif

const int leftButtonPin = 4;
const int rightButtonPin = 2;
const int leftLedPin =  13;
const int rightLedPin =  12;
const int LIGHT_PIN = A0;

float accel_val = 0;
int leftButtonState = 0;
int rightButtonState = 0;

Lights light = Lights(); // needs to be outside of void setup()

void setup() {
  //while (!Serial) { ;} // wait for serial monitor to start
  //Serial.begin(9600);
  CurieIMU.begin();
  CurieIMU.setAccelerometerRange(2);
  pinMode(leftLedPin, OUTPUT);
  pinMode(leftButtonPin, INPUT);
  pinMode(rightButtonPin, INPUT);
  pinMode(LIGHT_PIN, INPUT);
  light.begin();
}

void loop() {
  // testing buttons and lights
  leftButtonState = digitalRead(leftButtonPin);
  rightButtonState = digitalRead(rightButtonPin);

  if (leftButtonState == HIGH) {
    digitalWrite(leftLedPin, HIGH);
    digitalWrite(rightLedPin, LOW);
    light.glow();
  } else if (rightButtonState == HIGH) {
    digitalWrite(leftLedPin, LOW);
    digitalWrite(rightLedPin, HIGH);
    light.left();
  }

  // increase light brightness with accelerometer
  light.setAccelIntensity(getAccelVal());

  // stub for increasing brigtness in the dark
  light.setDaylightIntensity(analogRead(LIGHT_PIN));
  //Serial.println(analogRead(LIGHT_PIN));
}

float getAccelVal() // move to acceloremeter class?
{
  int rawX, rawY, rawZ;
  float accelX, accelY, accelZ;
  CurieIMU.readAccelerometer(rawX, rawY, rawZ);
  accelX = (float) rawX * 2.0 / 32768;
  accelY = (float) rawY * 2.0 / 32768;
  accelZ = (float) rawZ * 2.0 / 32768;
  return sq(sq(accelX) + sq(accelY) + sq(accelZ) - .3);
}
