//
//  SequenceAction.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class SequenceAction: NSObject {
    
    private var action: (((NSError?) -> Void) -> Void)!
    
    init(fn: ((NSError?) -> Void) -> Void) {
        
        self.action = fn
    }
    
    func run(callback: (NSError?) -> Void) {
        
        self.action(callback)
    }
}