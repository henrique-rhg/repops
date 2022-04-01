NAME = repops
CC = gcc
C_FLAGS = -Wall -g
H_FLAGS = -lm
PREFIX = /usr/local/
BINARY_DIR = $(PREFIX)/bin
SOURCE_DIR = src
DESTINY_DIR = dist
SOURCES = $(wildcard $(SOURCE_DIR)/*.c)
OBJECTS = $(SOURCES:%.c=%.o)
DEPENDS = $(SOURCES:%.c=%.d)


-include $(DEPENDS)

all: 

prepare: all
	@-mkdir -p $(DESTINY_DIR)/cache$(BINARY_DIR)
	@-cp -rf data/* $(DESTINY_DIR)/cache

$(NAME)_%: prepare
	@-mkdir -p $(DESTINY_DIR)/$(@)
	@-cp -rf $(DESTINY_DIR)/cache/* $(DESTINY_DIR)/$(@)
	dpkg-deb -b $(DESTINY_DIR)/$(@) $(DESTINY_DIR)/$(@).deb
	@-rm -rf $(DESTINY_DIR)/$(@)

clean:
	@-rm -rf $(SOURCE_DIR)/*.d $(SOURCE_DIR)/*.o $(SOURCE_DIR)/*/*.o
	@-rm -rf $(DESTINY_DIR)

%.o: %.c
	$(CC)  $(C_FLAGS) -c -o $@ $<

%.d: %.c
	@set -e
	@echo $(filter-out $(^),$(patsubst %.h,%.o,$(shell $(CC) -MM $(^) -MT $(patsubst $(SOURCE_DIR)/%,$(NAME)-%,$(*))))) > $@

$(NAME)-%:
	@-mkdir -p $(DESTINY_DIR)/cache$(BINARY_DIR)
	$(CC) -o $(DESTINY_DIR)/cache$(BINARY_DIR)/$(@) $(^) $(H_FLAGS)
