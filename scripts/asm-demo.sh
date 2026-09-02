#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

: "${CC:=gcc}"
: "${CFLAGS:=-std=gnu11 -D_GNU_SOURCE -Wall -Wextra -Wpedantic -O0 -g -fno-omit-frame-pointer}"

machine=$(uname -m)
if [ "$machine" != x86_64 ]; then
	printf '%s\n' "This demo requires x86-64 Linux (found $machine)." >&2
	exit 2
fi

root=build/asm-demo
asm="$root/asm"
obj="$root/obj"
bin="$root/bin"
mkdir -p "$asm" "$obj" "$bin"

compile() {
	printf '[asm-demo] %s\n' "$*"
	"$@"
}

compile "$CC" $CFLAGS -masm=intel -S \
	examples/asm/010-mstore.c -o "$asm/mstore.s"
compile "$CC" $CFLAGS -masm=intel -c \
	examples/asm/010-mstore.c -o "$obj/mstore.o"
compile "$CC" $CFLAGS -masm=intel -S \
	examples/asm/branch-demo.c -o "$asm/branch.s"
compile "$CC" $CFLAGS -masm=intel \
	examples/asm/branch-demo.c -o "$bin/branch-demo"

printf '%s\n' 'Assembly demo artifacts are ready.'
