//
// Storage.c/Storage.h library, by @Yaya.Cout on FramaGit.org
// Taken from https://framagit.org/Yaya.Cout/numworks-extapp-storage/
// See https://framagit.org/Yaya.Cout/numworks-extapp-storage/-/blob/master/src/storage.c?ref_type=heads#L46
//

#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include "storage.h"


// Taken from https://codereview.stackexchange.com/questions/151049/endianness-conversion-in-c/151070#151070
// I could convert the endianness manually, but it's less readable.
inline uint32_t reverse32(uint32_t value) {
  return (((value & 0x000000FF) << 24) |
          ((value & 0x0000FF00) <<  8) |
          ((value & 0x00FF0000) >>  8) |
          ((value & 0xFF000000) >> 24));
}


int extapp_fileList(const char ** filename, int maxrecord, const char * extension) {
  char * offset = (char*) extapp_address();
  const char * endAddress = offset + extapp_size();

  if (!extapp_isValid((const uint32_t *)offset)) {
    // Storage is invalid
    return -1;
  }

  offset += 4;
  int currentRecord = 0;


  while ((currentRecord < maxrecord) && offset < endAddress) {
    uint16_t size = *(uint16_t *)offset;
    if (size == 0) {
      break;
    }
    char * name = (char *)offset + 2;
    filename[currentRecord] = name;

    offset += size;
    currentRecord++;
  }

  return currentRecord;
}

const char * extapp_fileRead(const char * filename, size_t * len) {
  char * offset = (char *)extapp_address();
  const char * endAddress = offset + extapp_size();

  if (!extapp_isValid((const uint32_t *)offset)) {
    // Storage is invalid
    return NULL;
  }

  offset += 4;

  while (offset < endAddress) {
    uint16_t size = *(uint16_t *)offset;
    if (size == 0) {
      break;
    }
    char * name = (char *)offset + 2;

    if (strcmp(name, filename) == 0) {
      *len = size;
      //     offset + size + filename        + \0
      return offset + 2    + strlen(name) + 1 ;
    }

    offset += size;
  }

  // File not found
  return NULL;
}

/* bool extapp_fileWrite(const char * filename, const char * content, size_t len) { */
/*   // Check if we have enough free space */
/*   const uint32_t * recordStartPointer = extapp_nextFree(); */
/*   //                                                          Start Address  + size +     filename     + \0 + content */
/*   const uint32_t * recordEndPointer = (uint32_t *)((char *)recordStartPointer + 2 + strlen(filename) + 1 + len); */
/*   const uint32_t * storageEndPointer = extapp_address() + extapp_nextFree(); */

/*   // In case where we have overflown storage, we return an error */
/*   if (storageEndPointer < recordEndPointer) { */
/*     return false; */
/*   } */

/*   char * writableRecordStartPointer = (char *)extapp_nextFree(); */

/*   // We have enough storage, so we can write the data */
/*   // Write size : */
/*   // filename + \0 + content */
/*   const uint16_t totalSize = strlen(filename) + 1 + len; */
/*   *(uint16_t *)writableRecordStartPointer = totalSize; */

/*   // Write filename: */
/*   memcpy(writableRecordStartPointer + 2, filename, strlen(filename) + 1); */

/*   // Write content: */
/*   memcpy(writableRecordStartPointer + 2 + strlen(filename) + 1, content, len); */

/*   // The record is now written, so we can return */
/*   return true; */
/* } */

bool extapp_fileErase(const char * filename) {
  char * offset = (char *)extapp_address();
  const char * endAddress = offset + extapp_size();

  if (!extapp_isValid((const uint32_t *)offset)) {
    // Storage is invalid
    return false;
  }

  offset += 4;

  // Locate the record address
  char * recordAddress = NULL;
  while (offset < endAddress) {
    uint16_t size = *(uint16_t *)offset;
    if (size == 0) {
      break;
    }
    char * name = (char *)offset + 2;

    if (strcmp(name, filename) == 0) {
      recordAddress = offset;
      break;
    }

    offset += size;
  }

  // File not found
  if (recordAddress == NULL) {
    return false;
  }

  // Get the file size
  const uint16_t len =  *(uint16_t *)offset;

  // Move the rest of the data
  // Why not len + 2 ?
  memmove(offset, offset + len, (char *)extapp_nextFree() - offset);

  // Overwrite the rest of the storage with zeroes
  // the + 1 in len + 1 is for the uint16_t used for file size
  memset(offset + *(uint16_t *)offset + 1, 0, len + 1);


  return true;
}


uint32_t * extapp_address() {
  return *(uint32_t **)((*extapp_userlandAddress()) + 0xC);
}

uint32_t extapp_size() {
  return *(uint32_t *)((*extapp_userlandAddress()) + 0x10);
}


const uint32_t * extapp_nextFree() {
  char * offset = (char*)extapp_address();
  const char * endAddress = offset + extapp_size();

  if (!extapp_isValid((const uint32_t *)offset)) {
    // Storage is invalid
    return NULL;
  }

  offset += 4;

  while (offset < endAddress) {
    uint16_t size = *(uint16_t *)offset;
    if (size == 0) {
      // Here, we are at the place where new records should start
      return (const uint32_t *)offset;
    }

    offset += size;
  }

  // If we exited the loop, it mean that we have gone out of the storage
  return (uint32_t *)endAddress;
}

/* uint32_t extapp_used() { */
/*   return (uint32_t)extapp_nextFree() - extapp_address(); */
/* } */


bool extapp_isValid(const uint32_t * address) {
  return *address == reverse32(0xBADD0BEE);
}

uint8_t extapp_calculatorModel() {
  // To guess the storage size without reading forbidden addresses, we try to
  // get the storage address from the userland header

  uint32_t userlandMagicSlotAN0110 = *(uint32_t *)0x90010000;
  uint32_t userlandMagicSlotBN0110 = *(uint32_t *)0x90410000;
  uint32_t userlandMagicSlotAN0120 = *(uint32_t *)0x90020000;
  uint32_t userlandMagicSlotBN0120 = *(uint32_t *)0x90420000;

  // On N0110, RAM start is at 0x20000000 and end is 0x20040000
  // On N0120, RAM start is at 0x20040000
  bool userlandMagicSlotAN0110IsValid = reverse32(0xfeedc0de) == userlandMagicSlotAN0110;
  bool userlandMagicSlotBN0110IsValid = reverse32(0xfeedc0de) == userlandMagicSlotBN0110;
  // TODO: Check the end address on N0120 (should be working, but good to check anyway)
  bool userlandMagicSlotAN0120IsValid = reverse32(0xfeedc0de) == userlandMagicSlotAN0120;
  bool userlandMagicSlotBN0120IsValid = reverse32(0xfeedc0de) == userlandMagicSlotBN0120;

  int N0110Counter = userlandMagicSlotAN0110IsValid + userlandMagicSlotBN0110IsValid;
  int N0120Counter = userlandMagicSlotAN0120IsValid + userlandMagicSlotBN0120IsValid;

  // At least one slot indicate N0110 and none N0120
  if ((N0110Counter > 0) && (N0120Counter == 0)) {
    return 1;
  }

  // At least one slot indicate N0120 and none N0110
  if ((N0120Counter > 0) && (N0110Counter == 0)) {
    return 2;
  }

  // In case where both matched, choose the one with most matches (for example,
  // if slot data made a false positive (should not happen unless someone flash
  // the wrong firmware on a calculator))
  if (N0110Counter > N0120Counter) {
    return 1;
  } if (N0120Counter > N0110Counter) {
    return 2;
  }

  // The remaining cases is equality (no match or as much matches). In both
  // cases, we cannot know
  return 0;
}

const uint32_t * extapp_userlandAddress() {
  // Get the model
  const uint8_t model = extapp_calculatorModel();

  if (model == 1) {
    return (uint32_t *)0x20000008;
  } if (model == 2) {
    return (uint32_t *)0x24000008;
  }

  // We don't know for other cases, so we suppose (arbitrary) that it's an
  // N0110/N0115 because N0120 is not the latest model and is much less used
  // than N0110/N0115
  return (uint32_t *)0x24000008;
}
