#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

make build
printf '\n==> Source: examples/intro/hello.c\n'
sed -n '1,80p' examples/intro/hello.c
printf '\n==> Program output\n'
build/bin/intro-hello
printf '\n==> Disassembly of main (objdump)\n'
objdump -d -M intel build/bin/intro-hello | sed -n '/<main>:/,/^$/p'
printf '\n==> GDB source: scripts/intro-gdb.gdb\n'
printf '==> Starting GDB: breakpoint main, disassemble, three nexti steps, then continue\n\n'
exec gdb -q -x scripts/intro-gdb.gdb
