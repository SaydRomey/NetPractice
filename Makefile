# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cdumais <cdumais@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/29 15:17:48 by cdumais           #+#    #+#              #
#    Updated: 2024/02/14 16:02:21 by cdumais          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

.PHONY: all clean fclean ffclean update pdf net ref video man ipcalc

NAME		:=	NetPractice
INC_DIR		:=	inc
SRC_DIR		:=	src
TMP_DIR		:=	tmp
REMOVE		:=	rm -rf
OS			:=	$(shell uname)
NPD			:=	--no-print-directory

all: man

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
# **************************************************************************** #

# **************************************************************************** #
OPEN		:=
OPEN_URL	:=
BROWSER		:= Google Chrome

ifeq ($(OS),Darwin)
	OPEN := open
	OPEN_URL := open -a "$(BROWSER)"
else
	OPEN := xdg-open
	OPEN_URL := xdg-open
endif

# **************************************************************************** #
# ---------------------------------- PDF ------------------------------------- #
# **************************************************************************** #
PDF		:= net_practice.pdf
GIT_URL := https://github.com/SaydRomey/42_ressources
PDF_URL = $(GIT_URL)/blob/main/pdf/$(PDF)?raw=true

pdf: | $(TMP_DIR)
	@curl -# -L $(PDF_URL) -o $(TMP_DIR)/$(PDF)
	@echo "Opening instruction pdf $(TMP_DIR)/$(PDF)"
	@$(OPEN) $(TMP_DIR)/$(PDF)

# **************************************************************************** #
# ---------------------------------- NET ------------------------------------- #
# **************************************************************************** #
TRAIN		:= net_practice.1.5.tgz
TRAIN_URL	:= $(GIT_URL)/raw/main/downloads/$(TRAIN)
PORT		:= 8000
URL			:= http://localhost:$(PORT)/net_practice/index.html

net: | $(TMP_DIR)
	@echo "Downloading and setting up training material..."
	@curl -L $(TRAIN_URL) -o $(TMP_DIR)/$(TRAIN)
	@echo "Extracting tarball..."
	@tar -xzf $(TMP_DIR)/$(TRAIN) -C $(TMP_DIR)
	@echo "Starting local web server on port $(PORT)..."
	@cd $(TMP_DIR) && python3 -m http.server $(PORT) &
	@sleep 2 # Wait for the server to start
	@echo "Opening in $(BROWSER)..."
	@$(OPEN_URL) $(URL)
# **************************************************************************** #
# --------------------------- LEARNING MATERIAL ------------------------------ #
# **************************************************************************** #
REF_URL1	:=	https://github.com/lpaube/NetPractice
REF_URL2	:=	https://github.com/iimyzf/NetPractice

REF_URL3	:=	https://www.codequoi.com/en/internet-layered-network-architecture/
REF_URL4	:=	https://www.codequoi.com/en/ipv4-addresses-routing-and-subnet-masks/

ref:
	@$(OPEN_URL) $(REF_URL1)
	@$(OPEN_URL) $(REF_URL2)
	@$(OPEN_URL) $(REF_URL3)
	@$(OPEN_URL) $(REF_URL4)


VIDEO_URL	:=	https://www.youtube.com/watch?v=5WfiTHiU4x8&list=WL&index=1&t=1s

video:
	@echo "Launching Youtube tutorial on Subnetting"
	@$(OPEN_URL) $(VIDEO_URL)

# **************************************************************************** #
# **************************************************************************** #
man:
	@echo "$$man"

define man

'make ref'    -> Open $(NAME) learning material from

$(UNDERLINE)lpaube$(RESET)
$(UNDERLINE)azabir$(RESET)
$(UNDERLINE)mcombeau$(RESET)

'make video'  -> Open youtube tutorial on subnetting by $(UNDERLINE)NetworkChuck$(RESET)

'make net'    -> Launch 42's $(BOLD)$(NAME)$(RESET)
'make pdf'    -> Get a $(NAME) instruction pdf in $(CYAN)$(TMP_DIR)$(RESET)
'make update' -> Pull the github version"
'make clean'  -> Remove $(CYAN)$(TMP_DIR)$(RESET) folder
'make man'    -> Show this message

endef

export man
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
