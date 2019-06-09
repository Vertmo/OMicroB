/* C-interface between:                             */
/*   -> prims/std-bindings.c | prims/omc-bindings.c */
/*   -> simul/sf-regs.c | avr/avrlib.c              */

#include <stdbool.h>
#include <stdint.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void avr_set_bit(uint8_t reg, uint8_t bit);
void avr_clear_bit(uint8_t reg, uint8_t bit);
bool avr_read_bit(uint8_t reg, uint8_t bit);
void avr_analog_write(uint8_t pin, int val);
uint16_t avr_analog_read(uint8_t channel);

/******************************************************************************/

void avr_serial_init();
void avr_serial_write(char val);
char avr_serial_read();

/******************************************************************************/

void avr_spi_init_master();
void avr_spi_init_slave();
char avr_spi_transmit(char c);

/******************************************************************************/

void avr_write_register(uint8_t reg, uint8_t val);
uint8_t avr_read_register(uint8_t reg);
int avr_random(int max);
int avr_millis();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void esp8266_pin_mode(uint8_t p, uint8_t m);
void esp8266_digital_write(uint8_t p, uint8_t l);
uint8_t esp8266_digital_read(uint8_t p);
void esp8266_analog_write(uint8_t p, int l);
int esp8266_analog_read(uint8_t p);
void esp8266_delay(int ms);
int esp8266_millis();

/******************************************************************************/

void esp8266_serial_init();
void esp8266_serial_write_char(char c);
char esp8266_serial_read_char();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
