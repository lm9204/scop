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
SRCS_CPP =	main.cpp \
			Shader.cpp
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

test_single:
	@if [ -z "$(file)" ]; then \
		echo "Error: Please specify a file (e.g., make build_single file=mvbo.cpp)"; \
		exit 1; \
	fi; \
	file_path=$(SRCS_PATH)/$(file) && \
	obj=$${file_path%.cpp}.o && \
	out=$${file_path%.cpp}_test && \
	echo "Compiling $$file_path..." && \
	$(CXX) $(CXXFLAGS) $$file_path $(SRCS_C) $(LDFLAGS) -o $$out && \
	echo "Running $$out..." && \
	./$$out

clean:
	rm -rf $(OBJS_CPP)
	rm -rf $(OBJS_C)
	rm -rf $(addprefix $(SRCS_PATH)/, $(SRCS_CPP:.cpp=.d))
	rm -rf $(SRCS_C:.c=.d)

clean_test:
	@echo "Cleaning up test binaries..."
	@find $(SRCS_PATH) -type f -name "*_test" -exec rm -f {} \;
	@find $(SRCS_PATH) -type f -name "*_test.d" -exec rm -f {} \;
	@find $(SRCS_PATH) -type d -name "*.dSYM" -exec rm -rf {} \;
	@echo "Test binaries removed."

fclean: clean
	rm -rf $(NAME)

re: fclean all

-include $(addprefix $(SRCS_PATH)/, $(SRCS_CPP:.cpp=.d))
-include $(SRCS_C:.c=.d)

.PHONY: all clean fclean re test_single clean_test