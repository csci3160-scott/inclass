#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

./scripts/asm-demo.sh >/dev/null

set +e
build/asm-demo/bin/step-demo
status=$?
set -e
test "$status" -eq 49
test -s build/asm-demo/obj/step-demo.o
test -x build/asm-demo/bin/step-demo

objdump -dr -M intel build/asm-demo/obj/step-demo.o |
	grep -Eq '\badd[[:space:]]+(eax|rax),'
objdump -dr -M intel build/asm-demo/obj/step-demo.o |
	grep -Eq '\bret'
if objdump -dr -M intel build/asm-demo/obj/step-demo.o |
	grep -Eq '\bcall'; then
	echo 'unexpected call in straight-line main' >&2
	exit 1
fi

printf '%s\n' 'Machine-code demo smoke tests passed.'
