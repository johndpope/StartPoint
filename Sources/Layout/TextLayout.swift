// MIT License
//
// Copyright (c) 2017 qazyn951230 qazyn951230@gmail.com
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
import CoreGraphics

final public class TextLayout: FlexLayout {
    public private(set) var text: NSAttributedString? = nil
    public private(set) var multiLine = false

    public required init(view: LayoutView? = nil) {
        super.init(view: view)
        measureSelf = _measure
    }

    @discardableResult
    public func text(_ value: NSAttributedString?) -> TextLayout {
        self.text = value
        markDirty()
        return self
    }

    @discardableResult
    public func multiLine(_ value: Bool) -> TextLayout {
        self.multiLine = value
        markDirty()
        return self
    }

    public func _measure(width: Double, widthMode: MeasureMode, height: Double, heightMode: MeasureMode) -> Size {
        guard let text = text else {
            return super.measure(width: width, widthMode: widthMode, height: height, heightMode: heightMode)
        }
        let width: Double = widthMode.resolve(width)
        let height: Double = heightMode.resolve(height)
        let options: NSStringDrawingOptions = multiLine ? [.usesLineFragmentOrigin] : []
        let size = text.boundingSize(size: CGSize(width: width, height: height), options: options)
            .ceiled
        return Size(cgSize: size)
    }
}