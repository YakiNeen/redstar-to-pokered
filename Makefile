MD5 := md5sum -c

ifneq ($(wildcard rgbds/.*),)
RGBDS = rgbds/
else
RGBDS =
endif

redstar_obj := audio_red.o main_red.o text_red.o wram_red.o
bluestar_obj := audio_blue.o main_blue.o text_blue.o wram_blue.o

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all clean tidy red blue compare tools

roms := redstar.gbc bluestar.gbc

all: $(roms)
red: redstar.gbc
blue: bluestar.gbc

# For contributors to make sure a change didn't affect the contents of the rom.
compare: red blue
	@$(MD5) roms.md5

clean:
	rm -f $(roms) $(redstar_obj) $(bluestar_obj) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -exec rm {} +
	$(MAKE) clean -C tools/

tidy:
	rm -f $(roms) $(redstar_obj) $(bluestar_obj) $(roms:.gbc=.sym)
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/


# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))
endif


%.asm: ;

%_red.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(redstar_obj): %_red.o: %.asm $$(dep)
	$(RGBDS)rgbasm -D _RED -h -o $@ $*.asm

%_blue.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(bluestar_obj): %_blue.o: %.asm $$(dep)
	$(RGBDS)rgbasm -D _BLUE -h -o $@ $*.asm

redstar_opt  = -jsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "PKMN RED STAR"
bluestar_opt = -jsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "PKMN BLUE STAR"

%.gbc: $$(%_obj)
	$(RGBDS)rgblink -d -n $*.sym -l layout.link -o $@ $^
	$(RGBDS)rgbfix $($*_opt) $@
	sort $*.sym -o $*.sym

gfx/blue/intro_purin_1.2bpp: rgbgfx += -h
gfx/blue/intro_purin_2.2bpp: rgbgfx += -h
gfx/blue/intro_purin_3.2bpp: rgbgfx += -h
gfx/red/intro_nido_1.2bpp: rgbgfx += -h
gfx/red/intro_nido_2.2bpp: rgbgfx += -h
gfx/red/intro_nido_3.2bpp: rgbgfx += -h

gfx/game_boy.2bpp: tools/gfx += --remove-duplicates
gfx/theend.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace

%.png: ;

%.2bpp: %.png
	$(RGBDS)rgbgfx $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)
%.1bpp: %.png
	$(RGBDS)rgbgfx -d1 $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)
%.pic:  %.2bpp
	tools/pkmncompress $< $@
