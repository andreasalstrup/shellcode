#include <iostream>
#include <vector>
#include <sstream>
#include <cassert>
#include <fstream>

using shellcode_t = std::vector<unsigned char>;

class ShellcodeEncoder {
  shellcode_t hexVec{};

  public:
  ShellcodeEncoder(shellcode_t hexVec): hexVec{hexVec} { }

  ShellcodeEncoder& encode() {
    for (auto& byte : hexVec) {
      byte = byte ^ 0xF;
      byte = byte ^ 0x7;
      byte = byte + 0x13;
      byte = byte ^ 0x39;
    }
    return *this;
  }

  ShellcodeEncoder& decode() {
    for (auto& byte : hexVec) {
      byte = byte ^ 0x39;
      byte = byte - 0x13;
      byte = byte ^ 0x7;
      byte = byte ^ 0xF;
    }
    return *this;
  }

  friend std::ostream& operator<<(std::ostream& os, const ShellcodeEncoder& shellcode_encoder) {
      for (auto& byte : shellcode_encoder.hexVec) {
        os << "0x" << std::hex << static_cast<int>(byte) << ",";
      }
      return os;
  }
};

int main(int argc, char **argv) {
    char *shell_code_path = argv[1];

    std::ifstream file(shell_code_path, std::ios::binary);
    if (!file) {
        std::cerr << "Failed to open file: " << shell_code_path << std::endl;
        return 1;
    }

    shellcode_t shellcode((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    auto shellcode_encoder = ShellcodeEncoder{shellcode};

    // Encode
    std::cout << shellcode_encoder.encode();

    // Decode
    std::stringstream stream;
    stream << shellcode_encoder.decode();

    // Test that decoding works
    std::stringstream testStream;
    auto shellcode_encoder_test = ShellcodeEncoder{shellcode};
    testStream << shellcode_encoder_test;
    assert(stream.str() == testStream.str());

    return 0;
}