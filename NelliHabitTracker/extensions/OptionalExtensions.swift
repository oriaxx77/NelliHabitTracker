//
//  OptionalExtensions.swift
//  NelliHabitTracker
//
//  Created by Bagyura Istvan on 2020. 12. 17..
//

import Foundation

//
//  OptionalExtensions.swift
//  SellerIPhone
//
//  Created by Bagyura Istvan on 2020. 05. 19..
//  Copyright © 2020. Bagyura Istvan. All rights reserved.
//

import Foundation

public extension Optional {
    // MARK: emptyness
    var isNone: Bool {
        self == nil
    }
    
    var isSome: Bool {
        return !isNone
    }
    
    // MARK: - OR
    // E.g. image.or(defaultImage)
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    // E.g. image.or(else: db.load())
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
   
    // E.g. image.or { db.load() }
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    // E.g. image.or(throw: .imageNotFound)
    func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
    
    // E.g. answer.or(secondChoice: getAnswer()).or(secondChoice: getAnswerFromOtherSource())
    func or(sencondChoice: @autoclosure () -> Optional<Wrapped>) -> Optional<Wrapped> {
        return self ?? sencondChoice()
    }
    
    // E.g. answer.or(secondChoice: getAnswer ).or( secondChoice: getAnswerFromOtherSource )
    // E.g. answer.or(secondChoice: {getAnswer()}.or(secondChoice:{getAnswerFromOtherSource()}
    func or(secondChoice: () -> Optional<Wrapped>) -> Optional<Wrapped> {
        return self ?? secondChoice()
    }
    
    
    // MARK - then
    // E.g. question.then(sendQuestion(:))
    func then(_ f: (Wrapped) -> Void) {
        if let wrapped = self { f(wrapped) }
    }
    
    // FILTER
    // E.g. message.
    func filter(_ predicate: (Wrapped) -> Bool) -> Optional<Wrapped> {
        guard let unwrapped = self,
            predicate(unwrapped) else { return nil }
        return self
    }
    
    func fulfill(_ condition: (Wrapped) -> Bool) -> Bool {
        guard let unwrapped = self,
            condition(unwrapped) else { return false }
        return true
    }
    
    
    // MARK on
    
    func on( none f: () throws -> Void) rethrows {
        if isNone { try f() }
    }
    
    func on( some f: () throws -> Void) rethrows {
        if isSome { try f() }
    }
    
    func fold( someF: (Wrapped) throws -> Void,
               noneF: () throws -> Void ) rethrows {
        if isSome { try someF(self!)}
        else { try noneF() }
    }
    
    /*
 
 // Optinal Extensions - new
 public extension Optional {
     
     
     
     
     
     
     
     
     // MARK - then
     
     // E.g. should { try throwingFunction) }.or(print($0))
     func then(_ f: (Wrapped) -> Void) {
         if let wrapped = self { f(wrapped) }
     }
     
     func should(_ do:() throws -> Void ) -> Error? {
         do{
             try `do`()
             return nil
         } catch let error {
             return error
         }
     }
     // TODO: implement this
     /*
      func should(_ do:(Wrapped) throws -> Void ) -> Error? {
      do{
      // try `do`(self)
      return nil
      } catch let error {
      return error
      }
      }*/
     
     
     // MARK - map
     
     func map<T>(_ fn: (Wrapped) throws -> T, default: T) rethrows -> T {
         return try map(fn) ?? `default`
     }
     
     func map<T>(_ fn: (Wrapped) throws -> T, else: () throws -> T) rethrows -> T {
         return try map(fn) ?? `else`()
     }
     
     // MARK - filter
     
     /// Returns the unwrapped value of the optional only if
     /// - The optional has a value
     /// - The value satisfies the predicate `predicate`
     
     // E.g. users.each( user.filter( hasAdminRole ).then( admins.add ) )
     func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
         guard let unwrapped = self,
             predicate(unwrapped) else { return nil }
         return self
     }
     
     // E.g. user.fulfill( isAdmin )
     func fulfill( _ condition: (Wrapped) -> Bool ) -> Bool {
         guard let unwrapped = self,
             condition(unwrapped ) else { return false }
         return true
     }
     
     /*
      func filter(_ predicate: (Wrapped) -> Bool) -> Optional<Wrapped> {
      return map(predicate) == .some(true) ? self : .none
      }
      */
     
     /// Returns the wrapped value or crashes with `fatalError(message)`
     func expect(_ message: String) -> Wrapped {
         guard let value = self else { fatalError(message) }
         return value
     }
     
     // MARK combining optionals
     
     /// Tries to unwrap `self` and if that succeeds continues to unwrap the parameter `optional`
     /// and returns the result of that.
     
     
     // E.g. a.and( B() )
     func and<B>(_ optional: B?) -> B? {
         guard self != nil else { return nil }
         return optional
     }
     
     /// Executes a closure with the unwrapped result of an optional.
     /// This allows chaining optionals together.
     
     // E.g. user.and( then: {(user) in emailService.sendEmailTo( user )}  )
     func and<T>(then: (Wrapped) throws -> T?) rethrows -> T? {
         guard let unwrapped = self else { return nil }
         return try then(unwrapped)
     }
     
     /// Zips the content of this optional with the content of another
     /// optional `other` only if both optionals are not empty
     
     // E.g.: myTuple = a.zip2( with: b ) // (a,b)
     func zip2<A>(with other: Optional<A>) -> (Wrapped, A)? {
         guard let first = self, let second = other else { return nil }
         return (first, second)
     }
     
     /// Zips the content of this optional with the content of another
     /// optional `other` only if both optionals are not empty
     func zip3<A, B>(with other: Optional<A>, another: Optional<B>) -> (Wrapped, A, B)? {
         guard let first = self,
             let second = other,
             let third = another else { return nil }
         return (first, second, third)
     }
     
     // TODO: zipN with monads
     
     // MARK on
     
     func on( none f: () throws -> Void) rethrows {
         if isNone { try f() }
     }
     
     func on( some f: () throws -> Void) rethrows {
         if isSome { try f() }
     }
     
     func fold( someF: (Wrapped) throws -> Void,
                noneF: () throws -> Void ) rethrows {
         if isSome { try someF(self!)}
         else { try noneF() }
     }
     
 }

 extension Optional where Wrapped == Error {
     /// Only perform `else` if the optional has a non-empty error value
     func or(_ else: (Error) -> Void) {
         guard let error = self else { return }
         `else`(error)
     }
 }

 extension Optional where Wrapped == String {
     var isEmpty: Bool {
         return self?.isEmpty ?? true
     }
     
     var notEmpty: Bool {
         return !isEmpty
     }
 }

 */
}


