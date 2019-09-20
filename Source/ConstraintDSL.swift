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


public protocol ConstraintDSL {
    associatedtype Item: LayoutConstraintItem
    
    var item: Item { get }
}


public protocol ConstraintBasicAttributesDSL : ConstraintDSL {
}
extension ConstraintBasicAttributesDSL {
    
    // MARK: Basics
    
    public var left: LeftConstraint<Item> {
        return LeftConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var top: TopConstraint<Item> {
        return TopConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var bottom: BottomConstraint<Item> {
        return BottomConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var right: RightConstraint<Item> {
        return RightConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var leading: LeadingConstraint<Item> {
        return LeadingConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var trailing: TrailingConstraint<Item> {
        return TrailingConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var width: WidthConstraint<Item> {
        return WidthConstraint(target: item, multiplier: 1, constant: 0)
    }
    
    public var height: HeightConstraint<Item> {
        return HeightConstraint(target: item, multiplier: 1, constant: 0)
    }
    
//    public var centerX: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.centerX)
//    }
//
//    public var centerY: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.centerY)
//    }
//
//    public var edges: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.edges)
//    }
//
//    public var directionalEdges: ConstraintItem {
//      return ConstraintItem(target: self.target, attributes: ConstraintAttributes.directionalEdges)
//    }
//
//    public var size: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.size)
//    }
//
//    public var center: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.center)
//    }
    
}

public protocol ConstraintAttributesDSL : ConstraintBasicAttributesDSL {
}
extension ConstraintAttributesDSL {
    
    // MARK: Baselines
//
//    @available(iOS 8.0, OSX 10.11, *)
//    public var lastBaseline: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.lastBaseline)
//    }
//
//    @available(iOS 8.0, OSX 10.11, *)
//    public var firstBaseline: ConstraintItem {
//        return ConstraintItem(target: self.target, attributes: ConstraintAttributes.firstBaseline)
//    }
    
}
