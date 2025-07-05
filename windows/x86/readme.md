# Windows x86 Shellcode
This repository contains the necessary steps to create custom shellcode for Windows x86. 
Creating shellcode can be a tedious process, as memory addresses must be resolved at runtime. This simple framework makes it easy to write and run shellcode iteratively.

## Prerequisites
* [Install MinGW-64 toolchain](https://code.visualstudio.com/docs/cpp/config-mingw#_installing-the-mingww64-toolchain)
```powershell
# install 32-bit target architecture, make, xxd, ld, tr, sed, awk
pacman -S --needed base-devel mingw-w64-i686-toolchain vim coreutils binutils nasm
```
* Add `C:\msys64\ucrt64\bin` and `C:\msys64\usr\bin` to `PATH`.

## Run
Run shellcode as is:
1. Write custom shellcode in `./src/shellcode.asm`.
2. `make run`

Encode shellcode and test that shellcode decodes at runtime:
1.  Write custom shellcode in `./src/shellcode.asm`.
2.  Adjust `encode()` and `decode()` in `shellcode_encoder.cpp`
3. `make run-decode` 

### Makefile Targets
```bash
# Run shellcode
make run

# Run encoded shellcode by decoding at runtime 
make run-decode

# Remove artifacts
make clean
```

## Use shellcode
The shellcode in `./out/shellcode.bin` and/or `.out/shellcode-decoder.bin` can then be injected into a PE.

## Resources
* https://www.ired.team/offensive-security/code-injection-process-injection/writing-custom-shellcode-encoders-and-decoders
* https://www.ired.team/offensive-security/code-injection-process-injection/backdooring-portable-executables-pe-with-shellcode
* https://samsclass.info/127/proj/PMA404.htm