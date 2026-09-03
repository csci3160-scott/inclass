int main(void)
{
    unsigned char byte = 2;
    short half = 3;
    int word = 4;
    long value = 40;
    long *p = &value;

    value = value + byte;
    *p = *p + half;
    *p = *p + word;

    return (int)*p;
}
