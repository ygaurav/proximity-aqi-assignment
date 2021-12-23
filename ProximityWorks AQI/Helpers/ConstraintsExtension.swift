//
//  ConstraintsExtension.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 22/12/21.
//

import Foundation
import UIKit

public extension NSLayoutXAxisAnchor {
    
    func equals(_ anchor: NSLayoutXAxisAnchor, plus points: CGFloat) {
        self.constraint(equalTo: anchor, constant: points).isActive = true
    }
    
}

public extension NSLayoutYAxisAnchor {
    
    func equals(_ anchor: NSLayoutYAxisAnchor, plus points: CGFloat) {
        self.constraint(equalTo: anchor, constant: points).isActive = true
    }
    
}

infix operator ==== :  AssignmentPrecedence

public func ==== (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) {
    lhs.constraint(equalTo: rhs).isActive = true
}

public func ==== (lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
    lhs.constraint(equalTo: rhs).isActive = true
}

public func ==== (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) {
    lhs.constraint(equalTo: rhs).isActive = true
}

public func ==== (lhs: NSLayoutDimension, rhs: CGFloat) {
    lhs.constraint(equalToConstant: rhs).isActive = true
}

// Anchor with additional 8 points
infix operator ==|== :  AssignmentPrecedence

public func ==|== (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) {
    lhs.constraint(equalTo: rhs, constant: 8).isActive = true
}

public func ==|== (lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
    lhs.constraint(equalTo: rhs, constant: 8).isActive = true
}

public func ==|== (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) {
    lhs.constraint(equalTo: rhs, constant: 8).isActive = true
}

// Anchor with additional 16 points
infix operator ==||== : AssignmentPrecedence

public func ==||== (lhs: NSLayoutYAxisAnchor, rhs: NSLayoutYAxisAnchor) {
    lhs.constraint(equalTo: rhs, constant: 16).isActive = true
}

public func ==||== (lhs: NSLayoutDimension, rhs: NSLayoutDimension) {
    lhs.constraint(equalTo: rhs, constant: 16).isActive = true
}

public func ==||== (lhs: NSLayoutXAxisAnchor, rhs: NSLayoutXAxisAnchor) {
    lhs.constraint(equalTo: rhs, constant: 16).isActive = true
}
