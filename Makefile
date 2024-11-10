run:
	make -f Makefile.shell
	gcc -fno-stack-protector -z execstack run_shellcode.c -o run_shellcode
	clear
	./run_shellcode shellcode.bin

shell:
	make -f Makefile.shell

clean:
	rm -r shellcode run_shellcode *.o *.bin 2>/dev/null

