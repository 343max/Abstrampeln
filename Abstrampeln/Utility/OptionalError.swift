// copied from: https://www.objc.io/blog/2019/02/26/from-optionals-to-errors/

import Foundation

infix operator ?!: NilCoalescingPrecedence
public func ?!<A>(lhs: A?, rhs: Error) throws -> A { // swiftlint:disable:this operator_whitespace
  guard let value = lhs else {
    throw rhs
  }
  return value
}
