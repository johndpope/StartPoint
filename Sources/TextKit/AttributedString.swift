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

public enum FontWeight {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    @available(iOS 8.2, *)
    public var weight: UIFont.Weight {
        switch self {
        case .ultraLight:
            return UIFont.Weight.ultraLight
        case .thin:
            return UIFont.Weight.thin
        case .light:
            return UIFont.Weight.light
        case .regular:
            return UIFont.Weight.regular
        case .medium:
            return UIFont.Weight.medium
        case .semibold:
            return UIFont.Weight.semibold
        case .bold:
            return UIFont.Weight.bold
        case .heavy:
            return UIFont.Weight.heavy
        case .black:
            return UIFont.Weight.black
        }
    }
}

public enum LigatureLevel: Int {
    case none = 0
    case first = 1
#if os(macOS)
    case second = 2 // Value 2 is unsupported on iOS.
#endif
}

public class AttributedString {
    let string: NSMutableAttributedString
    var attributes: [NSAttributedStringKey: Any]

    public var wholeRange: NSRange {
        return NSRange(location: 0, length: string.length)
    }

    public init(_ string: String) {
        self.string = NSMutableAttributedString(string: string)
        attributes = [:]
    }

    public func setAttribute(key: NSAttributedStringKey, value: Any?, range: NSRange? = nil) -> AttributedString {
        attributes[key] = value
        if let value = value {
            string.addAttribute(key, value: value, range: range ?? wholeRange)
        } else {
            string.removeAttribute(key, range: range ?? wholeRange)
        }
        return self
    }

    public func font(_ value: UIFont, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.font, value: value, range: range)
    }

    public func systemFont(_ size: LayoutValue, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: size.value), range: range)
    }

    public func systemFont(_ size: LayoutValue, weight: FontWeight, range: NSRange? = nil) -> AttributedString {
        if #available(iOS 8.2, *) {
            return setAttribute(key: NSAttributedStringKey.font,
                value: UIFont.systemFont(ofSize: size.value, weight: weight.weight),
                range: range)
        } else {
            return systemFont(size, range: range)
        }
    }

    public func paragraphStyle(_ value: NSParagraphStyle, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.paragraphStyle, value: value, range: range)
    }

    public func color(_ value: UIColor, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.foregroundColor, value: value, range: range)
    }

    public func color(hex: UInt32, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.foregroundColor, value: UIColor.hex(hex), range: range)
    }

    public func backgroundColor(_ value: UIColor, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.backgroundColor, value: value, range: range)
    }

    public func backgroundColor(hex: UInt32, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.backgroundColor, value: UIColor.hex(hex), range: range)
    }

    public func ligature(_ value: LigatureLevel, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.ligature, value: NSNumber(value: value.rawValue), range: range)
    }

    public func kern(_ value: Double, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.kern, value: NSNumber(value: value), range: range)
    }

    public func strikethroughStyle(_ value: NSUnderlineStyle, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: value.rawValue), range: range)
    }

    public func underlineStyle(_ value: NSUnderlineStyle, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.underlineStyle, value: NSNumber(value: value.rawValue), range: range)
    }

    public func strokeColor(_ value: UIColor, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strokeColor, value: value, range: range)
    }

    public func strokeColor(_ hex: UInt32, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strokeColor, value: UIColor.hex(hex), range: range)
    }

    public func strokeWidth(_ value: Double, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strokeWidth, value: NSNumber(value: value), range: range)
    }

    public func shadow(_ value: NSShadow, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.shadow, value: value, range: range)
    }

    public func shadow(offset: CGSize, radius: LayoutValue, color: UIColor, range: NSRange? = nil) -> AttributedString {
        let t = NSShadow()
        t.shadowOffset = offset
        t.shadowBlurRadius = radius.value
        t.shadowColor = color
        return setAttribute(key: NSAttributedStringKey.shadow, value: t, range: range)
    }

    public func shadow(alpha: CGFloat, blur: CGFloat, x: CGFloat, y: CGFloat, color: UIColor, range: NSRange? = nil)
            -> AttributedString {
        let t = NSShadow()
        t.shadowOffset = CGSize(width: x, height: y)
        t.shadowBlurRadius = blur
        t.shadowColor = color.withAlphaComponent(alpha)
        return setAttribute(key: NSAttributedStringKey.shadow, value: t, range: range)
    }

    public func shadow(alpha: CGFloat, blur: CGFloat, x: CGFloat, y: CGFloat, hex: UInt32, range: NSRange? = nil)
            -> AttributedString {
        let t = NSShadow()
        t.shadowOffset = CGSize(width: x, height: y)
        t.shadowBlurRadius = blur
        t.shadowColor = UIColor.hex(hex).withAlphaComponent(alpha)
        return setAttribute(key: NSAttributedStringKey.shadow, value: t, range: range)
    }

    public func textEffect(_ value: NSAttributedString.TextEffectStyle = NSAttributedString.TextEffectStyle.letterpressStyle,
                           range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.textEffect, value: value, range: range)
    }

    public func attachment(_ value: NSTextAttachment, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.attachment, value: value, range: range)
    }

    public func link(url: URL, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.link, value: url, range: range)
    }

    public func link(_ value: String, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.link, value: URL(string: value), range: range)
    }

    public func baselineOffset(_ value: Double, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.baselineOffset, value: NSNumber(value: value), range: range)
    }

    public func underlineColor(_ value: UIColor, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.underlineColor, value: value, range: range)
    }

    public func underlineColor(hex: UInt32, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.underlineColor, value: UIColor.hex(hex), range: range)
    }

    public func strikethroughColor(_ value: UIColor, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strikethroughColor, value: value, range: range)
    }

    public func strikethroughColor(hex: UInt32, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.strikethroughColor, value: UIColor.hex(hex), range: range)
    }

    public func obliqueness(_ value: Double, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.obliqueness, value: NSNumber(value: value), range: range)
    }

    public func expansion(_ value: Double, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.expansion, value: NSNumber(value: value), range: range)
    }

    public func writingDirection(_ writingDirection: NSWritingDirection,
                                 text textWritingDirection: NSTextWritingDirection,
                                 range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSAttributedStringKey.writingDirection,
            value: [writingDirection.rawValue | textWritingDirection.rawValue],
            range: range)
    }

#if os(macOS)
    public func verticalGlyphForm(_ value: Int, range: NSRange? = nil) -> AttributedString {
        return setAttribute(key: NSVerticalGlyphFormAttributeName, value: NSNumber(value: value), range: range)
    }
#endif

    public func append(_ attrString: NSAttributedString) -> AttributedString {
        string.append(attrString)
        return self
    }

    public func append(_ attrString: AttributedString) -> AttributedString {
        string.append(attrString.done())
        return self
    }

    public func done() -> NSMutableAttributedString {
        return string
    }

    public func build(_ string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: attributes)
    }

    public static func create(_ string: String?) -> AttributedString? {
        return string.map(AttributedString.init)
    }

    public static func create(_ string: String?, size: CGFloat, color: UIColor, weight: FontWeight = .regular)
            -> NSAttributedString? {
        guard let value = string else {
            return nil
        }
        return AttributedString(value).systemFont(size).color(color).done()
    }

    public static func create(_ string: String?, size: CGFloat, hex: UInt32, weight: FontWeight = .regular)
            -> NSAttributedString? {
        return create(string, size: size, color: UIColor.hex(hex))
    }
}