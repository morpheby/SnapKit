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

public protocol HorizontalConstraint { }
public protocol DirectionalConstraint { }
public protocol VerticalConstraint { }
public protocol HorizontalSizeConstraint { }
public protocol VerticalSizeConstraint { }

public protocol EqualRelationable { }

public struct LeadingConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = DirectionalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .leading }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct TrailingConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = DirectionalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .trailing }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct LeftConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = HorizontalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .left }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct RightConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = HorizontalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .right }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct TopConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = VerticalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .top }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct BottomConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = VerticalConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .bottom }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct WidthConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = HorizontalSizeConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .width }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct HeightConstraint<T>: ConstraintTarget, EqualRelationable where T: LayoutConstraintItem {
    public typealias Kind = VerticalSizeConstraint
    public typealias Target = T
    public var target: T
    public var multiplier: CGFloat
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .height }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, multiplier: left.multiplier, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

