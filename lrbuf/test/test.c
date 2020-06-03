
#include "CuTest.h"
#include <stdlib.h>
#include <string.h>
#include "lrbuf.h"

void Testrbuf_set_size_with_init(CuTest *tc)
{
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (1U << 12) == rbuf_size(rb));
    rbuf_del(rb);
}

void Testrbuf_is_empty_after_init(CuTest *tc)
{
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (0U) == rbuf_used(rb));
    rbuf_del(rb);
}

void Testrbuf_is_not_empty_after_put(CuTest *tc)
{
    rbuf_handle_t rb = rbuf_new(12);
    rbuf_put_block(rb, (unsigned char *)"abcd", 4);
    CuAssertTrue(tc, (4U) == rbuf_used(rb));
    rbuf_del(rb);
}

void Testrbuf_is_empty_after_put_get(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    rbuf_put_block(rb, (unsigned char *)"abcd", 4);
    rbuf_get(rb, buf, 4);
    CuAssertTrue(tc, (0U) == rbuf_used(rb));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_cant_put_if_not_enough_space(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (~0U) == rbuf_put_block(rb, buf, 1 << 13));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_can_put_if_buffer_will_be_completely_full(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (1U << 12) == rbuf_put_block(rb, buf, 1 << 12));
    CuAssertTrue(tc, (0U) == (rbuf_size(rb) - rbuf_used(rb)));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_put_and_get(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    rbuf_put_block(rb, (unsigned char *)"abcd", 4);
    rbuf_get(rb, buf, 4);
    CuAssertTrue(tc, (0) == strncmp("abcd", buf, 4));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_cant_get_nonexistant(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (~0U) == rbuf_get(rb, buf, 4));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_cant_read_nonexistant(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    CuAssertTrue(tc, (~0U) == rbuf_read(rb, buf, 4));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_cant_get_twice_when_released(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    rbuf_put_block(rb, (unsigned char *)"abcd", 4);
    rbuf_get(rb, buf, 4);
    CuAssertTrue(tc, (~0U) == rbuf_get(rb, buf, 4));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_can_read_twice_when_released(CuTest *tc)
{
    char *buf = (char *)malloc(1 << 12);
    rbuf_handle_t rb = rbuf_new(12);
    rbuf_put_block(rb, (unsigned char *)"abcd", 4);
    rbuf_read(rb, buf, 4);
    CuAssertTrue(tc, (~0U) != rbuf_read(rb, buf, 4));
    CuAssertTrue(tc, (0) == strncmp("abcd", buf, 4));
    rbuf_del(rb);
    free(buf);
}

void Testrbuf_ringbuffers_independant_of_each_other(CuTest *tc)
{
    char *buf1 = (char *)malloc(1 << 12);
    char *buf2 = (char *)malloc(1 << 12);
    rbuf_handle_t rb1 = rbuf_new(12);
    rbuf_handle_t rb2 = rbuf_new(12);
    rbuf_put_block(rb1, (unsigned char *)"abcd", 4);
    rbuf_put_block(rb2, (unsigned char *)"efgh", 4);
    rbuf_get(rb1, buf1, 4);
    rbuf_get(rb2, buf2, 4);
    CuAssertTrue(tc, (0) == strncmp("abcd", buf1, 4));
    CuAssertTrue(tc, (0) == strncmp("efgh", buf2, 4));
    rbuf_del(rb2);
    rbuf_del(rb1);
    free(buf2);
    free(buf1);
}

