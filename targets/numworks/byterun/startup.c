#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

const uint32_t eadk_api_level  __attribute__((section(".rodata.eadk_api_level"))) = 0;

extern int main(int, char**);

void default_start() {
  printf("Launching the OCaml VM...\r\n");   // XXX: This does not get printed
  main(0, NULL); // Run the VM
  printf("Returned from the OCaml VM.\r\n"); // XXX: This does not get printed

  // This line could mean that the NWA app we produce could depend on a joined file,
  // to be added on the flashing website. We don't want that.
  // printf("External data : '%s'\n", eadk_external_data);
}

void __start(void) __attribute((weak, alias("default_start")));
