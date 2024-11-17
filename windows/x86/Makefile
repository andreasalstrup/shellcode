run:
	make -f Makefile.shell
	gcc -m32 run_shellcode.c -o run_shellcode.exe
	clear
	.\run_shellcode.exe .\shellcode.bin

shell:
	make -f Makefile.shell

clean:
	rm -r shellcode run_shellcode *.obj *.bin 2>/dev/null