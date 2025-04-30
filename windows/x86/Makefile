# Run shellcode
run:
	mkdir -p out
	make shell
	xxd -p ./out/shellcode.bin | tr -d '\n' | sed 's/../\ 0x&,/g'
	./out/shellcode_runner.exe ./out/shellcode.bin

# Run encoded shellcode by decoding at runtime 
run-decode:
	mkdir -p out
	make shell
	make decode
	xxd -p ./out/shellcode_decoder.bin | tr -d '\n' | sed 's/../\ 0x&,/g'
	./out/shellcode_runner.exe ./out/shellcode_decoder.bin

shell:
	gcc -m32 ./src/shellcode_runner.c -o ./out/shellcode_runner.exe
	make -f Makefile.shell TARGET=shellcode

decode:
	g++ ./src/shellcode_encoder.cpp -o ./out/shellcode_encoder.exe
	make -f Makefile.shell TARGET=shellcode_decoder

clean:
	rm -r ./out