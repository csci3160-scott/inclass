# CSCI 3160 In-Class Code

This repository contains the runnable examples used during CSCI 3160
lectures. The source examples are selected from the official CS:APP 3e code
archives and remain close to the versions referenced by Bryant and O'Hallaron.

## Source and provenance

The upstream source inventory is published at:

<https://csapp.cs.cmu.edu/3e/code.html>

The C files under `examples/` and the shared support files under `support/`
are imported from that inventory. The topic directories preserve the CS:APP
chapter organization while keeping the course's selected subset small enough
to use in class. Local build files and walkthrough notes are course-owned.

The imported source retains its original copyright notices. See `NOTICE` for
the repository-level attribution and source mapping. Generated binaries,
object files, and manuscript-build artifacts do not belong in this repository.

The Docker-based build and classroom commands use the compatibility build
settings documented by the repository Makefile. The copied CS:APP support
library renames its helper `gai_error` to `csapp_gai_error` because modern
glibc declares a different function with that name.

The image builds for the host architecture by default. Set
`DOCKER_PLATFORM=linux/amd64` when an x86-64 Docker builder or registered
emulation is available; the course CI runner validates the x86-64 build.

See [WALKTHROUGHS.md](WALKTHROUGHS.md) for the short classroom sequences and
the examples that are intentionally excluded from automated smoke tests.

## Student workflow

The normal workflow is deliberately small. Build all of the examples once:

```bash
make build
```

Then choose an example and a tool. The tool commands use the existing build;
they do not rebuild all examples each time:

```bash
make run PROGRAM=show-bytes
make inspect PROGRAM=branch
make gdb PROGRAM=badcnt ARGS=100000
make valgrind PROGRAM=interpose-linktime
```

Use `make source FILE=examples/data/show-bytes.c` to open source code in the
configured pager. `FILE` can be any source file in the repository. Use
`PAGER=cat` when a non-interactive display is more convenient.

For the first in-depth machine-code walkthrough, use the focused target:

```bash
make demo-asm
```

It builds only the artifacts used by that demo under `build/asm-demo/`. The
branch example accepts a signed integer and prints its result; the `mstore`
example is intentionally built as assembly and relocatable object code so
students can inspect the calling-convention setup and unresolved `mult2`
relocation. The target uses x86-64 GNU assembler syntax in Intel form with
`-O0 -g`, matching the syntax used in the Bomb Lab and Attack Lab inspection
commands. Run `make shell` first when the host does not provide the course
toolchain.

These commands run on the host by default. For a consistent environment with
the compiler, debugger, and analysis tools already installed, enter the
container first:

```bash
make shell
```

The repository is mounted at `/workspace/inclass`; run the same `make`
commands inside the shell. Exit the container with `exit`. `make image` only
builds the image, while `make shell` starts an interactive environment and
`make container-smoke` runs the automated checks in that environment.

### Using tmux

tmux is optional, but useful for comparing source, execution, and analysis:

```bash
tmux new -s csci3160
make shell
```

Inside the container, split panes with `Ctrl-b %` or `Ctrl-b "`, then use one
pane for `make source`, one for `make run`, and one for `make gdb` or
`make valgrind`. Detach with `Ctrl-b d` and return with `tmux attach -t csci3160`.

## Parent repository updates

After a successful CI run on `inclass/main`, the workflow proposes the new
commit in the parent course repository. It updates the automation branch
`automation/update-inclass` and creates or refreshes one pull request against
`csci-3160/csci-3160:main`. The parent repository still controls when the
submodule update is merged.

Repository administrators must add an organization Actions secret named
`COURSE_AUTOMATION_TOKEN` in the producer's Gitea organization. The token needs
permission to clone, push a branch, and create pull requests in the consumer
course repositories. The token is used only by the workflow and is never
stored in the repository.
