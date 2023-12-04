.PHONY: all
SRC= 02a 02b
all: $(SRC)
CompileParms = -g -Wall -Wextra
RM = rm -f

02%: 02%.cpp
	g++ $(CompileParms) -o $@ $<

clean:
	$(RM) $(SRC)