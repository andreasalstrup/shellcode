# Run shellcode
run:
	mkdir -p out
	make shell
	xxd -p ./out/shellcode.bin | tr -d '\n' | sed 's/../\ 0x&,/g'
	./out/shellcode_runner.exe ./out/shellcode.bin

# Decode and run encoded shellcode at runtime 
run-decode:
	mkdir -p out
	make shell
	make decode
	xxd -p ./out/shellcode_decoder.bin | tr -d '\n' | sed 's/../\ 0x&,/g'
	./out/shellcode_runner.exe ./out/shellcode_decoder.bin

shell:
	gcc -m32 shellcode_runner.c -o ./out/shellcode_runner.exe
	make -f Makefile.shell TARGET=shellcode

decode:
	g++ ./shellcode_encoder.cpp -o ./out/shellcode_encoder.exe
	make -f Makefile.shell TARGET=shellcode_decoder

clean:
	rm -r ./out