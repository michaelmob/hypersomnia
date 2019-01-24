ifndef PREFIX
	PREFIX=$(HOME)/.local/bin
	ifeq ($(USER),root)
		PREFIX=/usr/local/bin
	endif
endif
UID=$(shell id -u)

.PHONY: all build install clean

all: build

build: build-xgetidle

build-xgetidle:
	gcc ./xgetidle.c -o xgetidle -lX11 -lXss

install: all
	mkdir -p $(PREFIX)
	cp hypersomnia $(PREFIX)/hypersomnia
	mv xgetidle $(PREFIX)/xgetidle

uninstall:
	rm $(PREFIX)/hypersomnia
	rm $(PREFIX)/xgetidle

clean:
	rm xgetidle

readme:
	./hypersomnia --$(arg) | sed \
		-e 's,\x1B\[[0-9;]*[a-zA-Z],,g' \
		-e '/^  / s/^  //g' \
		-e '/HS_NETWORK_DEVICE/ s/: .*/: auto/g' \
		-e '/[-/]$(UID)\./ s/$(UID)/$$UID/g' \
		-e '/\/$(UID)\// s/$(UID)/$$UID/g' \
		-e '/\/home\// s/\/home\/$(USER)\//$$HOME\//g'

test:
	HS_DEBUG=1 \
	HS_NOTIFY_SECONDS=5 \
	HS_LOCK_SECONDS=0 \
	HS_SCREEN_OFF_SECONDS=10 \
	HS_SLEEP_SECONDS=15 \
	HS_INHIBITORS='none' \
		./hypersomnia
