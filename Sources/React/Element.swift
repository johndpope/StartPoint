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
import QuartzCore

public typealias ViewElement = Element<ElementView>

open class Element<View: UIView>: BasicElement {
    public internal(set) var view: View?
    public internal(set) var creator: (() -> View)?

    var _loaded: [(Element<View>, View) -> Void]?

    public init(children: [BasicElement] = []) {
        super.init(framed: true, children: children)
    }

    public override var loaded: Bool {
        return view != nil
    }

    override var _view: UIView? {
        return view
    }

    var layer: CALayer? {
        return view?.layer
    }

    var layersCount: Int {
        return view?.layer.sublayers?.count ?? 0
    }

    override var _frame: Rect {
        didSet {
            if mainThread(), let view = self.view {
                view.frame = _frame.cgRect
            } else {
                pendingState.frame = _frame.cgRect
                registerPendingState()
            }
        }
    }

    public override var interactive: Bool {
        didSet {
            self.interactive(interactive)
        }
    }

    deinit {
        creator = nil
        if let view = self.view {
            runOnMain {
                view.removeFromSuperview()
            }
        }
    }

    public func loaded(then method: @escaping (Element<View>, View) -> Void) {
        if mainThread(), let view = self.view {
            method(self, view)
        } else {
            _loaded = _loaded ?? []
            _loaded?.append(method)
        }
    }

    public override func addElement(_ element: BasicElement) {
        assertThreadAffinity(for: self)
        if let old = element.owner, old == self {
            return
        }
        let index = children.count
        let layerIndex = layersCount
        insertElement(element, at: index, at: layerIndex, remove: nil)
    }

    public override func insertElement(_ element: BasicElement, at index: Int) {
        assertThreadAffinity(for: self)
        guard index > -1 && index < children.count else {
            assertFail("Insert index illegal: \(index)")
            return
        }
        let index = children.count
        let layerIndex: Int?
        if let layer = self.layer, let slayer = element._layer,
           let i = layer.sublayers?.index(of: slayer) {
            layerIndex = i + 1
        } else {
            layerIndex = nil
        }
        insertElement(element, at: index, at: layerIndex, remove: nil)
    }

    override func _removeFromOwner() {
        super._removeFromOwner()
        view?.removeFromSuperview()
    }

    open override func build(in view: UIView) {
        assertMainThread()
        let this = buildView()
        if let superview = this.superview {
            if superview != view {
                this.removeFromSuperview()
                view.addSubview(this)
            }
        } else {
            view.addSubview(this)
        }
    }

    open func buildView() -> View {
        assertMainThread()
        if let v = self.view {
            return v
        }
        let this = _createView()
        applyState(to: this)
        buildChildren(in: this)
        if let methods = _loaded {
            methods.forEach {
                $0(self, this)
            }
        }
        _loaded = nil
        return this
    }

    func _createView() -> View {
        assertMainThread()
        if let view = self.view {
            return view
        }
        let this = creator?() ?? View.init(frame: .zero)
        creator = nil
        if let container = this as? ElementContainer {
            container.element = self
        } else {
            this._element = self
        }
        self.view = this
        return this
    }

    public override func apply() {
        if let view = self.view {
            applyState(to: view)
        }
    }

    open func applyState(to view: View) {
        assertMainThread()
        _pendingState?.apply(view: view)
    }

    public override func registerPendingState() {
        if view == nil {
            return
        }
        super.registerPendingState()
    }

    open func buildChildren(in view: UIView) {
        if children.isEmpty {
            return
        }
        children.forEach {
            $0.build(in: view)
        }
    }

#if DEBUG
    public override func debugMode() {
        backgroundColor(UIColor.random)
        super.debugMode()
    }
#endif
}

extension Element {
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        if mainThread(), let view = view {
            view.backgroundColor = value
        } else {
            pendingState.backgroundColor = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func backgroundColor(hex: UInt32) -> Self {
        let value = UIColor.hex(hex)
        if mainThread(), let view = view {
            view.backgroundColor = value
        } else {
            pendingState.backgroundColor = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func tintColor(_ value: UIColor) -> Self {
        if mainThread(), let view = view {
            view.tintColor = value
        } else {
            pendingState.tintColor = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func tintColor(hex: UInt32) -> Self {
        let value = UIColor.hex(hex)
        if mainThread(), let view = view {
            view.tintColor = value
        } else {
            pendingState.tintColor = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        if mainThread(), let view = view {
            view.layer.cornerRadius = value
        } else {
            pendingState.cornerRadius = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func borderColor(cgColor value: CGColor?) -> Self {
        if mainThread(), let view = view {
            view.layer.borderColor = value
        } else {
            pendingState.borderColor = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func borderColor(_ value: UIColor?) -> Self {
        return borderColor(cgColor: value?.cgColor)
    }

    @discardableResult
    public func borderColor(hex value: UInt32) -> Self {
        return borderColor(cgColor: UIColor.hex(value).cgColor)
    }

    @discardableResult
    public func borderWidth(_ value: CGFloat) -> Self {
        if mainThread(), let view = view {
            view.layer.borderWidth = value
        } else {
            pendingState.borderWidth = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func border(color: UIColor?, width: CGFloat) -> Self {
        if mainThread(), let view = view {
            let layer = view.layer
            layer.borderColor = color?.cgColor
            layer.borderWidth = width
        } else {
            let state = pendingState
            state.borderColor = color?.cgColor
            state.borderWidth = width
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func border(hex value: UInt32, width: CGFloat) -> Self {
        let color = UIColor.hex(value).cgColor
        if mainThread(), let view = view {
            let layer = view.layer
            layer.borderColor = color
            layer.borderWidth = width
        } else {
            let state = pendingState
            state.borderColor = color
            state.borderWidth = width
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func shadow(opacity: Float, radius: CGFloat, offset: CGSize, color: CGColor?) -> Self {
        if mainThread(), let view = view {
            let layer = view.layer
            layer.shadowOpacity = opacity
            layer.shadowRadius = radius
            layer.shadowOffset = offset
            layer.shadowColor = color
        } else {
            let state = pendingState
            state.shadowOpacity = opacity
            state.shadowRadius = radius
            state.shadowOffset = offset
            state.shadowColor = color
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func shadow(alpha: Float, blur: CGFloat, x: CGFloat, y: CGFloat, color: UIColor) -> Self {
        if mainThread(), let view = view {
            let layer = view.layer
            layer.shadowOpacity = alpha
            layer.shadowRadius = blur
            layer.shadowOffset = CGSize(width: x, height: y)
            layer.shadowColor = color.cgColor
        } else {
            let state = pendingState
            state.shadowOpacity = alpha
            state.shadowRadius = blur
            state.shadowOffset = CGSize(width: x, height: y)
            state.shadowColor = color.cgColor
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func shadow(alpha: Float, blur: CGFloat, x: CGFloat, y: CGFloat, hex: UInt32) -> Self {
        if mainThread(), let view = view {
            let layer = view.layer
            layer.shadowOpacity = alpha
            layer.shadowRadius = blur
            layer.shadowOffset = CGSize(width: x, height: y)
            layer.shadowColor = UIColor.hex(hex).cgColor
        } else {
            let state = pendingState
            state.shadowOpacity = alpha
            state.shadowRadius = blur
            state.shadowOffset = CGSize(width: x, height: y)
            state.shadowColor = UIColor.hex(hex).cgColor
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func shadowPath(_ value: CGPath?) -> Self {
        if mainThread(), let view = view {
            let layer = view.layer
            layer.shadowPath = value
        } else {
            let state = pendingState
            state.shadowPath = value
            registerPendingState()
        }
        return self
    }

    @discardableResult
    public func interactive(_ value: Bool) -> Self {
        if mainThread(), let view = view {
            view.isUserInteractionEnabled = value
        } else {
            pendingState.interactive = value
            registerPendingState()
        }
        return self
    }
}
