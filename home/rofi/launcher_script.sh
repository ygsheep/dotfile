#!/usr/bin/env bash
launcher="~/.config/rofi/theme.rasi"
term="kitty"
rofi \
	-show drun \
	-terminal $term \
	-kb-cancel Escape \
	-theme $launcher
