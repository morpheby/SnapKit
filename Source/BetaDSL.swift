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

//
//extension Target where T: UIView {
//    var snp: ConstraintViewDSL {
//        return ConstraintViewDSL(view: self)
//    }
//}

public protocol Targettable {
    associatedtype Target: UIView
    var target: Target { get }
}

public struct Target<T>: Targettable where T: UIView {
    public typealias Target = T
    public let target: T
}

public protocol ConstraintTarget {
    associatedtype Kind
    associatedtype Target: Targettable
    
    var target: Target { get }
    var constant: CGFloat { get }
    static var attribute: NSLayoutConstraint.Attribute { get }
}

public protocol HorizontalConstraint { }
public protocol DirectionalConstraint { }

public protocol EqualRelationable { }

public struct LeadingConstraint<T>: ConstraintTarget, EqualRelationable where T: Targettable {
    public typealias Kind = DirectionalConstraint
    public typealias Target = T
    public var target: T
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .leading }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

public struct LeftConstraint<T>: ConstraintTarget, EqualRelationable where T: Targettable {
    public typealias Kind = HorizontalConstraint
    public typealias Target = T
    public var target: T
    public var constant: CGFloat
    public static var attribute: NSLayoutConstraint.Attribute { return .left }
    
    public static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self {
        return Self(target: left.target, constant: left.constant + right.constraintOffsetTargetValue)
    }
}

//struct LeftExpression<T, U> where T: ConstraintTarget, U: Relation {
//}

extension ConstraintTarget where Self: EqualRelationable {
}

public protocol Relation {
    static var relation: NSLayoutConstraint.Relation { get }
}

public struct Equal: Relation {
    public static var relation: NSLayoutConstraint.Relation { return .equal }
}

public protocol ConstraintExpressionBase {
    associatedtype Left: ConstraintTarget
    associatedtype Right: ConstraintTarget
    associatedtype Rel: Relation

    var left: Left { get }
    var right: Right { get }
}

public struct ConstraintExpression<T: ConstraintTarget, U: ConstraintTarget, V: Relation>: ConstraintExpressionBase, Constraints {
    public typealias Left = T
    public typealias Right = U
    public typealias Rel = V
    public var left: T
    public var right: U
    
    public func materialize() -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: left.target.target,
                                   attribute: Left.attribute,
                                   relatedBy: Rel.relation,
                                   toItem: right.target.target,
                                   attribute: Right.attribute,
                                   multiplier: 1.0,
                                   constant: constant)]
    }
    
    var constant: CGFloat {
        return right.constant - left.constant
    }
}

//protocol MaterializedExpression {
//    associatedtype Left: ConstraintTarget
//    associatedtype Right: ConstraintTarget
//    associatedtype Rel: Relation
//
//    var constraint: NSLayoutConstraint { get }
//}
//
//struct AbstractMaterializedExpression<T: ConstraintTarget, U: ConstraintTarget, V: Relation> {
//    typealias Left = T
//    typealias Right = U
//    typealias Rel = V
//
//    var constraint: NSLayoutConstraint
//}
//

public func == <T: ConstraintTarget, U: ConstraintTarget>(_ left: T, _ right: U) -> ConstraintExpression<T, U, Equal>
    where T.Kind == U.Kind, T: EqualRelationable, U: EqualRelationable {
    return ConstraintExpression(left: left, right: right)
}

//
//protocol ExpressionContainer {
//    associatedtype Sub1
//    associatedtype Sub2
//}


//struct SingleExpressionContainer<T: ConstraintExpressionBase>: MaterializableExpressionContainer {
//    typealias Sub1 = T
//    typealias Sub2 = Void
//    var expr: T
//}
//
//struct ExpressionContainer2<T1: ConstraintExpressionBase, T2: ConstraintExpressionBase>: ExpressionContainer {
//    typealias Sub1 = T1
//    typealias Sub2 = T2
//}
//
//extension ExpressionContainer where Sub1: ExpressionContainer, Sub2: MaterializableExpressionContainer {
//    func materialize() -> [NSLayoutConstraint] {
//        return []
//    }
//}

public struct ConstraintBetaMaker<T> where T: UIView {
    public typealias Target1 = Target<T>
    var target: Target1
}

public extension ConstraintBetaMaker {
    var leading: LeadingConstraint<Target1> {
        return LeadingConstraint(target: target, constant: 0)
    }
    var left: LeftConstraint<Target1> {
        return LeftConstraint(target: target, constant: 0)
    }
}

extension UIView {
    public var snpb: ConstraintBetaMaker<UIView> {
        return ConstraintBetaMaker(target: Target(target: self))
    }
}

public protocol Constraints {
    func materialize() -> [NSLayoutConstraint]
//    func update(_ constraints: [NSLayoutConstraint])
    static func update(_ left: Self, _ right: Self, constraints: [NSLayoutConstraint])
}

//struct SingleConstraint<T: ConstraintExpressionBase>: Constraints {
//    var constraint: T
//    func materialize() -> [NSLayoutConstraint] {
//        return [constraint.materialize()]
//    }
//}

public struct TupleConstraint<T>: Constraints {
    var value: T
    
    func mat<U: Constraints>(_ val: U) -> [NSLayoutConstraint] {
        return val.materialize()
    }
    
    var materializer: (Self) -> [NSLayoutConstraint]
    
    public func materialize() -> [NSLayoutConstraint] {
        return materializer(self)
    }
}

public struct EitherConstraint<T1, T2>: Constraints where T1: Constraints, T2: Constraints {
    enum Value {
        case left(T1)
        case right(T2)
    }
    
    var value: Value
    
    public func materialize() -> [NSLayoutConstraint] {
        switch value {
        case let .left(v):
            return v.materialize()
        case let .right(v):
            return v.materialize()
        }
    }
}

extension ConstraintExpression {
    public static func update(_ new: ConstraintExpression, _ old: ConstraintExpression, constraints: [NSLayoutConstraint]) {
        print("single from \(constraints.first!.constant) to \(new.constant)")
        constraints.first!.constant = new.constant
    }
}

extension TupleConstraint {
    public static func update(_ new: TupleConstraint, _ old: TupleConstraint, constraints: [NSLayoutConstraint]) {
        print("tuple")
    }
}

extension EitherConstraint {
    public static func update(_ new: EitherConstraint, _ old: EitherConstraint, constraints: [NSLayoutConstraint]) {
        if let new = new as? EitherConstraint<T1, T1>, let old = old as? EitherConstraint<T1, T1> {
            print("same left right")
            switch (new.value, old.value) {
            case let (.left(leftV), .left(rightV)), let (.left(leftV), .right(rightV)), let (.right(leftV), .left(rightV)), let (.right(leftV), .right(rightV)):
                T1.update(leftV, rightV, constraints: constraints)
            }
        } else {
            print("Diff left right")
            switch (new.value, old.value) {
            case let (.left(leftV), .left(rightV)):
                T1.update(leftV, rightV, constraints: constraints)
            case let (.right(leftV), .right(rightV)):
                T2.update(leftV, rightV, constraints: constraints)
            default:
                constraints.dropFirst(1 /* count left */)
                new.materialize()
                print("abc")
            }
        }
    }
}
//
//extension EitherConstraint: EitherSpecial where T1 == T2 {
////    typealias Common = T1
////    public static func update(_ left: EitherConstraint, _ right: EitherConstraint, constraints: [NSLayoutConstraint]) {
////    }
//}

@_functionBuilder
public struct BetaDSLBuilder {
//    static func buildExpression<T, U, V>(_ expr: ConstraintExpression<T, U, V> /*, line: UInt = #line, file: StaticString = #file
// */) -> some Constraints {
//        return SingleConstraint<ConstraintExpression<T, U, V>>(constraint: expr)
//    }

    public static func buildBlock<T1: Constraints>(_ expr: T1) -> T1 {
        return expr
    }
    
    public static func buildBlock<T1: Constraints, T2: Constraints>(_ expr1: T1, _ expr2: T2) -> TupleConstraint<(T1, T2)> {
        return TupleConstraint(value: (expr1, expr2)) { t in
            t.mat(t.value.0) + t.mat(t.value.1)
        }
    }
    
    public static func buildEither<T1: Constraints, T2: Constraints>(first: T1) -> EitherConstraint<T1, T2> {
        return EitherConstraint(value: .left(first))
    }
    
    public static func buildEither<T1: Constraints, T2: Constraints>(second: T2) -> EitherConstraint<T1, T2> {
        return EitherConstraint(value: .right(second))
    }
    
//
//    static func buildBlock<T1, T2>(_ expr1: T1, _ expr2: T2) -> some ConstraintExpressionBase
//        where T1: ConstraintExpressionBase, T2: ConstraintExpressionBase {
//        return expr
//    }
    
}

public protocol DSL {
    associatedtype Ctr: Constraints
    
    func apply()
    func update(_ old: Self)
}

public class BetaDSL<T: Constraints>: DSL {
    public typealias Ctr = T
    
    var constraints: T
    var saved: [NSLayoutConstraint] = []
    
    public init(@BetaDSLBuilder _ builder: () -> T) {
        self.constraints = builder()
    }
    
    public func apply() {
        saved = constraints.materialize()
        NSLayoutConstraint.activate(saved)
        print(saved)
    }
    
    public func update(_ old: BetaDSL) {
        Ctr.update(constraints, old.constraints, constraints: old.saved)
        self.saved  = old.saved
    }
}

var someView = UIView()

let opt = true

var beta = BetaDSL {
    someView.snpb.leading == someView.snpb.leading
    if opt {
        someView.snpb.left == someView.snpb.left + 10.0
    } else {
        someView.snpb.left == someView.snpb.left
    }
}

func abc() {
    beta.apply()
}
