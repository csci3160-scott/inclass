#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

: "${CC:=gcc}"
: "${CFLAGS:=-std=gnu11 -D_GNU_SOURCE -Wall -Wextra -Wpedantic -O0 -g}"
: "${CPPFLAGS:=-Isupport/include}"
: "${LDFLAGS:=}"

bin=build/bin
obj=build/obj
asm=build/asm
mkdir -p "$bin" "$obj" "$asm"

compile() {
	printf '[build] %s\n' "$*"
	"$@"
}

support="$repo/support/src/csapp.c"
support_flags="$CPPFLAGS"
support_lib="$support"

compile "$CC" $CFLAGS $CPPFLAGS examples/intro/hello.c $LDFLAGS -o "$bin/intro-hello"
compile "$CC" $CFLAGS $CPPFLAGS examples/data/show-bytes.c $LDFLAGS -o "$bin/show-bytes"
compile "$CC" $CFLAGS $CPPFLAGS -S examples/asm/010-mstore.c -o "$asm/010-mstore.s"
compile "$CC" $CFLAGS $CPPFLAGS -c examples/asm/010-mstore.c -o "$obj/010-mstore.o"
compile "$CC" $CFLAGS $CPPFLAGS -S examples/asm/120-branch.c -o "$asm/120-branch.s"
compile "$CC" $CFLAGS $CPPFLAGS examples/asm/120-branch.c $LDFLAGS -o "$bin/branch"
compile "$CC" $CFLAGS $CPPFLAGS -c examples/asm/160-fact.c -o "$obj/160-fact.o"
compile "$CC" $CFLAGS -Ddata_t=long -Iexamples/opt -c examples/opt/vec.c -o "$obj/vec.o"

for name in cpfile cpstdin; do
	compile "$CC" $CFLAGS $support_flags "examples/io/$name.c" "$support_lib" $LDFLAGS -pthread -o "$bin/$name"
done

compile "$CC" $CFLAGS examples/link/addvec.c examples/link/main2.c $LDFLAGS -o "$bin/addvec"
compile "$CC" $CFLAGS -fPIC -shared examples/link/addvec.c $LDFLAGS -o "$bin/libvector.so"
compile "$CC" $CFLAGS examples/link/dll.c -ldl $LDFLAGS -o "$bin/dll"
compile "$CC" $CFLAGS examples/link/m.c examples/link/swap.c $LDFLAGS -o "$bin/swap"
compile "$CC" $CFLAGS examples/link/main.c examples/link/sum.c $LDFLAGS -o "$bin/sum"
compile "$CC" $CFLAGS examples/link/interpose/int.c $LDFLAGS -o "$bin/interpose"
compile "$CC" $CFLAGS -DRUNTIME -fPIC -shared examples/link/interpose/mymalloc.c -ldl $LDFLAGS -o "$bin/mymalloc.so"

for name in fork waitpid1 sigsuspend sigintsafe shellex; do
	compile "$CC" $CFLAGS $support_flags "examples/ecf/$name.c" "$support_lib" $LDFLAGS -pthread -o "$bin/$name"
done

compile "$CC" $CFLAGS -Iexamples/vm -c examples/vm/mm.c -o "$obj/mm.o"
compile "$CC" $CFLAGS $support_flags -Iexamples/vm -c examples/vm/memlib.c -o "$obj/memlib.o"

compile "$CC" $CFLAGS $support_flags examples/netp/hostinfo.c "$support_lib" $LDFLAGS -pthread -o "$bin/hostinfo"
compile "$CC" $CFLAGS $support_flags examples/netp/echoclient.c "$support_lib" $LDFLAGS -pthread -o "$bin/echoclient"
compile "$CC" $CFLAGS $support_flags examples/netp/echoserveri.c examples/netp/echo.c "$support_lib" $LDFLAGS -pthread -o "$bin/echoserveri"

for name in hello badcnt hellobug norace psum-local psum-mutex; do
	compile "$CC" $CFLAGS $support_flags "examples/conc/$name.c" "$support_lib" $LDFLAGS -pthread -o "$bin/$name"
done
