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

#include <stdlib.h>
#include <string.h>
#import "Stream.h"

#define STRING_STREAM_COPY 1

struct StringStream {
#if STRING_STREAM_COPY
    char* source;
#else
    const char* source;
#endif // STRING_STREAM_COPY
    const char* current;
};

StringStreamRef StringStreamCreate(const char* value) {
    StringStreamRef const stream = (StringStreamRef) malloc(sizeof(struct StringStream));
#if STRING_STREAM_COPY
    stream->source = (char *) malloc(sizeof(char *) * strlen(value));
    strcpy(stream->source, value);
    stream->current = stream->source;
#else
    stream->source = value;
    stream->current = value;
#endif // STRING_STREAM_COPY
    return stream;
}

void StringStreamFree(StringStreamRef const stream) {
#if STRING_STREAM_COPY
    free((void*) stream->source);
#endif
    free(stream);
}

unsigned char StringStreamPeek(StringStreamRef const stream) {
    return (unsigned char) *stream->current;
}

void StringStreamMove(StringStreamRef const stream) {
    stream->current += 1;
}
