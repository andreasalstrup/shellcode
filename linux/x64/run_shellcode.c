#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  char *shell_code_path = argv[1];

  FILE *f = fopen(shell_code_path, "rb");
  if (f == NULL) {
    return 1;
  }

  fseek(f, 0, SEEK_END);
  long f_size = ftell(f);
  fseek(f, 0, SEEK_SET);

  char *buffer = (char *)malloc(f_size);

  fread(buffer, 1, f_size, f);
  fclose(f);

  if (mprotect((void *)((uintptr_t)buffer & ~(0xFFF)), 4096,
               PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
    perror("mprotect");
    return 1;
  }

  void (*fun_ptr)() = (void (*)())buffer;
  fun_ptr();

  free(buffer);
  return 0;
}
