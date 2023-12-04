#include <iostream>
#include <sstream>
#include <vector>

const int ARRAY_SIZE = 100;

int main () {
  std::string line, tmp;
  int depth, range;
  int severity = 0, firewall[ARRAY_SIZE][2];
  unsigned int i, j;

  for(i = 0; i < ARRAY_SIZE; i++)
    for(j = 0; j < ARRAY_SIZE; j++)
      firewall[i][j] = 0;
  
  while(getline(std::cin, line)) {
    std::istringstream iss(line);

    while(iss >> tmp >> range) {
      depth = std::stoi(tmp.erase(tmp.size()-1, 1));
      firewall[depth][0] = range;
      firewall[depth][1] = 1;
    }
  }

  for(i = 0; i <= depth; i++) {
    if(firewall[i][1] == 0)
      continue;

    // if(firewall[i][1] == 1)
    //   severity += i * firewall[i][0];

    if(i % (firewall[i][0] - 1))
      severity += i * firewall[i][0];

    std::cout << i << ": " << firewall[i][0] << std::endl;
  }

  std::cout << "Part 1: " << severity << std::endl;

  return 0;
}