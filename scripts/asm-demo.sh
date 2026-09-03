#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

: "${CC:=gcc}"
: "${CFLAGS:=-std=gnu11 -D_GNU_SOURCE -Wall -Wextra -Wpedantic -O0 -g -fno-omit-frame-pointer}"

machine=$(uname -m)
os=$(uname -s)
if [ "$os" != Linux ] || [ "$machine" != x86_64 ]; then
	printf '%s\n' "This demo requires x86-64 Linux (found $os/$machine)." >&2
	exit 2
fi

root=build/asm-demo
asm="$root/asm"
obj="$root/obj"
bin="$root/bin"
mkdir -p "$asm" "$obj" "$bin"

# Remove old focused-demo artifacts so a rerun cannot present stale output.
rm -f "$asm/mstore.s" "$asm/branch.s" "$obj/mstore.o" "$bin/branch-demo"

compile() {
	printf '[asm-demo] %s\n' "$*"
	"$@"
}

compile "$CC" $CFLAGS -masm=intel -c \
	examples/asm/step-demo.c -o "$obj/step-demo.o"
compile "$CC" $CFLAGS -masm=intel \
	examples/asm/step-demo.c -o "$bin/step-demo"

printf '%s\n' 'Machine-code demo artifacts are ready.'
