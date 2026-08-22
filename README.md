# CSCI 3160 In-Class Code

This repository contains the code examples we will use during **CSCI 3160: Computer Systems** lectures.

Most examples come from the official *Computer Systems: A Programmer's Perspective (CS:APP), 3rd Edition* code archive and are organized to match the topics we cover in class. You are encouraged to run, modify, debug, and experiment with these programs as we work through the course.

## Getting Started

Clone the repository, then build the examples:

```bash
make build
```

Once the build completes, you can run or inspect individual examples.

```bash
make run PROGRAM=show-bytes
make inspect PROGRAM=branch
make gdb PROGRAM=badcnt ARGS=100000
make valgrind PROGRAM=interpose-linktime
```

The exact examples we use will vary by lecture.

### Viewing Source Code

You can open a source file using:

```bash
make source FILE=examples/data/show-bytes.c
```

`FILE` can be any source file in the repository.

If you prefer to print the file directly to the terminal:

```bash
PAGER=cat make source FILE=examples/data/show-bytes.c
```

## Using the Course Container

The examples can run directly on your system, but the provided Docker environment is the recommended option because it includes the compiler, debugger, and analysis tools used in class.

Start the environment with:

```bash
make shell
```

Inside the container, the repository is available at:

```text
/workspace/inclass
```

You can then use the same commands:

```bash
make build
make run PROGRAM=show-bytes
make inspect PROGRAM=branch
make gdb PROGRAM=badcnt ARGS=100000
make valgrind PROGRAM=interpose-linktime
```

When finished, leave the container with:

```bash
exit
```

A few additional commands you may see are:

```bash
make image
make container-smoke
```

* `make image` builds the course container.
* `make container-smoke` runs automated checks against the examples.

You generally will not need these commands unless instructed to use them.

## Optional: Using tmux

`tmux` is useful when you want several terminals visible at once—for example, source code in one pane, program output in another, and GDB in a third.

Start a session with:

```bash
tmux new -s csci3160
make shell
```

Useful shortcuts include:

* `Ctrl-b %` — split the terminal vertically
* `Ctrl-b "` — split the terminal horizontally
* `Ctrl-b d` — detach from the session

Return to the session later with:

```bash
tmux attach -t csci3160
```

Using `tmux` is completely optional.

## Repository Organization

The repository is organized by course topic. In general:

* `examples/` contains the programs we will examine in class.
* `support/` contains supporting code used by some CS:APP examples.
* `WALKTHROUGHS.md` contains short sequences for selected classroom examples.

You do not need to understand every file in the repository. Focus on the examples referenced during lecture or assigned for further exploration.

## About the Example Code

Many examples in this repository come from the official CS:APP 3e code archive:

https://csapp.cs.cmu.edu/3e/code.html

The imported examples remain close to the versions provided by Bryant and O'Hallaron so that they correspond to the textbook. Some local build files and classroom materials have been added to make the examples easier to use in CSCI 3160.

Original copyright notices are preserved where applicable. Additional attribution and source information can be found in `NOTICE`.

## A Good Way to Use This Repository

Do not treat these examples as programs you simply need to run once.

When we examine an example in class, experiment with it:

1. Read the source code and predict what it will do.
2. Run the program and compare the result with your prediction.
3. Use `make inspect` to examine the generated machine code when appropriate.
4. Step through interesting sections with GDB.
5. Modify the program and see how its behavior or generated code changes.

The goal is to connect the C programs you already know with what the machine is actually doing underneath them.
