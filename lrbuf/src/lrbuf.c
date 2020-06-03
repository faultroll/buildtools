
#include "lrbuf.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

struct rbuf_s {
    uint32_t size;
    uint32_t head, tail;
    void *data;
};

/**
 * @brief Calculate the power using bit operation, base must be 2.
 *
 * @param[in] exponent The exponent.
 * @return uint32_t Result.
 */
static inline
uint32_t __rbuf_calc_power(const uint8_t exponent)
{
    // return (pow(base, exponent));
    return (1U << exponent);
}

/**
 * @brief Calculate the remainder using bit operation, divisor must be 2^n.
 *        When divisor is 2^n, (2^n - 1) is B1...1, & is equal to %.
 *        Thus (dividend & (divisor - 1)) becomes (dividend % divisor).
 *
 * @param[in] dividend The dividend.
 * @param[in] divisor The divisor, must be 2^n.
 * @return uint32_t Result.
 */
static inline
uint32_t __rbuf_calc_remainder(const uint32_t dividend, const uint32_t divisor)
{
    // return (dividend % divisor);
    return (dividend & (divisor - 1));
}

/**
 * @brief Calculate the mirror position using bit operation, size must be 2^n.
 *
 * @param[in] position The position.
 * @param[in] size The size.
 * @return uint32_t Result.
 */
static inline
uint32_t __rbuf_calc_mirror(const uint32_t position, const uint32_t size)
{
    // return ((position >= size) ? (position - size) : (position + size));
    return (position ^ size);
}

/**
 * @brief Calculate address of the offset pointer.
 *
 * @param[in] base The base address.
 * @param[in] offset The offset.
 * @return void* Result.
 */
static inline
void *__rbuf_calc_pointer(const void *base, const uint32_t offset)
{
    return (void *)((uintptr_t)base + (ptrdiff_t)offset);
}

/**
 * @brief Create a physical memory file.
 *
 * @param[in] size The base address.
 * @return int The file descriptor.
 */
static inline
int __rbuf_buffer_fdopen(const size_t size)
{
    unsigned int stat = (0);
    int ret = (~0);
    int fd = (~0);
    char path[] = "/tmp/rbuf-XXXXXX";

    do {
        if (0 == size) {
            break;
        }

        fd = mkstemp(path);
        if (fd < 0) {
            break;
        }
        stat++;

        ret = unlink(path);
        if (ret != 0) {
            break;
        }

        ret = ftruncate(fd, size);
        if (ret != 0) {
            break;
        }
        stat = (~0);
    } while (0);

    switch (stat) {
        case (1):
            close(fd);
            fd = (~0);
        case (~0U):
        default:
            break;
    }

    return fd;
}

/**
 * @brief Destroy the physical memory file.
 *
 * @param[in] fd The file descriptor.
 */
static inline
void __rbuf_buffer_fdclose(const int fd)
{
    if (fd >= 0) {
        close(fd);
    }
}

/**
 * @brief Using mmap to create a mirror memory.
 *        the trick is: mmap one memory twice to another memory.
 *
 * @param rbuf The ring buffer Handle.
 */
static
void __rbuf_create_buffer_mirror(rbuf_handle_t rbuf)
{
    unsigned int stat = (0);
    int fdmirror = (~0), fdreal = (~0);
    void *address = NULL;

    do {
        fdmirror = __rbuf_buffer_fdopen(rbuf->size);
        if (fdmirror < 0) {
            break;
        }
        stat++; /* 1 */

        fdreal = __rbuf_buffer_fdopen(rbuf->size << 1);
        if (fdreal < 0) {
            break;
        }
        stat++; /* 2 */

        /* create the array of data */
        rbuf->data = mmap(NULL, rbuf->size << 1, PROT_NONE, MAP_PRIVATE,
                          fdreal, 0);
        if (MAP_FAILED == rbuf->data) {
            break;
        }
        stat++; /* 3 */

        address = mmap(rbuf->data, rbuf->size, PROT_READ | PROT_WRITE,
                       MAP_FIXED | MAP_SHARED, fdmirror, 0);
        if (address != rbuf->data) {
            break;
        }
        stat++; /* 4 */

        address = mmap(__rbuf_calc_pointer(rbuf->data, rbuf->size), rbuf->size, PROT_READ | PROT_WRITE,
                       MAP_FIXED | MAP_SHARED, fdmirror, 0);
        if (address != __rbuf_calc_pointer(rbuf->data, rbuf->size)) {
            break;
        }
        stat = (~0);
    } while (0);

    switch (stat) {
        case (4):
            munmap(address, rbuf->size);
        case (3):
            munmap(rbuf->data, rbuf->size << 1);
        case (~0U):
        case (2):
            __rbuf_buffer_fdclose(fdreal);
        case (1):
            __rbuf_buffer_fdclose(fdmirror);
        default:
            break;
    }

}

/**
 * @brief Calculate head or tail position.
 *
 * @param[in] rbuf The ring buffer Handle.
 * @param[in] pos Origin head or tail.
 * @param[in] inc The increment in bytes.
 * @return uint32_t Changed head or tail.
 */
static inline
uint32_t __rbuf_increase_position(const rbuf_handle_t rbuf, const uint32_t pos, const uint32_t inc)
{
    return __rbuf_calc_remainder(pos + inc, rbuf->size << 1);
}

/**
 * @brief Whether ring buffer is full or not.
 *
 * @param[in] rbuf The ring buffer Handle.
 * @return true Ring buffer is full.
 * @return false Ring buffer is not full.
 */
static inline
bool __rbuf_is_full(const rbuf_handle_t rbuf)
{
    // return (rbuf_size(rbuf) == rbuf_used(rbuf))
    return (rbuf->tail == __rbuf_calc_mirror(rbuf->head, rbuf->size));
}

/**
 * @brief Whether ring buffer is empty or not.
 *
 * @param[in] rbuf rbuf The ring buffer Handle.
 * @return true Ring buffer is empty.
 * @return false Ring buffer is not empty.
 */
static inline
bool __rbuf_is_empty(const rbuf_handle_t rbuf)
{
    // return (0 == rbuf_used(rbuf))
    return (rbuf->tail == rbuf->head);
}

rbuf_handle_t rbuf_new(const uint8_t exponent)
{
    rbuf_handle_t rbuf = malloc(sizeof(rbuf_t));
    rbuf->size = __rbuf_calc_power(exponent);
    rbuf->head = rbuf->tail = 0;
    __rbuf_create_buffer_mirror(rbuf);
    return (rbuf);
}

void rbuf_del(rbuf_handle_t rbuf)
{
    munmap(rbuf->data, rbuf->size << 1);
    free(rbuf);
}

uint32_t rbuf_size(const rbuf_handle_t rbuf)
{
    return (rbuf->size);
}

uint32_t rbuf_used(const rbuf_handle_t rbuf)
{
    return __rbuf_calc_remainder(rbuf->tail + (rbuf->size << 1) - rbuf->head, rbuf->size << 1);
}

static inline
uint32_t rbuf_unused(const rbuf_handle_t rbuf)
{
    return (rbuf_size(rbuf) - rbuf_used(rbuf));
}

uint32_t rbuf_put_block(rbuf_handle_t rbuf, const void *data, const uint32_t size)
{
    if (__rbuf_is_full(rbuf) || rbuf_unused(rbuf) < size) {
        return (~0);
    }
    memcpy(__rbuf_calc_pointer(rbuf->data, rbuf->tail), data, size);
    rbuf->tail = __rbuf_increase_position(rbuf, rbuf->tail, size);
    return (rbuf_used(rbuf));
}

uint32_t rbuf_get(rbuf_handle_t rbuf, void *data, const uint32_t size)
{
    if (__rbuf_is_empty(rbuf) || rbuf_used(rbuf) < size) {
        return (~0);
    }
    memcpy(data, __rbuf_calc_pointer(rbuf->data, rbuf->head), size);
    rbuf->head = __rbuf_increase_position(rbuf, rbuf->head, size);
    return (rbuf_used(rbuf));
}

uint32_t rbuf_read(rbuf_handle_t rbuf, void *data, const uint32_t size)
{
    if (__rbuf_is_empty(rbuf) || rbuf_used(rbuf) < size) {
        return (~0);
    }
    memcpy(data, __rbuf_calc_pointer(rbuf->data, rbuf->head), size);
    return (rbuf_used(rbuf));
}
