#include <iostream>
#include <iterator>
#include <string>
#include <vector>

int main() {
  int score = 0, nest = 1;
  char ch;
  bool garbage = false, ignoreNext = false;;

  while(std::cin >> ch) {
    if(garbage) {
      if(ignoreNext) {
        ignoreNext = false;
      } else if(ch == '>') {
        garbage = false;
      } else if(ch == '!') {
        ignoreNext = true;
      }
    } else {
      if(ignoreNext) {
        ignoreNext = false;
      } else if(ch == '<') {
        garbage = true;
      } else if(ch == '!') {
        ignoreNext = true;
      } else if(ch == '{') {
        score += nest++;
      } else if(ch == '}') {
        --nest;
      }
    }
  }

  std::cout << "Part 1: " << score << std::endl;

  return 0;
}
