.PHONY: all
SRC= 06a 06b
all: $(SRC)
CompileParms = -g -Wall -Wextra -std=c++11
RM = rm -f

06%: 06%.cpp
	g++ $(CompileParms) -o $@ $<

clean:
	$(RM) $(SRC)