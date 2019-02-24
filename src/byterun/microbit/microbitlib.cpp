#include "MicroBit.h"

MicroBit uBit;

void microbit_init() {
  uBit.init();
}

void microbit_delay(int ms) {
  uBit.sleep(ms);
}

int microbit_millis() {
  return uBit.systemTime();
}

void microbit_print_string(char *str) {
  uBit.display.scroll(str);
}

void microbit_print_int(int i) {
  uBit.display.scroll(i);
}

void microbit_write_pixel(int x, int y, int l) {
  uBit.display.image.setPixelValue(x, y, l);
}

void microbit_print_image(char *s) {
  MicroBitImage img(s);
  uBit.display.print(img);
}

void microbit_clear_screen() {
  uBit.display.clear();
}

int microbit_button_is_pressed(int b) {
  if(b == 0) return uBit.buttonA.isPressed();
  return uBit.buttonB.isPressed();
}

void microbit_digital_write(int p, int l) {
  uBit.io.pin[p].setDigitalValue(l);
}

int microbit_digital_read(int p) {
  return uBit.io.pin[p].getDigitalValue();
}

void microbit_analog_write(int p, int l) {
  uBit.io.pin[p].setAnalogValue(l*4);
}

int microbit_analog_read(int p) {
  return uBit.io.pin[p].getAnalogValue()/4;
}

/******************************************************************************/

void microbit_serial_write_char(char c) {
  uBit.serial.sendChar(c);
}

char microbit_serial_read_char() {
  int r = uBit.serial.read(ASYNC);
  if(r == MICROBIT_NO_DATA) return 0;
  else return (char) r;
}

/******************************************************************************/

int microbit_accelerometer_x() {
  return uBit.accelerometer.getX();
}

int microbit_accelerometer_y() {
  return uBit.accelerometer.getY();
}

int microbit_accelerometer_z() {
  return uBit.accelerometer.getZ();
}

int microbit_accelerometer_pitch() {
  return uBit.accelerometer.getPitch();
}

int microbit_accelerometer_roll() {
  return uBit.accelerometer.getRoll();
}

void microbit_compass_calibrate() {
  uBit.compass.calibrate();
}

int microbit_compass_heading() {
  return uBit.compass.heading();
}
