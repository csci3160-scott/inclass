set pagination off
set confirm off
set disassemble-next-line on
file build/bin/intro-hello
break main
run
printf "\n[GDB] main is stopped before its first instruction.\n"
disassemble /m main
display/i $pc
info registers rip rbp rsp
printf "\n[GDB] Step through main one machine instruction at a time.\n"
nexti
nexti
nexti
info registers rip rbp rsp
printf "\n[GDB] Continue until the program exits.\n"
continue
quit
