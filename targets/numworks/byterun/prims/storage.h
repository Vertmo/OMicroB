#ifndef STORAGE_H
#define STORAGE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

int extapp_fileList(const char ** filename, int maxrecord, const char * extension);
const char * extapp_fileRead(const char * filename, size_t * len);
/* bool extapp_fileWrite(const char * filename, const char * content, size_t len); */
bool extapp_fileErase(const char * filename);
uint32_t extapp_size();
uint32_t * extapp_address();
/* uint32_t extapp_used(); */
const uint32_t * extapp_nextFree();
bool extapp_isValid(const uint32_t * address);
// Return the calculator model : 0 is unknown, 1 is N0110/N0115, 2 is N0120
uint8_t extapp_calculatorModel();
const uint32_t * extapp_userlandAddress();


#ifdef __cplusplus
}
#endif


#endif
