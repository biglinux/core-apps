# Makefile for ubiquity-slideshow-kaiana

SOURCE=.
BUILD=$(SOURCE)/build
SOURCESLIDES=$(SOURCE)/slideshows

all: clean build_kaiana translations

build_init:
	mkdir -p $(BUILD)

build_kaiana: build_init
	cp -rL $(SOURCESLIDES)/kaiana $(BUILD)

translations:
	python generate-local-slides.py kaiana

.PHONY : clean

clean:
	-rm -rf $(BUILD)
