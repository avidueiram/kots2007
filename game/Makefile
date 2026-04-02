CC ?= gcc

TARGET ?= gamei386.so

SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

MYSQL_CFLAGS := $(shell mysql_config --cflags 2>/dev/null || echo -I/usr/include/mysql)
MYSQL_LIBS := $(shell mysql_config --libs 2>/dev/null || echo -lmysqlclient)
CURL_CFLAGS := $(shell pkg-config --cflags libcurl 2>/dev/null)
CURL_LIBS := $(shell pkg-config --libs libcurl 2>/dev/null || echo -lcurl)

CPPFLAGS += -I. $(MYSQL_CFLAGS) $(CURL_CFLAGS)
CFLAGS += -std=gnu89 -fPIC -fcommon -O0 -g -Wall -Wextra -Wno-unused-parameter
LDFLAGS += -shared
LDLIBS += $(MYSQL_LIBS) $(CURL_LIBS) -lpthread -lm -ldl

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
