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



public protocol ConstraintTarget {
    associatedtype Kind
    associatedtype Target: LayoutConstraintItem
    
    var target: Target { get }
    var constant: CGFloat { get }
    var multiplier: CGFloat { get }
    static var attribute: NSLayoutConstraint.Attribute { get }
    static func +(_ left: Self, _ right: ConstraintOffsetTarget) -> Self
}


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

//public struct ConstraintExpression<T: ConstraintTarget, U: ConstraintTarget, V: Relation>: ConstraintExpressionBase, Constraints {
//
//}

public func == <T: ConstraintTarget, U: ConstraintTarget>(_ left: T, _ right: U) -> Constraint<T, U, Equal>
    where T.Kind == U.Kind, T: EqualRelationable, U: EqualRelationable {
    return Constraint(from: left, to: right)
}

public protocol Constraints {
    func materialize() -> [NSLayoutConstraint]
    static func update(_ new: Self, _ old: Self, constraints: inout [NSLayoutConstraint])
    var count: Int { get }
}

protocol SimpleMat {
    var constraints: [NSLayoutConstraint] { get }
    var count: Int { get }
    func update(_ old: SimpleMat, constraints: inout [NSLayoutConstraint])
}

public struct TupleConstraint<T>: Constraints {
    var value: T
    
    struct Mat<U: Constraints>: SimpleMat {
        let ctr: U
        var constraints: [NSLayoutConstraint] {
            ctr.materialize()
        }
        var count: Int {
            return ctr.count
        }

        func update(_ old: SimpleMat, constraints: inout [NSLayoutConstraint]) {
            let old = old as! Self
            print(constraints.count)
            U.update(ctr, old.ctr, constraints: &constraints)
        }
        
        init(_ c: U) {
            self.ctr = c
        }
    }
    
    func mat<U: Constraints>(_ val: U) -> SimpleMat {
        return Mat(val)
    }
    
    public var count: Int {
        return materializer(self).reduce(0) { r, v in r + v.count }
    }
    
    var materializer: (Self) -> [SimpleMat]
    
    public func materialize() -> [NSLayoutConstraint] {
        return materializer(self).flatMap { $0.constraints }
    }
}

public struct EitherConstraint<T1, T2>: Constraints where T1: Constraints, T2: Constraints {
    enum Value {
        case left(T1)
        case right(T2)
    }
    
    var value: Value
    
    public var count: Int {
        switch value {
        case let .left(v):
            return v.count
        case let .right(v):
            return v.count
        }
    }
    
    public func materialize() -> [NSLayoutConstraint] {
        switch value {
        case let .left(v):
            return v.materialize()
        case let .right(v):
            return v.materialize()
        }
    }
}

extension TupleConstraint {
    public static func update(_ new: TupleConstraint, _ old: TupleConstraint, constraints: inout [NSLayoutConstraint]) {
        print("tuple")
        var result: [NSLayoutConstraint] = []
        print(constraints.count)
        zip(new.materializer(new), old.materializer(old)).forEach { t in
            let (new, old) = t
            var slice = Array(constraints.prefix(old.count))
            print(old.count)
            new.update(old, constraints: &slice)
            result.append(contentsOf: slice)
            constraints.removeSubrange(0..<old.count)
        }
        constraints = result
    }
}

extension EitherConstraint {
    public static func update(_ new: EitherConstraint, _ old: EitherConstraint, constraints: inout [NSLayoutConstraint]) {
        if let new = new as? EitherConstraint<T1, T1>, let old = old as? EitherConstraint<T1, T1> {
            print("same left right")
            switch (new.value, old.value) {
            case let (.left(leftV), .left(rightV)), let (.left(leftV), .right(rightV)), let (.right(leftV), .left(rightV)), let (.right(leftV), .right(rightV)):
                var slice = Array(constraints.prefix(old.count))
                T1.update(leftV, rightV, constraints: &slice)
                constraints.replaceSubrange(0..<old.count, with: slice)
            }
        } else {
            print("Diff left right")
            switch (new.value, old.value) {
            case let (.left(leftV), .left(rightV)):
                var slice = Array(constraints.prefix(old.count))
                T1.update(leftV, rightV, constraints: &slice)
                constraints.replaceSubrange(0..<old.count, with: slice)
            case let (.right(leftV), .right(rightV)):
                var slice = Array(constraints.prefix(old.count))
                T2.update(leftV, rightV, constraints: &slice)
                constraints.replaceSubrange(0..<old.count, with: slice)
            case let (.left(leftV), .right):
                constraints.replaceSubrange(0..<old.count, with: leftV.materialize())
            case let (.right(leftV), .left):
                constraints.replaceSubrange(0..<old.count, with: leftV.materialize())
            }
        }
    }
}

@_functionBuilder
public struct BetaDSLBuilder {
//    static func buildExpression<T, U, V>(_ expr: ConstraintExpression<T, U, V> /*, line: UInt = #line, file: StaticString = #file
// */) -> some Constraints {
//        return SingleConstraint<ConstraintExpression<T, U, V>>(constraint: expr)
//    }

    public static func buildBlock<T1: Constraints>(_ expr: T1) -> some Constraints {
        return expr
    }
    
    public static func buildBlock<T1: Constraints, T2: Constraints>(_ expr1: T1, _ expr2: T2) -> some Constraints {
        return TupleConstraint<(T1, T2)>(value: (expr1, expr2)) { t in
            [t.mat(t.value.0), t.mat(t.value.1)]
        }
    }
    
    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3) -> some Constraints {
        return TupleConstraint<(T1, T2, T3)>(value: (e1, e2, e3)) { t in
            [t.mat(t.value.0), t.mat(t.value.1), t.mat(t.value.2)]
        }
    }
    
    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4)>(value: (e1, e2, e3, e4)) { t in
            [t.mat(t.value.0), t.mat(t.value.1), t.mat(t.value.2), t.mat(t.value.3)]
        }
    }
    
    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints, T5: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4, _ e5: T5) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4, T5)>(value: (e1, e2, e3, e4, e5)) { t in
            [t.mat(t.value.0), t.mat(t.value.1), t.mat(t.value.2), t.mat(t.value.3), t.mat(t.value.4)]
        }
    }
    
    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints, T5: Constraints, T6: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4, _ e5: T5, _ e6: T6) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4, T5, T6)>(value: (e1, e2, e3, e4, e5, e6)) { t in
            let t1 = t.mat(t.value.0)
            let t2 = t.mat(t.value.1)
            let t3 = t.mat(t.value.2)
            let t4 = t.mat(t.value.3)
            let t5 = t.mat(t.value.4)
            let t6 = t.mat(t.value.5)
            return [t1, t2, t3, t4, t5, t6]
        }
    }

    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints, T5: Constraints, T6: Constraints, T7: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4, _ e5: T5, _ e6: T6, _ e7: T7) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4, T5, T6, T7)>(value: (e1, e2, e3, e4, e5, e6, e7)) { t in
            let t1 = t.mat(t.value.0)
            let t2 = t.mat(t.value.1)
            let t3 = t.mat(t.value.2)
            let t4 = t.mat(t.value.3)
            let t5 = t.mat(t.value.4)
            let t6 = t.mat(t.value.5)
            let t7 = t.mat(t.value.6)
            return [t1, t2, t3, t4, t5, t6, t7]
        }
    }

    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints, T5: Constraints, T6: Constraints, T7: Constraints, T8: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4, _ e5: T5, _ e6: T6, _ e7: T7, _ e8: T8) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4, T5, T6, T7, T8)>(value: (e1, e2, e3, e4, e5, e6, e7, e8)) { t in
            let t1 = t.mat(t.value.0)
            let t2 = t.mat(t.value.1)
            let t3 = t.mat(t.value.2)
            let t4 = t.mat(t.value.3)
            let t5 = t.mat(t.value.4)
            let t6 = t.mat(t.value.5)
            let t7 = t.mat(t.value.6)
            let t8 = t.mat(t.value.7)
            return [t1, t2, t3, t4, t5, t6, t7, t8]
        }
    }

    public static func buildBlock
        <T1: Constraints, T2: Constraints, T3: Constraints, T4: Constraints, T5: Constraints, T6: Constraints, T7: Constraints, T8: Constraints, T9: Constraints>
        (_ e1: T1, _ e2: T2, _ e3: T3, _ e4: T4, _ e5: T5, _ e6: T6, _ e7: T7, _ e8: T8, _ e9: T9) -> some Constraints {
        return TupleConstraint<(T1, T2, T3, T4, T5, T6, T7, T8, T9)>(value: (e1, e2, e3, e4, e5, e6, e7, e8, e9)) { t in
            let t1 = t.mat(t.value.0)
            let t2 = t.mat(t.value.1)
            let t3 = t.mat(t.value.2)
            let t4 = t.mat(t.value.3)
            let t5 = t.mat(t.value.4)
            let t6 = t.mat(t.value.5)
            let t7 = t.mat(t.value.6)
            let t8 = t.mat(t.value.7)
            let t9 = t.mat(t.value.8)
            return [t1, t2, t3, t4, t5, t6, t7, t8, t9]
        }
    }
    
    public static func buildEither<T1: Constraints, T2: Constraints>(first: T1) -> EitherConstraint<T1, T2> {
        return EitherConstraint<T1, T2>(value: .left(first))
    }
    
    public static func buildEither<T1: Constraints, T2: Constraints>(second: T2) -> EitherConstraint<T1, T2> {
        return EitherConstraint<T1, T2>(value: .right(second))
    }
    

}

public protocol DSL {
    associatedtype Ctr: Constraints
    
    func apply()
    func update(_ old: Self)
}


public func Build<T: Constraints>(@BetaDSLBuilder _ builder: () -> T) -> some DSL {
    return BetaDSL<T>(constraints: builder())
}


public class BetaDSL<T: Constraints>: DSL {
    internal init(constraints: T) {
        self.constraints = constraints
    }
    
    public typealias Ctr = T
    
    var constraints: T
    var saved: [NSLayoutConstraint] = []
    
    public func apply() {
        saved = constraints.materialize()
        NSLayoutConstraint.activate(saved)
        print(saved)
    }
    
    public func update(_ old: BetaDSL) {
        self.saved  = old.saved
        print(self.saved.count)
        Ctr.update(constraints, old.constraints, constraints: &self.saved)
        print(self.saved.count)
        let x = Set<NSLayoutConstraint>(old.saved)
        let y = Set<NSLayoutConstraint>(self.saved)
        NSLayoutConstraint.deactivate(Array(x.subtracting(y)))
        NSLayoutConstraint.activate(Array(y.subtracting(x)))
    }
}
