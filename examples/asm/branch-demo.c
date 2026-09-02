#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

long loop(long x)
{
    while (x > 0) {
        x = x >> 1;
    }
    return x;
}

int main(int argc, char **argv)
{
    char *end;
    long input;

    if (argc != 2) {
        fprintf(stderr, "usage: %s INTEGER\n", argv[0]);
        return 2;
    }

    errno = 0;
    end = NULL;
    input = strtol(argv[1], &end, 10);
    if (errno != 0 || end == argv[1] || *end != '\0') {
        fprintf(stderr, "invalid integer: %s\n", argv[1]);
        return 2;
    }

    printf("loop(%ld) = %ld\n", input, loop(input));
    return 0;
}
