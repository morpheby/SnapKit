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

public struct Constraint<T: ConstraintTarget, U: ConstraintTarget, V: Relation>: Constraints {
    
    public typealias From = T
    public typealias To = U
    public typealias Rel = V

//    internal let sourceLocation: (StaticString, UInt)
    internal let label: String? = nil

    public let from: From
    public let to: To
    public var priority: Float = 1000
    
    public let count: Int = 1
       
    public func materialize() -> [NSLayoutConstraint] {
        let layoutConstraint = LayoutConstraint(item: from.target,
                                                attribute: From.attribute,
                                                relatedBy: Rel.relation,
                                                toItem: to.target,
                                                attribute: To.attribute,
                                                multiplier: multiplier,
                                                constant: constant)
        layoutConstraint.label = label
        layoutConstraint.priority = LayoutPriority(rawValue: self.priority)
        return [layoutConstraint]
    }
       
    var constant: CGFloat {
        return to.constant - from.constant
    }
    
    public var multiplier: CGFloat {
        return to.multiplier / from.multiplier
    }
    
    public static func update(_ new: Constraint, _ old: Constraint, constraints: inout [NSLayoutConstraint]) {
        print("single from \(constraints.first!.constant) to \(new.constant)")
        constraints.first!.constant = new.constant
    }
    

//    #if os(iOS) || os(tvOS)
//    @discardableResult
//    @available(iOS 11.0, tvOS 11.0, *)
//    public func update(inset: ConstraintDirectionalInsetTarget) -> Constraint {
//      self.constant = inset.constraintDirectionalInsetTargetValue
//      return self
//    }
//    #endif


    // MARK: Internal

//    internal func updateConstantAndPriorityIfNeeded() {
//        for layoutConstraint in self.layoutConstraints {
//            let attribute = (layoutConstraint.secondAttribute == .notAnAttribute) ? layoutConstraint.firstAttribute : layoutConstraint.secondAttribute
//            layoutConstraint.constant = self.constant.constraintConstantTargetValueFor(layoutAttribute: attribute)
//
//            let requiredPriority = ConstraintPriority.required.value
//            if (layoutConstraint.priority.rawValue < requiredPriority), (self.priority.constraintPriorityTargetValue != requiredPriority) {
//                layoutConstraint.priority = LayoutPriority(rawValue: self.priority.constraintPriorityTargetValue)
//            }
//        }
//    }
}
