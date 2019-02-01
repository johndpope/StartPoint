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

#ifndef START_POINT_CONFIG_H
#define START_POINT_CONFIG_H

#ifdef __cplusplus
#define SP_EXTERN_C_BEGIN   extern "C" {
#define SP_EXTERN_C_END     }

#define SP_NAMESPACE_BEGIN  namespace StartPoint {
#define SP_NAMESPACE_END    }

#define SP_CPP_FILE_BEGIN   SP_NAMESPACE_BEGIN  \
                            _Pragma("clang assume_nonnull begin")
#define SP_CPP_FILE_END     _Pragma("clang assume_nonnull end") \
                            SP_NAMESPACE_END
#else
#define SP_EXTERN_C_BEGIN
#define SP_EXTERN_C_END

#define SP_NAMESPACE_BEGIN
#define SP_NAMESPACE_END

#define SP_CPP_FILE_BEGIN
#define SP_CPP_FILE_END
#endif

#define SP_C_FILE_BEGIN SP_EXTERN_C_BEGIN \
                        _Pragma("clang assume_nonnull begin")
#define SP_C_FILE_END   _Pragma("clang assume_nonnull end") \
                        SP_EXTERN_C_END

#if defined(__clang__) || defined(__GNUC__)
#define SP_LIKELY(x)    __builtin_expect(!!(x), 1)
#define SP_UNLIKELY(x)  __builtin_expect(!!(x), 0)
#else
#define SP_LIKELY(x)    (x)
#define SP_UNLIKELY(x)  (x)
#endif

#endif //START_POINT_CONFIG_H
