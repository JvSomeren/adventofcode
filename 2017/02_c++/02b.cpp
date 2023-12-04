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
  int checksum = 0;
  unsigned int i, j, k;
  std::vector <std::vector<int> > spreadsheet;
  
  spreadsheet = inputToVector();

  for(i = 0; i < spreadsheet.size(); i++) {
    for(j = 0; j < spreadsheet[i].size(); j++)
      for(k = 0; k < spreadsheet[i].size(); k++)
        if(spreadsheet[i][j] % spreadsheet[i][k] == 0 && j != k)
          checksum += spreadsheet[i][j] / spreadsheet[i][k];
  }

  std::cout << "Part 2: " << checksum << std::endl;

  return 0;
}