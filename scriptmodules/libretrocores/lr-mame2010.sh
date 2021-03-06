#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-mame2010"
rp_module_desc="Arcade emu - MAME 0.139 port for libretro"
rp_module_help="ROM Extension: .zip\n\nCopy your MAME roms to either $romdir/mame-libretro or\n$romdir/arcade"
rp_module_section="opt"

function depends_lr-mame2010() {
    [[ "$__default_gcc_version" == "4.7" ]] && getDepends gcc-4.8 g++-4.8
}

function sources_lr-mame2010() {
    gitPullOrClone "$md_build" https://github.com/libretro/mame2010-libretro.git
}

function build_lr-mame2010() {
    make clean
    local params=()
    isPlatform "arm" && params+=("VRENDER=soft" "ARM_ENABLED=1")
    make "${params[@]}" ARCHOPTS="$CFLAGS" buildtools
    if [[ "$__default_gcc_version" == "4.7" ]]; then
        make "${params[@]}" ARCHOPTS="$CFLAGS" CC="gcc-4.8" CXX="g++-4.8"
    else
        make "${params[@]}" ARCHOPTS="$CFLAGS"
    fi
}

function install_lr-mame2010() {
    md_ret_files=(
        'mame2010_libretro.so'
        'README.txt'
        'whatsnew.txt'
        'mame.ini'
    )
}

function configure_lr-mame2010() {
    mkRomDir "arcade"
    mkRomDir "mame-libretro"
    ensureSystemretroconfig "arcade"
    ensureSystemretroconfig "mame-libretro"

    addSystem 0 "$md_id" "arcade" "$md_inst/mame2010_libretro.so"
    addSystem 0 "$md_id" "mame-libretro arcade mame" "$md_inst/mame2010_libretro.so"
}
