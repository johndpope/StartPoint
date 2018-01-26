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

import Foundation

class FlexBox {
    var position: LayoutPosition = .zero
    var top: Double {
        return position.top
    }
    var bottom: Double {
        return position.bottom
    }
    var left: Double {
        return position.left
    }
    var right: Double {
        return position.right
    }

    var width: Double = Double.nan // dimensions
    var height: Double = Double.nan // dimensions

    var margin: LayoutInsets = .zero
    var padding: LayoutInsets = .zero
    var border: LayoutInsets = .zero

    var direction: Direction = Direction.inherit

    var measuredWidth: Double = Double.nan
    var measuredHeight: Double = Double.nan
    var resolvedWidth: StyleValue = .auto // resolvedDimensions
    var resolvedHeight: StyleValue = .auto // resolvedDimensions

    var hasOverflow = false

    var generation: Int64 = 0
    static var totalGeneration: Int64 = 0

    func reset() {
        position = .zero
        margin = .zero
        padding = .zero
        border = .zero

        width = 0
        height = 0
        measuredWidth = Double.nan
        measuredHeight = Double.nan
        resolvedWidth = .auto
        resolvedHeight = .auto

        hasOverflow = false
        generation = 0
    }

    func computedDimension(by direction: FlexDirection) -> StyleValue {
        return direction.isRow ? resolvedWidth : resolvedHeight
    }

    // YGNodeIsStyleDimDefined
    func isDimensionDefined(for direction: FlexDirection, size: Double) -> Bool {
        return computedDimension(by: direction)
            .isDefined(size: size)
    }

    func setLeadingPosition(for direction: FlexDirection, size: Double) {
        switch direction {
        case .column:
            position.top = size
        case .columnReverse:
            position.bottom = size
        case .row:
            position.left = size
        case .rowReverse:
            position.right = size
        }
    }

    func setTrailingPosition(for direction: FlexDirection, size: Double) {
        switch direction {
        case .column:
            position.bottom = size
        case .columnReverse:
            position.top = size
        case .row:
            position.right = size
        case .rowReverse:
            position.left = size
        }
    }

    // YGRoundValueToPixelGrid
    static func round(_ value: Double, scale: Double, ceil: Bool, floor: Bool) -> Double {
        var value = value * scale
        let mod = fmod(value, 1)
        if equal(mod, 0) {
            value = value - mod
        } else if equal(mod, 1) || ceil {
            value = value - mod + 1
        } else if floor {
            value = value - mod
        } else {
            value = value - mod + ((mod > 0.5 || equal(mod, 0.5)) ? 1.0 : 0.0)
        }
        return value / scale
    }

    func roundPosition(scale: Double, left absoluteLeft: Double, top absoluteTop: Double, textLayout: Bool) -> (Double, Double) {
        let nodeLeft = left
        let nodeTop = top
        let nodeWidth = width
        let nodeHeight = height

        let absoluteLeft = absoluteLeft + nodeLeft
        let absoluteTop = absoluteTop + nodeTop
        let absoluteRight = absoluteLeft + nodeWidth
        let absoluteBottom = absoluteTop + nodeHeight

        position.left = FlexBox.round(nodeLeft, scale: scale, ceil: false, floor: textLayout)
        position.top = FlexBox.round(nodeTop, scale: scale, ceil: false, floor: textLayout)

        let fractionalWidth = !equal(fmod(nodeWidth * scale, 1.0), 0) && !equal(fmod(nodeWidth * scale, 1.0), 1.0)
        let fractionalHeight = !equal(fmod(nodeHeight * scale, 1.0), 0) && !equal(fmod(nodeHeight * scale, 1.0), 1.0)

        width = FlexBox.round(absoluteRight, scale: scale, ceil: (textLayout && fractionalWidth),
            floor: (textLayout && !fractionalWidth)) -
            FlexBox.round(absoluteLeft, scale: scale, ceil: false, floor: textLayout)
        height = FlexBox.round(absoluteBottom, scale: scale, ceil: (textLayout && fractionalHeight),
            floor: (textLayout && !fractionalHeight)) -
            FlexBox.round(absoluteTop, scale: scale, ceil: false, floor: textLayout)
        return (absoluteLeft, absoluteTop)
    }

    func measuredDimension(for direction: FlexDirection) -> Double {
        return direction.isRow ? measuredWidth : measuredHeight
    }

    func setMeasuredDimension(for direction: FlexDirection, size: Double) {
        if direction.isRow {
            measuredWidth = size
        } else {
            measuredHeight = size
        }
    }

    // YGNodeIsLayoutDimDefined
    func isLayoutDimensionDefined(for direction: FlexDirection) -> Bool {
        return measuredDimension(for: direction) >= 0.0
    }
}
