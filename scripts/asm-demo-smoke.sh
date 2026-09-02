#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

./scripts/asm-demo.sh >/dev/null

test "$(build/asm-demo/bin/branch-demo -2)" = 'loop(-2) = -2'
test "$(build/asm-demo/bin/branch-demo 0)" = 'loop(0) = 0'
test "$(build/asm-demo/bin/branch-demo 8)" = 'loop(8) = 0'
test -s build/asm-demo/asm/mstore.s
test -s build/asm-demo/asm/branch.s
test -s build/asm-demo/obj/mstore.o
test -x build/asm-demo/bin/branch-demo

grep -q 'cmp' build/asm-demo/asm/branch.s
grep -q 'jg' build/asm-demo/asm/branch.s
objdump -dr -M intel build/asm-demo/obj/mstore.o |
	grep -q 'R_X86_64_PLT32.*mult2'

printf '%s\n' 'Assembly demo smoke tests passed.'
