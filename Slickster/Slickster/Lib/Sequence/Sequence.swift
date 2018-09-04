//
//  Sequence.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class Sequence {
    
    var taskIndex: Int! = 0
    var taskList: [SequenceAction]! = [SequenceAction]()
    
    func appendTask(task: SequenceAction) {
    
        taskList.append(task)
    }
    
    func run(callback: (NSError?) -> Void) {
        
        taskIndex = 0
        runInternal(callback)
    }
    
    private func runInternal(callback: (NSError?) -> Void) {
        
        if(taskIndex < taskList.count) {
            
            let task = taskList[taskIndex]
            task.run({ (err: NSError?) -> Void in
                
                // If error callback rightaway with error flag.
                if(err != nil) {
                    
                    callback(err!)
                    return
                }
                
                self.taskIndex = self.taskIndex + 1
                self.runInternal(callback)
            })
            
        } else {
            
            // All sequence successfully run.
            callback(nil)
        }
    }
}