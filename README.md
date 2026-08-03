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
