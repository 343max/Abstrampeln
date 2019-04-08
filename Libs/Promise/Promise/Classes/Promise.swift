// Copyright Max von Webel. All Rights Reserved.

import Foundation

public protocol UntypedPromise {
  typealias UntypedThenCall = () -> Void
  typealias ErrorCall = (_ error: Error) -> Void
  
  @discardableResult func then(_ completion: @escaping UntypedThenCall) -> Self
  @discardableResult func fail(_ failedCompletion: @escaping ErrorCall) -> Self
  func `throw`(error: Error)
}

public class Promise<T> : UntypedPromise {
  public typealias ReturnType = T
  public typealias CompletionCallback = (_ result: T) -> Void
  public typealias ThenCall = (_ result: T) -> Void
  
  public private(set) var error: Error?
  public private(set) var result: T?
  
  public var fulfilled: Bool {
    get {
      return result != nil
    }
  }
  
  public var failed: Bool {
    get {
      return error != nil
    }
  }
  
  public var thenCalls: [ThenCall] = []
  public var errorCalls: [ErrorCall] = []
  
  public let multiCall: Bool
  
  public convenience init(multiCall: Bool = false) {
    self.init({ (_, _) in }, multiCall: multiCall)
  }
  
  public convenience init(_ setup: @escaping (_ complete: @escaping CompletionCallback) throws -> Void, multiCall: Bool = false) {
    let fullSetup = { (_ complete: @escaping CompletionCallback, _ promise: Promise) throws -> Void in
      try setup(complete)
    }
    
    self.init(fullSetup, multiCall: multiCall)
  }
  
  public init(_ setup: @escaping (_ complete: @escaping CompletionCallback, _ promise: Promise) throws -> Void, multiCall: Bool = false) {
    self.multiCall = multiCall
    do {
      try setup({ (result) in
        self.result = result
        
        self.handle(thens: self.thenCalls)
      }, self)
    } catch {
      self.error = error
      
      self.handle(fails: self.errorCalls)
    }
  }
  
  private func handle(thens: [ThenCall]) {
    guard let result = self.result else {
      return
    }
    
    for thenCall in thens {
      thenCall(result)
    }
  }
  
  private func handle(fails: [ErrorCall]) {
    guard let error = self.error else {
      return
    }
    
    for errorCall in fails {
      errorCall(error)
    }
  }
  
  public func `throw`(error: Error) {
    self.error = error
    
    handle(fails: errorCalls)
  }
  
  public func fulfill(_ result: T) {
    assert(!fulfilled || multiCall, "promise already fulfilled")
    self.result = result
    handle(thens: thenCalls)
  }
  
  @discardableResult public func then(_ completion: @escaping ThenCall) -> Self {
    thenCalls.append(completion)
    handle(thens: [completion])
    return self
  }
  
  @discardableResult public func then(_ completion: @escaping UntypedPromise.UntypedThenCall) -> Self {
    self.then { (_) in
      completion()
    }
    
    return self
  }
  
  @discardableResult public func fail(_ failedCompletion: @escaping ErrorCall) -> Self {
    errorCalls.append(failedCompletion)
    handle(fails: [failedCompletion])
    return self
  }
  
  public func map<U>(_ mapping: @escaping (_ result: T) -> U) -> Promise<U> {
    return Promise<U>({ (completion) in
      self.then({ (result) in
        completion(mapping(result))
      })
    })
  }
  
  public func mapPromise<U>(_ mapping: @escaping (_ result: T) -> Promise<U>) -> Promise<U> {
    return Promise<U>({ (completion) in
      self.then { (result) in
        mapping(result).then { (result2) in
          completion(result2)
        }
      }
    })
  }
  
  public func map<U>(_ mapping: @escaping (_ result: T, _ completion: @escaping (U) -> ()) -> ()) -> Promise<U> {
    return Promise<U>({ (completion) in
      self.then { (result) in
        mapping(result, completion)
      }
    })
  }
}

extension Promise {
  // combines cascading promises into one single promise that fires when the last promise fires
  public func combine<T>(_ callback: @escaping (_ result: ReturnType) -> (Promise<T>)) -> Promise<T> {
    return Promise<T>({ [weak self] (finalCallback: @escaping (_: T) -> Void) in
      guard let self = self else {
        return
      }
      
      self.then { (result) in
        callback(result).then {
          finalCallback($0)
        }
      }
    })
  }
}


func allDone<T>(_ promiseContainer: T) -> Promise<T> {
  return Promise<T>({ (completion, allDonePromise) in
    let promises: [UntypedPromise]
    if let dict = promiseContainer as? [AnyHashable: Any] {
      promises = dict.values.compactMap { $0 as? UntypedPromise }
    } else {
      promises = Mirror(reflecting: promiseContainer).children.compactMap { $0.value as? UntypedPromise }
    }
    
    var remaining = promises.count
    for promise in promises {
      promise.then {
        remaining -= 1
        if remaining == 0 {
          completion(promiseContainer)
        }
      }
      
      promise.fail { (error) in
        allDonePromise.throw(error: error)
      }
    }
  })
}
