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

import UIKit

open class StackComponent: BasicComponent {
    public init(children: [BasicComponent]) {
        super.init(framed: false, children: children)
    }

    public convenience init(direction: FlexDirection, children: [BasicComponent]) {
        self.init(children: children)
        layout.flexDirection(direction)
    }

    public static func horizontal(child: BasicComponent...) -> StackComponent {
        return StackComponent(direction: .row, children: child)
    }

    public static func vertical(child: BasicComponent...) -> StackComponent {
        return StackComponent(direction: .column, children: child)
    }

    public static func horizontal(any: BasicComponent?...) -> StackComponent {
        return StackComponent(direction: .row, children: any.compactMap(Function.this))
    }

    public static func vertical(any: BasicComponent?...) -> StackComponent {
        return StackComponent(direction: .column, children: any.compactMap(Function.this))
    }

    open override func build(in view: UIView) {
        children.forEach {
            $0.build(in: view)
        }
    }
}
