// MIT License
//
// Copyright (c) 2017-present qazyn951230 qazyn951230@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifndef START_POINT_ATOMIC_H
#define START_POINT_ATOMIC_H

#include <stdlib.h>
#include <stdatomic.h>
#include "Config.h"

SP_C_FILE_BEGIN

#ifdef __cplusplus
#define sp_simple_cast(type, source) (reinterpret_cast<type>(source))
#else
#define sp_simple_cast(type, source) ((type)(source))
#endif

#define make_atomic_type(swift_type, swift_name, raw_type, atomic_type)                             \
typedef struct sp_atomic_##swift_name *SPA##swift_type##Ref;                                        \
static inline SPA##swift_type##Ref spa_##swift_name##_create(raw_type value) {                      \
    atomic_##atomic_type* result = (atomic_##atomic_type *)malloc(sizeof(atomic_##atomic_type));    \
    atomic_init(result, value);                                                                     \
    return sp_simple_cast(SPA##swift_type##Ref, result);                                            \
}                                                                                                   \
static inline void spa_##swift_name##_free(SPA##swift_type##Ref swift_type) {                       \
    free(sp_simple_cast(atomic_##atomic_type*, swift_type));                                        \
}                                                                                                   \
static inline int spa_##swift_name##_load(SPA##swift_type##Ref swift_type) {                        \
    return atomic_load(sp_simple_cast(atomic_##atomic_type*, swift_type));                          \
}                                                                                                   \
static inline void spa_##swift_name##_add(SPA##swift_type##Ref swift_type, raw_type value) {        \
    atomic_fetch_add(sp_simple_cast(atomic_##atomic_type*, swift_type), value);                     \
}                                                                                                   \
static inline void spa_##swift_name##_sub(SPA##swift_type##Ref swift_type, raw_type value) {        \
    atomic_fetch_sub(sp_simple_cast(atomic_##atomic_type*, swift_type), value);                     \
}                                                                                                   \
static inline void spa_##swift_name##_or(SPA##swift_type##Ref swift_type, raw_type value) {         \
    atomic_fetch_or(sp_simple_cast(atomic_##atomic_type*, swift_type), value);                      \
}                                                                                                   \
static inline void spa_##swift_name##_xor(SPA##swift_type##Ref swift_type, raw_type value) {        \
    atomic_fetch_xor(sp_simple_cast(atomic_##atomic_type*, swift_type), value);                     \
}                                                                                                   \
static inline void spa_##swift_name##_and(SPA##swift_type##Ref swift_type, raw_type value) {        \
    atomic_fetch_and(sp_simple_cast(atomic_##atomic_type*, swift_type), value);                     \
}                                                                                                   \

make_atomic_type(Bool, bool, bool, bool)
make_atomic_type(Int8, int8, signed char, schar)
make_atomic_type(UInt8, uint8, unsigned char, uchar)
make_atomic_type(Int16, Int16, short, short)
make_atomic_type(UInt16, UInt16, unsigned short, ushort)
make_atomic_type(Int32, int32, int, int)
make_atomic_type(UInt32, uint32, unsigned int, uint)
#if defined(__LP64__) && __LP64__
make_atomic_type(Int, int, long, long)
make_atomic_type(UInt, uint, unsigned long, ulong)
#else
make_atomic_type(Int, int, int, int)
make_atomic_type(UInt, uint, unsigned int, uint)
#endif
make_atomic_type(Int64, int64, long long, llong)
make_atomic_type(UInt64, uint64, unsigned long long, ullong)

SP_C_FILE_END

#endif //START_POINT_ATOMIC_H
