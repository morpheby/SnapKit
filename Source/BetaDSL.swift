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

struct Target<T> {
    let target: T
}
//
//extension Target where T: UIView {
//    var snp: ConstraintViewDSL {
//        return ConstraintViewDSL(view: self)
//    }
//}

protocol ConstraintTarget {
    associatedtype Kind
    associatedtype Target
    
    var target: Target { get }
}

protocol HorizontalConstraint { }
protocol DirectionalConstraint { }

protocol EqualRelationable { }

struct LeadingConstraint<T>: ConstraintTarget, EqualRelationable {
    typealias Kind = DirectionalConstraint
    typealias Target = T
    var target: T
}

struct LeftConstraint<T>: ConstraintTarget, EqualRelationable {
    typealias Kind = HorizontalConstraint
    typealias Target = T
    var target: T
}

struct LeftExpression<T, U> where T: ConstraintTarget, U: Relation {
}

extension ConstraintTarget where Self: EqualRelationable {
}

protocol Relation { }

struct Equal: Relation {
}

protocol ConstraintExpressionBase {
    associatedtype Left: ConstraintTarget
    associatedtype Right: ConstraintTarget
    associatedtype Rel: Relation
    
    var left: Left { get }
    var right: Right { get }
}

struct ConstraintExpression<T: ConstraintTarget, U: ConstraintTarget, V: Relation>: ConstraintExpressionBase {
    typealias Left = T
    typealias Right = U
    typealias Rel = V
    var left: T
    var right: U
    
    func materialize() -> some MaterializedExpression {
    }
}

protocol MaterializedExpression {
    associatedtype Left: ConstraintTarget
    associatedtype Right: ConstraintTarget
    associatedtype Rel: Relation
    
    var constraint: NSLayoutConstraint { get }
}

struct AbstractMaterializedExpression<T: ConstraintTarget, U: ConstraintTarget, V: Relation> {
    typealias Left = T
    typealias Right = U
    typealias Rel = V
    
    var constraint: NSLayoutConstraint
}

func == <T: ConstraintTarget, U: ConstraintTarget>(_ left: T, _ right: U) -> ConstraintExpression<T, U, Equal>
    where T.Kind == U.Kind, T: EqualRelationable, U: EqualRelationable {
        return ConstraintExpression(left: left, right: right)
}

protocol ExpressionContainer {
    associatedtype Sub1
    associatedtype Sub2
}


struct SingleExpressionContainer<T: ConstraintExpressionBase>: MaterializableExpressionContainer {
    typealias Sub1 = T
    typealias Sub2 = Void
    var expr: T
}

struct ExpressionContainer2<T1: ConstraintExpressionBase, T2: ConstraintExpressionBase>: ExpressionContainer {
    typealias Sub1 = T1
    typealias Sub2 = T2
}

extension ExpressionContainer where Sub1: ExpressionContainer, Sub2: MaterializableExpressionContainer {
    func materialize() -> [NSLayoutConstraint] {
        return []
    }
}

struct ConstraintBetaMaker<T> {
    var target: T
}

extension ConstraintBetaMaker {
    var leading: LeadingConstraint<T> {
        return LeadingConstraint(target: target)
    }
    var left: LeftConstraint<T> {
        return LeftConstraint(target: target)
    }
}

extension UIView {
    var snpb: ConstraintBetaMaker<UIView> {
        return ConstraintBetaMaker(target: self)
    }
}

@_functionBuilder
struct BetaDSLBuilder {
    static func buildExpression<T, U, V>(_ expr: ConstraintExpression<T, U, V>) -> some ConstraintExpressionBase {
        return expr
    }
    
    static func buildBlock<T1>(_ expr: T1) -> some ConstraintExpressionBase where T1: ConstraintExpressionBase {
        return expr
    }
    
    static func buildBlock<T1, T2>(_ expr1: T1, _ expr2: T2) -> some ConstraintExpressionBase
        where T1: ConstraintExpressionBase, T2: ConstraintExpressionBase {
        return expr
    }
}

struct BetaDSL {
    init(@BetaDSLBuilder _ builder: () -> [NSLayoutConstraint]) {
        builder()
    }
}

var someView = UIView()

var beta = BetaDSL {
    someView.snpb.leading.equal.target(someView).leading
}
