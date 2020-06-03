

#include "lrbuf.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *str = (char *)malloc(1 << 16);
    if (NULL == str) {
        printf("malloc err\n");
        return (~0);
    }
    memset(str, 0x00, 1 << 16);
    rbuf_handle_t handle = rbuf_new(16);
    printf("rbuf_size: (%u).\n", rbuf_size(handle));
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    printf("rbuf_used: (%d).\n", rbuf_put_block(handle, "abcd", 4));
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    printf("rbuf_used: (%d).\n", rbuf_put_block(handle, str, 1 << 17));
    printf("rbuf_used: (%d).\n", rbuf_put_block(handle, "abcd", 4));
    printf("rbuf_used: (%d).\n", rbuf_put_block(handle, "efgh", 4));
    memset(str, 0x00, 8);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_read(handle, str, 3), str);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_read(handle, str, 4), str);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_read(handle, str, 5), str);
    memset(str, 0x00, 8);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    printf("rbuf_used: (%d).\n", rbuf_put_block(handle, str, 1 << 16));
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    printf("rbuf_used: (%d), str: (%s).\n", rbuf_get(handle, str, 4), str);
    rbuf_del(handle);
    free(str);

    return (0);
}
