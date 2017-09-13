#include <BMI160.h>
#include <CurieIMU.h>
#include <CurieBLE.h>
#include <math.h>
#include <Lights.h>
#ifdef __AVR__
  #include <avr/power.h> // power saving library?
#endif
const int NEOPIXELPIN =6;
const int NUMPIXELS =19;
const int LIGHT_PIN =A0;
Lights light = Lights(NEOPIXELPIN, NUMPIXELS);
//------breadboard buttons (delete later)------//
const int leftButtonPin = 4;
const int rightButtonPin = 2;
//const int leftLedPin = 13;
const int rightLedPin = 12;
int leftButtonState = 0;
int rightButtonState = 0;
//---------------------------------------------*/

const int ledPin = 13;
const int buttonPin = 4;

BLEService ledService("19B10010-E8F2-537E-4F6C-D104768A1215");
BLECharCharacteristic ledCharacteristic("19B10011-E8F2-537E-4F6C-D104768A1215", BLERead | BLEWrite);
BLECharCharacteristic buttonCharacteristic("19B10012-E8F2-537E-4F6C-D104768A1215", BLERead | BLENotify);

void setup() {
  while (!Serial) { ;} // wait for serial monitor to start
  Serial.begin(9600);
  CurieIMU.begin();
  CurieIMU.setAccelerometerRange(2);
  pinMode(LIGHT_PIN, INPUT);
  light.begin();

  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);

  
  BLE.begin();
  BLE.setLocalName("BtnLED");
  BLE.setAdvertisedService(ledService);
  ledService.addCharacteristic(ledCharacteristic);
  ledService.addCharacteristic(buttonCharacteristic);
  BLE.addService(ledService);
  ledCharacteristic.setValue(0);
  buttonCharacteristic.setValue(0);
  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
  
  //------breadboard buttons (delete later)----//
  //pinMode(leftLedPin, OUTPUT);
  pinMode(leftButtonPin, INPUT);
  pinMode(rightLedPin, OUTPUT);
  pinMode(rightButtonPin, INPUT);
  //-------------------------------------------//



  
}

void loop() {

  
  light.setAccelIntensity(getAccelVal());
  light.setDaylightIntensity(analogRead(LIGHT_PIN));


  //------breadboard buttons (delete later) ---//
  //  leftButtonState = digitalRead(leftButtonPin);
  rightButtonState = digitalRead(rightButtonPin);
  if (leftButtonState == HIGH) {
    //    digitalWrite(leftLedPin, HIGH);
    digitalWrite(rightLedPin, LOW);
    light.left();
  } else if (rightButtonState == HIGH) {
    digitalWrite(rightLedPin, HIGH);
    //digitalWrite(leftLedPin, LOW);
    light.right();
  } else {
    digitalWrite(rightLedPin, LOW);
    //digitalWrite(leftLedPin, LOW);
  }
  //-------------------------------------------//

  BLE.poll();

  char buttonValue = digitalRead(buttonPin);
  boolean buttonChanged = (buttonCharacteristic.value() != buttonValue);


  if(buttonChanged){
    ledCharacteristic.setValue(buttonValue);
    buttonCharacteristic.setValue(buttonValue);
  }
  
  if (ledCharacteristic.written() || buttonChanged) {
    Serial.println("ldch written");
    if (ledCharacteristic.value()) {
      Serial.println("button");
    //light.left();
    digitalWrite(ledPin, HIGH);
    } else {
      Serial.println("asd");
      digitalWrite(ledPin, LOW);
    }
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
  return pow(accelX, 3) + pow(accelY, 3) + pow(accelZ, 3) - .3;
}
