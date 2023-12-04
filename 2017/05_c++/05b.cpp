#include <iostream>
#include <iterator>
#include <vector>

int main() {
  std::vector<int> inst {std::istream_iterator<int>{std::cin}, {}};
  int steps = 0,
      n = 0,
      len = inst.size();

  while(n < len) {
    ++steps;
    if(inst[n] >= 3)
      n += inst[n]--;
    else
      n += inst[n]++;
  }

  std::cout << "Part 2: " << steps << std::endl;

  return 0;
}
