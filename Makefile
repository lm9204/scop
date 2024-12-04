CXX = c++
INCLUDE = -I dependencies/include
LDFLAGS = -L dependencies/library \
          dependencies/library/libglfw.3.4.dylib \
          -framework OpenGL \
          -framework Cocoa \
          -framework IOKit \
          -framework CoreVideo \
          -framework CoreFoundation
CXXFLAGS = -Wall -Wdeprecated -MMD -MP -g3 -std=c++17 $(INCLUDE)
CFLAGS = $(CXXFLAGS)
SRCS_C = dependencies/glad.c
SRCS_CPP = main.cpp
SRCS_PATH = srcs
# SRCS = $(SRCS_CPP) $(SRCS_C)
OBJS_CPP = $(addprefix $(SRCS_PATH)/, $(SRCS_CPP:.cpp=.o))
OBJS_C = $(SRCS_C:.c=.o)
NAME = scop

all: $(NAME)

$(NAME): $(OBJS_CPP) $(OBJS_C)
	$(CXX) $(OBJS_CPP) $(OBJS_C) $(LDFLAGS) -o $(NAME)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.c
	$(CXX) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJS_CPP)
	rm -rf $(OBJS_C)
	rm -rf $(addprefix $(SRCS_PATH)/, $(SRCS_CPP:.cpp=.d))
	rm -rf $(SRCS_C:.c=.d)

fclean: clean
	rm -rf $(NAME)

re: fclean all

-include $(addprefix $(SRCS_PATH)/, $(SRCS_CPP:.cpp=.d))
-include $(SRCS_C:.c=.d)

.PHONY: all clean fclean re