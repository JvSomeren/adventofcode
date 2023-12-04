.PHONY: all
SRC= 05a 05b
all: $(SRC)
CompileParms = -g -Wall -Wextra -std=c++11
RM = rm -f

05%: 05%.cpp
	g++ $(CompileParms) -o $@ $<

clean:
	$(RM) $(SRC)