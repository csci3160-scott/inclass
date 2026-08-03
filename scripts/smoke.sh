#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"
bin=build/bin

test "$("$bin/intro-hello")" = "hello, world"
"$bin/show-bytes" 2>/dev/null || true
printf 'alpha\nbeta\n' | "$bin/cpstdin" > build/cpstdin.out
test "$(cat build/cpstdin.out)" = "alpha
beta"
printf 'line one\nline two\n' | "$bin/cpfile" > build/cpfile.out
test "$(cat build/cpfile.out)" = "line one
line two"
"$bin/branch" >/dev/null || true
"$bin/addvec" >/dev/null
(cd "$bin" && ./dll >/dev/null)
"$bin/interpose-linktime" >/dev/null
"$bin/interpose-compiletime" >/dev/null
"$bin/swap" || true
"$bin/sum" || true
"$bin/fork" >/dev/null
"$bin/waitpid1" >/dev/null
"$bin/hostinfo" localhost >/dev/null
"$bin/hello" >/dev/null
"$bin/psum-local" 2 8 >/dev/null
"$bin/psum-mutex" 2 8 >/dev/null
printf '%s\n' 'In-class smoke tests passed.'
