#include <iostream>
#include <sstream>
#include <vector>

std::vector< std::vector<int> > inputToVector() {
  std::string line;
  int num;
  std::vector< std::vector<int> > v2d;

  while(getline(std::cin, line)) {
    std::istringstream iss(line);
    std::vector<int> row;
    
    while(iss >> num) {
      row.push_back(num);
    }

    v2d.push_back(row);
  }

  return v2d;
}

int main () {
  int checksum = 0, low, high;
  unsigned int i, j;
  std::vector <std::vector<int> > spreadsheet;
  
  spreadsheet = inputToVector();

  for(i = 0; i < spreadsheet.size(); i++) {
    low = high = spreadsheet[i][0];

    for(j = 0; j < spreadsheet[i].size(); j++) {
      if(spreadsheet[i][j] < low)
        low = spreadsheet[i][j];

      if(spreadsheet[i][j] > high)
        high = spreadsheet[i][j];
    }

    checksum += high - low;
  }

  std::cout << "Part 1: " << checksum << std::endl;

  return 0;
}