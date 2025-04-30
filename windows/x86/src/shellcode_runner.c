#include <Windows.h>
#include <stdio.h>

int main(int argc, char **argv) {
    char *shell_code_path = argv[1];

    // Open binary shellcode file
    FILE *f = fopen(shell_code_path, "rb");
    if (f == NULL) {
        printf("Failed to load shellcode in hex: %d\n", GetLastError());
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long f_size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char *shellcode = (char *)malloc(f_size);
    if (shellcode == NULL) {
        printf("Failed to allocate shellcode buffer: %d\n", GetLastError());
        fclose(f);
        return 1;
    }

    fread(shellcode, 1, f_size, f);
    fclose(f);

    // Allocate and load memory for shellcode 
    LPVOID allocated_mem = VirtualAlloc(NULL, f_size, (MEM_COMMIT | MEM_RESERVE), PAGE_EXECUTE_READWRITE);
    if (allocated_mem == NULL){
        printf("Failed to allocate memory: %d\n", GetLastError());
        free(shellcode);
        return 1;
    }

    RtlCopyMemory(allocated_mem, shellcode, f_size);

    free(shellcode);

    // Execute shellcode
    int (*fn)();
    fn = (int (*)()) allocated_mem;
    (int)(*fn)();

    VirtualFree(allocated_mem, 0, MEM_RELEASE);

  return 0;
}