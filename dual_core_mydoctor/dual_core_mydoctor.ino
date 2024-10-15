#include <FirebaseESP32.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <Wire.h>
#include <time.h>
#include "MAX30105.h"
#include "spo2_algorithm.h"
#define SENSOR A0 // Set the A0 as SENSOR
MAX30105 particleSensor;

#define FIREBASE_HOST "https://ecgfirebase-8e031-default-rtdb.europe-west1.firebasedatabase.app/"
#define FIREBASE_AUTH "AIzaSyDruATQsd3MJp22jkhoHwA89SiJ545EU50"
#define WIFI_SSID "null"//"null"//"TOPNET8388"
#define WIFI_PASSWORD "yahya123"//"yahya123"//"UQMWNHCD8388"//

FirebaseData fbdo;
FirebaseJson json;


uint32_t irBuffer[100]; //infrared LED sensor data
uint32_t redBuffer[100];  //red LED sensor data

int32_t bufferLength; //data length
int32_t spo2; //SPO2 value
int8_t validSPO2; //indicator to show if the SPO2 calculation is valid
int32_t heartRate; //heart rate value
int8_t validHeartRate; //indicator to show if the heart rate calculation is valid

String pathType="/type";
String pathValeur="/valeur";
String pathTemps="/temps";
String pathParent;
String timeNow;
String type;
float temperature;
float ecg;
String get_time() {
  time_t now;
  time(&now);
  char time_output[30];
  strftime(time_output,30,"%H:%M  %d-%m-%y",localtime(&now));
  
  return String(time_output);
}
TaskHandle_t Task1;
TaskHandle_t Task2;
void task1code(void * parameters){
  Serial.print("Task1 running on core ");
  Serial.println(xPortGetCoreID());
  while(1){
float sensor = analogRead(SENSOR);
   Serial.println("ecg :");
    Serial.print(sensor);
     Serial.println();
    Firebase.setFloatAsync( fbdo,"1/ecg", sensor);
    delay(150);
   
  } 
} 
void task2code(void * parameters){
  Serial.print("Task2 running on core ");
  Serial.println(xPortGetCoreID());
  
   if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) //Use default I2C port, 400kHz speed
  {
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    while (1);
  }
byte ledBrightness = 60; //Options: 0=Off to 255=50mA
  byte sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 2; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  byte sampleRate = 100; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 411; //Options: 69, 118, 215, 411
  int adcRange = 4096; //Options: 2048, 4096, 8192, 16384
  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings
bufferLength = 100; //buffer length of 100 stores 4 seconds of samples running at 25sps

  //read the first 100 samples, and determine the signal range
  for (byte i = 0 ; i < bufferLength ; i++)
  {
    while (particleSensor.available() == false) //do we have new data?
      particleSensor.check(); //Check the sensor for new data

    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    particleSensor.nextSample(); //We're finished with this sample so move to next sample

    Serial.print(F("red="));
    Serial.print(redBuffer[i], DEC);
    Serial.print(F(", ir="));
    Serial.println(irBuffer[i], DEC);
  }

  //calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
  maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);

  //Continuously taking samples from MAX30102.  Heart rate and SpO2 are calculated every 1 second
  while (1)
  {
    //dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
    for (byte i = 25; i < 100; i++)
    {
      redBuffer[i - 25] = redBuffer[i];
      irBuffer[i - 25] = irBuffer[i];
    }

    //take 25 sets of samples before calculating the heart rate.
    for (byte i = 75; i < 100; i++)
    {
      while (particleSensor.available() == false) //do we have new data?
        particleSensor.check(); //Check the sensor for new data

      

      redBuffer[i] = particleSensor.getRed();
      irBuffer[i] = particleSensor.getIR();
      particleSensor.nextSample(); //We're finished with this sample so move to next sample
      temperature = particleSensor.readTemperature();
       temperature=temperature+3.5;
       Serial.print(F(", Temperature="));
      Serial.print(temperature, DEC);
       if(temperature>35){Firebase.setFloatAsync ( fbdo,"1/temperature", temperature);}
      if(validHeartRate==1){Firebase.setFloatAsync ( fbdo,"1/heartRate", heartRate);}
       if(validSPO2==1){Firebase.setFloatAsync ( fbdo,"1/spo2", spo2);}
      if(spo2<90 && validSPO2==1){
    type="Manque spo2";
    timeNow=String(get_time()); 
    
    pathParent="1/pic/" + timeNow ; 
     
    json.set(pathType.c_str(), type);
    json.set(pathValeur.c_str(), String(spo2));
    json.set(pathTemps.c_str(), timeNow);
    Firebase.RTDB.setJSONAsync(&fbdo, pathParent.c_str(), &json);  
    }
       
      
       if(temperature>38){
    type="Pic de température";
    timeNow=String(get_time()); 
    
    pathParent="1/pic/" + timeNow ; 
     
    json.set(pathType.c_str(), type);
    json.set(pathValeur.c_str(), String(temperature));
    json.set(pathTemps.c_str(), timeNow);
    Serial.print("je suis 8");
    Firebase.RTDB.setJSONAsync(&fbdo, pathParent.c_str(), &json);
    }
    
      //send samples and calculation result to terminal program through UART
      Serial.print(F("red="));
      Serial.print(redBuffer[i], DEC);
      Serial.print(F(", ir="));
      Serial.print(irBuffer[i], DEC);

      Serial.print(F(", HR="));
      Serial.print(heartRate, DEC);

      Serial.print(F(", HRvalid="));
      Serial.print(validHeartRate, DEC);

      Serial.print(F(", SPO2="));
      Serial.print(spo2, DEC);

      Serial.print(F(", SPO2Valid="));
      Serial.println(validSPO2, DEC);
    }

    //After gathering 25 new samples recalculate HR and SP02
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
  } 
  
}
void setup() {
   Serial.begin(115200);
  WiFi.begin (WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println ("");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  configTime(0,0,"pool.ntp.org","time.nist.gov");
  setenv("TZ","GMT0BST,M3.5.0/01,M10.5.0/02",1);
  // Serial.begin(115200);
  pinMode(SENSOR, INPUT);
  xTaskCreatePinnedToCore(
    task1code,/* Task function. */
    "task1",/* name of task. */
    10000,/* Stack size of task */
    NULL,/* parameter of the task */
    1,/* priority of the task */
    &Task1, /* Task handle to keep track of created task */
    0 /* pin task to core 1 */
    );
      xTaskCreatePinnedToCore(
    task2code,
    "task2",
    10000,
    NULL,
    1,
    &Task2,
    1);
}

void loop() {}
