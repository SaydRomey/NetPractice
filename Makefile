# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/29 15:17:48 by cdumais           #+#    #+#              #
#    Updated: 2024/02/04 22:21:32 by cdumais          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
#https://medium.com/@imyzf/netpractice-2d2b39b6cf0a
NAME		:=	NetPractice
INC_DIR		:=	inc
SRC_DIR		:=	src
TMP_DIR		:=	tmp
REMOVE		:=	rm -rf
OS			:=	$(shell uname)
NPD			:=	--no-print-directory

all:
	@echo "'make ref' \t-> Open $(NAME) tutorial from $(UNDERLINE)(student)$(RESET)'s github repo"
	@echo "'make video' \t-> Open youtube tutorial on subnetting by $(UNDERLINE)(...)$(RESET)"
	@echo "'make train' \t-> Launch 42's $(BOLD)$(NAME)$(RESET)"
	@echo "'make pdf' \t-> Get a $(NAME) instruction pdf in $(CYAN)$(TMP_DIR)$(RESET)"
	@echo "'make update' \t-> Pull the github version"
	@echo "'make clean' \t-> Remove $(CYAN)$(TMP_DIR)$(RESET) folder"

$(TMP_DIR):
	@mkdir -p $(TMP_DIR)

clean fclean ffclean:
	@if [ -n "$(wildcard $(TMP_DIR))" ]; then \
		$(REMOVE) $(TMP_DIR); \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(CYAN)$(TMP_DIR)$(RESET)$(GREEN) removed$(RESET)"; \
	else \
		echo "[$(BOLD)$(PURPLE)$(NAME)$(RESET)] \
		$(YELLOW)Nothing to remove$(RESET)"; \
	fi

.PHONY: all clean fclean ffclean
# **************************************************************************** #
# ----------------------------------- GIT ------------------------------------ #
# **************************************************************************** #
MAIN_BRANCH	:= $(shell git branch -r | grep -E 'origin/(main|master)' \
					| grep -v 'HEAD' | head -n 1 | sed 's@^.*origin/@@')

update:
	@echo "Updating repository from branch $(CYAN)$(MAIN_BRANCH)$(RESET)..."
	@echo "Are you sure you want to update the repo? [y/N] " \
	&& read ANSWER; \
	if [ "$$ANSWER" = "y" ] || [ "$$ANSWER" = "Y" ]; then \
		git pull origin $(MAIN_BRANCH); \
		echo "Repository updated."; \
	else \
		echo "canceling update..."; \
	fi

.PHONY: update
# **************************************************************************** #
# ---------------------------------- PDF ------------------------------------- #
# **************************************************************************** #
PDF		:= net_practice.pdf
GIT_URL := https://github.com/SaydRomey/42_ressources
PDF_URL = $(GIT_URL)/blob/main/pdf/$(PDF)?raw=true

pdf: | $(TMP_DIR)
	@curl -# -L $(PDF_URL) -o $(TMP_DIR)/$(PDF)
ifeq ($(OS),Darwin)
	@open $(TMP_DIR)/$(PDF)
else
	@xdg-open $(TMP_DIR)/$(PDF) || echo "Please install a compatible PDF viewer"
endif

.PHONY: pdf
# **************************************************************************** #
# --------------------------------- TRAIN ------------------------------------ #
# **************************************************************************** #
TRAIN		:= net_practice.1.5.tgz
TRAIN_URL	:= $(GIT_URL)/raw/main/downloads/$(TRAIN)
PORT		:= 8000
URL			:= http://localhost:$(PORT)/net_practice/

train: | $(TMP_DIR)
	@echo "Downloading and setting up training material..."
	@curl -L $(TRAIN_URL) -o $(TMP_DIR)/$(TRAIN)
	@echo "Extracting tarball..."
	@tar -xzf $(TMP_DIR)/$(TRAIN) -C $(TMP_DIR)
	@echo "Starting local web server on port $(PORT)..."
	@cd $(TMP_DIR) && python3 -m http.server $(PORT) &
	@sleep 2 # Wait for the server to start
	@echo "Opening in Google Chrome..."
ifeq ($(OS),Darwin)
	@open -a "Google Chrome" $(URL)
else
	@xdg-open $(URL) || echo "Could not open Google Chrome. Please open $(URL) manually..."
endif

.PHONY: train
# **************************************************************************** #

# **************************************************************************** #
REF_URL1	:=	https://github.com/lpaube/NetPractice
REF_URL2	:=	https://github.com/DeRuina/NetPractice
VIDEO_URL	:=	https://www.youtube.com/watch?v=5WfiTHiU4x8&list=WL&index=1&t=1s

ref:
	@if [ "$(OS)" = "Darwin" ]; then \
		open -a "Google Chrome" $(REF_URL1); \
		open -a "Google Chrome" $(REF_URL2); \
	else \
		xdg-open $(REF_URL1) || echo "Please install a compatible PDF viewer"; \
		xdg-open $(REF_URL2) || echo "Please install a compatible PDF viewer"; \
	fi

video:
	@if [ "$(OS)" = "Darwin" ]; then \
		open -a "Google Chrome"  $(VIDEO_URL); \
	else \
		xdg-open $(VIDEO_URL) || echo "Please install a compatible PDF viewer"; \
	fi

.PHONY: ref video
# **************************************************************************** #
ESC			:= \033

# Text
RESET		:= $(ESC)[0m
BOLD		:= $(ESC)[1m
ITALIC		:= $(ESC)[3m
UNDERLINE	:= $(ESC)[4m

BLACK		:= $(ESC)[30m
RED			:= $(ESC)[91m
GREEN		:= $(ESC)[32m
YELLOW		:= $(ESC)[93m
ORANGE		:= $(ESC)[38;5;208m
BLUE		:= $(ESC)[94m
PURPLE		:= $(ESC)[95m
CYAN		:= $(ESC)[96m

# Cursor movement
UP			:= $(ESC)[A

# Erasing
ERASE_LINE	:= $(ESC)[2K
