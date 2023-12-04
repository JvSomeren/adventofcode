.PHONY: all
SRC= 13a
all: $(SRC)
CompileParms = -g -Wall -Wextra
RM = rm -f

02%: 02%.cpp
	g++ $(CompileParms) -o $@ $<

clean:
	$(RM) $(SRC)