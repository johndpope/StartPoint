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
import CoreGraphics

public typealias ScrollComponent = BasicScrollComponent<UIScrollView>

open class ScrollComponentState: ComponentState {
    public var contentSize: CGSize {
        get {
            return _contentSize ?? CGSize.zero
        }
        set {
            _contentSize = newValue
        }
    }
    var _contentSize: CGSize?

    public var horizontalIndicator: Bool {
        get {
            return _horizontalIndicator ?? true
        }
        set {
            _horizontalIndicator = newValue
        }
    }
    var _horizontalIndicator: Bool?

    public var verticalIndicator: Bool {
        get {
            return _verticalIndicator ?? true
        }
        set {
            _verticalIndicator = newValue
        }
    }
    var _verticalIndicator: Bool?

    public var pagingEnabled: Bool {
        get {
            return _pagingEnabled ?? false
        }
        set {
            _pagingEnabled = newValue
        }
    }
    var _pagingEnabled: Bool?

    open override func apply(view: UIView) {
        if let scrollView = view as? UIScrollView {
            apply(scrollView: scrollView)
        } else {
            super.apply(view: view)
        }
    }

    open func apply(scrollView: UIScrollView) {
        if let contentSize = _contentSize {
            scrollView.contentSize = contentSize
        }
        if let horizontalIndicator = _horizontalIndicator {
            scrollView.showsHorizontalScrollIndicator = horizontalIndicator
        }
        if let verticalIndicator = _verticalIndicator {
            scrollView.showsVerticalScrollIndicator = verticalIndicator
        }
        super.apply(view: scrollView)
    }

    open override func invalidate() {
        _contentSize = nil
        super.invalidate()
    }
}

open class BasicScrollComponent<ScrollView: UIScrollView>: Component<ScrollView> {
    var _scrollState: ScrollComponentState?
    public override var pendingState: ScrollComponentState {
        let state = _scrollState ?? ScrollComponentState()
        if _scrollState == nil {
            _scrollState = state
            _pendingState = state
        }
        return state
    }

    open override func applyState(to view: ScrollView) {
        if _scrollState?._contentSize == nil {
            let total: CGRect = children.reduce(CGRect.zero) { (result: CGRect, next: BasicComponent) in
                return result.union(next.frame)
            }
            view.contentSize = total.size
        }
        super.applyState(to: view)
    }

    @discardableResult
    public func contentSize(_ value: CGSize) -> Self {
        if mainThread(), let view = view {
            view.contentSize = value
        } else {
            pendingState.contentSize = value
        }
        return self
    }

    @discardableResult
    public func horizontalIndicator(_ value: Bool) -> Self {
        if mainThread(), let view = view {
            view.showsHorizontalScrollIndicator = value
        } else {
            pendingState.horizontalIndicator = value
        }
        return self
    }

    @discardableResult
    public func verticalIndicator(_ value: Bool) -> Self {
        if mainThread(), let view = view {
            view.showsVerticalScrollIndicator = value
        } else {
            pendingState.verticalIndicator = value
        }
        return self
    }

    @discardableResult
    public func indicator(_ value: Bool) -> Self {
        if mainThread(), let view = view {
            view.showsHorizontalScrollIndicator = value
            view.showsVerticalScrollIndicator = value
        } else {
            pendingState.horizontalIndicator = value
            pendingState.verticalIndicator = value
        }
        return self
    }

    @discardableResult
    public func indicator(horizontal: Bool, vertical: Bool) -> Self {
        if mainThread(), let view = view {
            view.showsHorizontalScrollIndicator = horizontal
            view.showsVerticalScrollIndicator = vertical
        } else {
            pendingState.horizontalIndicator = horizontal
            pendingState.verticalIndicator = vertical
        }
        return self
    }

    @discardableResult
    public func paging(_ value: Bool) -> Self {
        if mainThread(), let view = view {
            view.isPagingEnabled = value
        } else {
            pendingState.pagingEnabled = value
        }
        return self
    }
}