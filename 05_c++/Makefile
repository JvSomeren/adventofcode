.PHONY: all
SRC= 05a
all: $(SRC)
CompileParms = -g -Wall -Wextra -std=c++11
RM = rm -f

05%: 05%.cpp
	g++ $(CompileParms) -o $@ $<

clean:
	$(RM) $(SRC)