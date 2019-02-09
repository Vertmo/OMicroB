/* C-interface between:                             */
/*   -> prims/std-bindings.c | prims/omc-bindings.c */
/*   -> simul/sf-regs.c | avr/avrlib.c | microbit/microbitlib.c */

#include <stdbool.h>
#include <stdint.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void avr_set_bit(uint8_t reg, uint8_t bit);
void avr_clear_bit(uint8_t reg, uint8_t bit);
bool avr_read_bit(uint8_t reg, uint8_t bit);

/******************************************************************************/

void avr_serial_init();
void avr_serial_write(char val);
char avr_serial_read();

/******************************************************************************/

void avr_write_register(uint8_t reg, uint8_t val);
uint8_t avr_read_register(uint8_t reg);
int avr_random(int max);
int avr_millis();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void microbit_print_string(char *str);
void microbit_print_int(int i);
void microbit_write_pixel(int x, int y, int l);
void microbit_print_image(char *str);
int microbit_button_is_pressed(int b);
void microbit_digital_write(int p, int l);
int microbit_digital_read(int p);
void microbit_delay(int ms);
void microbit_serial_write_char(char c);
char microbit_serial_read_char();
int microbit_millis();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
