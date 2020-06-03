#ifndef _LRBUF_H_
#define _LRBUF_H_

#include <stdint.h>

/**
 * @brief Opaque ring buffer structure
 *
 */
typedef struct rbuf_s rbuf_t;
/**
 * @brief Handle type, the way users interact with the API
 *
 */
typedef rbuf_t *rbuf_handle_t;

/**
 * @brief Create new ring buffer.
 *
 * @param[in] exponent Size of the ring buffer when taking this as a power of 2.
 * @return rbuf_handle_t New ring buffer Handle.
 */
rbuf_handle_t rbuf_new(const uint8_t exponent);

/**
 * @brief Free memory used by ring buffer.
 *
 * @param rbuf The ring buffer Handle.
 */
void rbuf_del(rbuf_handle_t rbuf);

/**
 * @brief Reset ring buffer to empty.
 *
 * @param[in] rbuf The ring buffer Handle.
 */
// void rbuf_rst(rbuf_handle_t rbuf);

/**
 * @brief Get the size in bytes of ring buffer.
 *
 * @param rbuf The ring buffer Handle.
 * @return uint32_t Size of ring buffer in bytes.
 */
uint32_t rbuf_size(const rbuf_handle_t rbuf);

/**
 * @brief Get the used bytes of ring buffer.
 *
 * @param rbuf The ring buffer Handle.
 * @return uint32_t Used bytes of ring buffer.
 */
uint32_t rbuf_used(const rbuf_handle_t rbuf);

/**
 * @brief Put data to ring buffer, continues to add data if full.
 *
 * @param rbuf The ring buffer Handle.
 * @param[in] data Data to be written to ring buffer.
 * @param[in] size Size of data in bytes.
 * @return uint32_t The used bytes of ring buffer after operation, -1 if full.
 */
// uint32_t rbuf_put_nonblock(rbuf_handle_t rbuf, const void *data, const uint32_t size);

/**
 * @brief Put data to ring buffer, rejects new data if full.
 *
 * @param rbuf The ring buffer Handle.
 * @param[in] data Data to be written to ring buffer.
 * @param[in] size Size of data in bytes, must be smaller than unused size, or will return -1.
 * @return uint32_t The used bytes of ring buffer after operation, -1 if full.
 */
uint32_t rbuf_put_block(rbuf_handle_t rbuf, const void *data, const uint32_t size);

/**
 * @brief Retrieve data from the ring buffer.
 *
 * @param rbuf The ring buffer Handle.
 * @param[out] data Data to be read from ring buffer.
 * @param[in] size Size of data in bytes, must be smaller than used size, or will return -1.
 * @return uint32_t The used bytes of ring buffer after operation, -1 if empty.
 */
uint32_t rbuf_get(rbuf_handle_t rbuf, void *data, const uint32_t size);

/**
 * @brief Read data from the ring buffer, ring buffer won't change.
 *
 * @param rbuf The ring buffer Handle.
 * @param[out] data Data to be read from ring buffer.
 * @param[in] size Size of data in bytes, must be smaller than used size, or will return -1.
 * @return uint32_t The used bytes of ring buffer after operation, -1 if empty.
 */
uint32_t rbuf_read(rbuf_handle_t rbuf, void *data, const uint32_t size);

#endif /* _RBUF_H_ */