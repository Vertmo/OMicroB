#include "Arduino.h"
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

ESP8266WebServer server(80);

uint8_t get_pin_addr(uint8_t pin) {
  if (pin == 0) return D0;
  if (pin == 1) return D1;
  if (pin == 2) return D2;
  if (pin == 3) return D3;
  if (pin == 4) return D4;
  if (pin == 5) return D5;
  if (pin == 6) return D6;
  if (pin == 7) return D7;
  if (pin == 8) return D8;
  if (pin == 9) return A0;
}

void esp8266_pin_mode(uint8_t pin, uint8_t mode) {
  pinMode(get_pin_addr(pin), mode);
}

void esp8266_digital_write(uint8_t pin, uint8_t level) {
  digitalWrite(get_pin_addr(pin), level);
}

uint8_t esp8266_digital_read(uint8_t pin) {
  return digitalRead(get_pin_addr(pin));
}

void esp8266_analog_write(uint8_t pin, uint8_t level) {
  analogWrite(get_pin_addr(pin), level);
}

uint8_t esp8266_analog_read(uint8_t pin) {
  return analogRead(get_pin_addr(pin));
}

void esp8266_delay(int ms) {
  delay(ms);
}

int esp8266_millis() {
  return millis();
}

void esp8266_serial_write_char(char c) {
  Serial.write(c);
}

char esp8266_serial_read_char() {
  int incoming = Serial.read();
  if (incoming == -1) return 0;
  else return (char)incoming;
}

void esp8266_start_server(char *ssid, char *passwd) {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, passwd);
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", []() {
      server.send(200, "text/plain", "The server is on !");
    });

  server.begin();

  while(1) {
    server.handleClient();
    delay(100);
  }
}
