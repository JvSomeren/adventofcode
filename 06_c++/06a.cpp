#include <iostream>
#include <iterator>
#include <string>
#include <vector>

std::string convertToString(const std::vector<int> mem) {
  std::string state = "";
  int i, n = mem.size();

  for(i = 0; i < n; i++) {
    state += std::to_string(mem[i]) + ".";
  }

  return state;
}

bool isMemInStates(const std::vector<std::string> &states, const std::vector<int> mem) {
  std::string state = convertToString(mem);
  int i, n = states.size();

  for(i = 0; i < n; i++) {
    if(state == states[i])
      return true;
  }

  return false;
}

void addToStates(std::vector<std::string> &states, std::vector<int> mem) {
  states.push_back(convertToString(mem));
}

int getHighestBank(const std::vector<int> mem) {
  int i, n = mem.size(), bank, highest = -1;

  for(i = 0; i < n; i++) {
    if(mem[i] > highest) {
      bank = i;
      highest = mem[i];
    }
  }

  return bank;
}

void redistribute(std::vector<int> &mem, int bank) {
  int blocks = mem[bank], n = mem.size();

  mem[bank++] = 0;
  while(blocks > 0) {
    mem[bank % n] += 1;
    --blocks;
    ++bank;
  }
}

int main() {
  std::vector<int> mem {std::istream_iterator<int>{std::cin}, {}};
  std::vector<std::string> states;
  int cycles = 0;

  while(!isMemInStates(states, mem)) {
    addToStates(states, mem);

    redistribute(mem, getHighestBank(mem));

    ++cycles;
  }

  std::cout << "Part 1: " << cycles << std::endl;

  return 0;
}
