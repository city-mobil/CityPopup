//
//  ImplementationInfix.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

/*
 
 let label = UILabel(frame: view.bounds) ~> {
     $0.font = ...
     $0.textColor = ...
     $0.text = ...
     ...
 }
 
 -----------------------------------
 
 let label: UILabel?
 
 // xx: UILabel?
 let xx = label ~> {
    $0.font = ...
 }
 
 ------------------------------------
 
 be careful to use this with structs, in closure
 it is possible that we works with copy
 
 **/

// tap self
infix operator ~>
@discardableResult func ~> <U> (value: U, closure: ((inout U) -> Void)) -> U {
    var returnValue = value
    closure(&returnValue)
    return returnValue
}

// tap self
infix operator ~>?
@discardableResult func ~>? <U> (value: U?, closure: ((inout U) -> Void)) -> U? {
    guard var returnValue = value else { return value }
    closure(&returnValue)
    return returnValue
}

// tap and possible transform self
infix operator ->?
func ->? <U, T> (value: U?, closure: (U) -> T?) -> T? {
    guard let value = value else { return nil }
    return closure(value)
}
