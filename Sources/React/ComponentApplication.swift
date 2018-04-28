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

public final class ComponentApplication: UIApplication {
//    public override func sendEvent(_ event: UIEvent) {
//        Log.debug(event)
//        super.sendEvent(event)
//    }
//
//    public override func sendAction(_ action: Selector, to target: Any?, from sender: Any?,
//                                    for event: UIEvent?) -> Bool {
//        Log.debug(any: event)
//        return super.sendAction(action, to: target, from: sender, for: event)
//    }

    public static func main(delegate: String) {
        let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
        UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(ComponentApplication.self), delegate)
    }
}
