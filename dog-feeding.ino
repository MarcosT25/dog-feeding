#include <ESP32Servo.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <Wire.h>
#include "RTClib.h"

RTC_DS3231 rtc;

const char* ssid = "";
const char* password = "";

String LunchHour = "12";
String LunchMinute = "00";
String DinerHour = "30";
String DinerMinute = "70";
String servoTime = "1600";

AsyncWebServer server(80);

#define SERVO_PIN 23

Servo servoMotor;

void setup() {
  Serial.begin(115200);
  
  servoMotor.attach(SERVO_PIN);
  servoMotor.write(0);
  
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to the WiFi network");
  Serial.println(WiFi.localIP());
  
  server.on("/getLocalTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    DateTime now = rtc.now();
    String response = "";
    response = now.hour();
    response += ":";
    response += now.minute();
    response += ":";
    response += now.second();
    request->send(200, "plain/text", response);
  });

  server.on("/setLocalTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    if (request->hasParam("hour") && request->hasParam("minute")) {
      int year = request->getParam("year")->value().toInt();
      int month = request->getParam("month")->value().toInt();
      int day = request->getParam("day")->value().toInt();
      int hour = request->getParam("hour")->value().toInt();
      int minute = request->getParam("minute")->value().toInt();
      rtc.adjust(DateTime(year, month, day, hour, minute, 0));
      request->send(200, "plain/text", "OK");
    }
  });

  server.on("/setLunchTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    if (request->hasParam("hour") && request->hasParam("minute")) {
      LunchHour = request->getParam("hour")->value();
      LunchMinute = request->getParam("minute")->value();
      Serial.print("Hora: ");
      Serial.print(LunchHour);
      Serial.print(":");
      Serial.println(LunchMinute);
      request->send(200, "plain/text", "OK");
    }
  });

  server.on("/getLunchTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    Serial.print("Hora: ");
    Serial.print(LunchHour);
    Serial.print(":");
    Serial.println(LunchMinute);
    String response = "";
    response = LunchHour;
    response += ":";
    response += LunchMinute;
    request->send(200, "plain/text", response);
  });

  server.on("/setDinerTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    if (request->hasParam("hour") && request->hasParam("minute")) {
      DinerHour = request->getParam("hour")->value();
      DinerMinute = request->getParam("minute")->value();
      Serial.print("Hora: ");
      Serial.print(DinerHour);
      Serial.print(":");
      Serial.println(DinerMinute);
      request->send(200, "plain/text", "OK");
    }
  });

  server.on("/getDinerTime", HTTP_GET, [] (AsyncWebServerRequest *request) {
    Serial.print("Hora: ");
    Serial.print(DinerHour);
    Serial.print(":");
    Serial.println(DinerMinute);
    String response = "";
    response = DinerHour;
    response += ":";
    response += DinerMinute;
    request->send(200, "plain/text", response);
  });

  server.on("/giveFood", HTTP_GET, [] (AsyncWebServerRequest *request) {
    if (request->hasParam("time")) {
      servoTime = request->getParam("time")->value();
    }
    servoMotor.write(90);
    delay(servoTime.toInt());
    servoMotor.write(0);
    request->send(200, "plain/text", "OK");
  });

  server.begin();

  if (! rtc.begin()) {
    Serial.println("DS3231 não encontrado");
    while(1);
  }
  if (rtc.lostPower()) {
    Serial.println("DS3231 ok");
    // rtc.adjust(DateTime(2022, 8, 6, 18, 31, 0));
  }
}

void loop() {
  DateTime now = rtc.now();
  if (now.hour() == LunchHour.toInt() && now.minute() == LunchMinute.toInt() && now.second() == 0) {
    servoMotor.write(90);
    delay(servoTime.toInt());
    servoMotor.write(0);
  }
  if (now.hour() == DinerHour.toInt() && now.minute() == DinerMinute.toInt() && now.second() == 0) {
    servoMotor.write(60);
    delay(1500);
    servoMotor.write(0);
  }
}