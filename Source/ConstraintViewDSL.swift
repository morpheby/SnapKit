//
//  SnapKit
//
//  Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


public struct ConstraintViewDSL: ConstraintAttributesDSL {
    
    public var contentHuggingHorizontalPriority: Float {
        get {
            return self.item.contentHuggingPriority(for: .horizontal).rawValue
        }
        nonmutating set {
            self.item.setContentHuggingPriority(LayoutPriority(rawValue: newValue), for: .horizontal)
        }
    }
    
    public var contentHuggingVerticalPriority: Float {
        get {
            return self.item.contentHuggingPriority(for: .vertical).rawValue
        }
        nonmutating set {
            self.item.setContentHuggingPriority(LayoutPriority(rawValue: newValue), for: .vertical)
        }
    }
    
    public var contentCompressionResistanceHorizontalPriority: Float {
        get {
            return self.item.contentCompressionResistancePriority(for: .horizontal).rawValue
        }
        nonmutating set {
            self.item.setContentCompressionResistancePriority(LayoutPriority(rawValue: newValue), for: .horizontal)
        }
    }
    
    public var contentCompressionResistanceVerticalPriority: Float {
        get {
            return self.item.contentCompressionResistancePriority(for: .vertical).rawValue
        }
        nonmutating set {
            self.item.setContentCompressionResistancePriority(LayoutPriority(rawValue: newValue), for: .vertical)
        }
    }
    
    public let item: ConstraintView
    
    internal init(view: ConstraintView) {
        self.item = view
    }
}
