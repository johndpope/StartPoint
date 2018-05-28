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

@testable import StartPoint
import XCTest

class ArrayTests: XCTestCase {
    func testStringArray() {
        let array = ["1", "A", "😁", "➕"]
        let json = JSON2(raw: array)

        XCTAssertEqual(json[0].string(), "1")
        XCTAssertEqual(json[1].string(), "A")
        XCTAssertEqual(json[2].string(), "😁")
        XCTAssertEqual(json[3].string(), "➕")
        XCTAssertEqual(json[-1], JSON2.null)
        XCTAssertEqual(json[4], JSON2.null)
    }

    func testAnyArray() {
        let array: [Any] = [1, "A", ["1"], ["1": "1"]]
        let json = JSON2(raw: array)

        XCTAssertEqual(json[0].int(), 1)
        XCTAssertEqual(json[1].string(), "A")
        XCTAssertEqual(json[2].array().map { $0.string() }, ["1"])
        XCTAssertEqual(json[3].object().mapValues { $0.string() }, ["1": "1"])
        XCTAssertEqual(json[-1], JSON2.null)
        XCTAssertEqual(json[4], JSON2.null)
    }
}
