//
//  ViewController.swift
//  multithreadDemo
//
//  Created by muhlenXi on 2019/11/25.
//  Copyright © 2019 muhlenXi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var threadsSets = Set<String>()
    
    let mainQueue = DispatchQueue.main
    let globalQueue = DispatchQueue.global()
    let mySerialQueue = DispatchQueue(label: "com.muhlenxi.myQueue.serial")
    let myConcurrentQueue = DispatchQueue(label: "com.muhlenxi.myQueue.concurrent", attributes: DispatchQueue.Attributes.concurrent)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(mainQueue)
        print(globalQueue)
        print(mySerialQueue)
        print(myConcurrentQueue)
        
    }
}

// MARK: - Button Events
extension ViewController {
    @IBAction func onClickMainQueueAsyncButton(_ sender: UIButton) {
        task1()
        asyncPerformTask(queue: mainQueue, perform: task2)
        task3()
    }
    
    @IBAction func onClickGlobalQueueSyncButton(_ sender: UIButton) {
        syncPerformTask(queue: globalQueue, perform: task1)
        syncPerformTask(queue: globalQueue, perform: task2)
        syncPerformTask(queue: globalQueue, perform: task3)
    }
    
    @IBAction func onClickGlobalQueueAsyncButton(_ sender: UIButton) {
        asyncPerformTask(queue: globalQueue, perform: task1)
        asyncPerformTask(queue: globalQueue, perform: task2)
        asyncPerformTask(queue: globalQueue, perform: task3)
    }
    
    @IBAction func onClickMySerialQueueSyncButton(_ sender: UIButton) {
        syncPerformTask(queue: mySerialQueue, perform: task1)
        syncPerformTask(queue: mySerialQueue, perform: task2)
        syncPerformTask(queue: mySerialQueue, perform: task3)
    }
    
    @IBAction func onClickMySerialQueueAsyncButton(_ sender: UIButton) {
        asyncPerformTask(queue: mySerialQueue, perform: task1)
        asyncPerformTask(queue: mySerialQueue, perform: task2)
        asyncPerformTask(queue: mySerialQueue, perform: task3)
    }
    
    @IBAction func onClickMyConcurrentQueueSyncButton(_ sender: UIButton) {
        syncPerformTask(queue: myConcurrentQueue, perform: task1)
        syncPerformTask(queue: myConcurrentQueue, perform: task2)
        syncPerformTask(queue: myConcurrentQueue, perform: task3)
    }
    
    @IBAction func onClickMyConcurrentQueueAsyncButton(_ sender: UIButton) {
        asyncPerformTask(queue: myConcurrentQueue, perform: task1)
        asyncPerformTask(queue: myConcurrentQueue, perform: task2)
        asyncPerformTask(queue: myConcurrentQueue, perform: task3)
    }
    
    @IBAction func onClickGCDMaxThreadsButton(_ sender: UIButton) {
       let group = DispatchGroup()
       for _ in 0..<100 {
           globalQueue.async(group: group, qos: DispatchQoS.default, flags: [], execute: {
               self.threadsSets.insert(Thread.current.debugDescription)
               self.task1()
           })
       }
       group.notify(queue: .main) {
           print(self.threadsSets.count)
       }
    }
    
    @IBAction func onClickOperationQueueButton(_ sender: UIButton) {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        
        let block1 = BlockOperation(block: task1)
        let block2 = BlockOperation(block: task2)
        let block3 = BlockOperation(block: task3)
        
        block1.addDependency(block2)
        block2.addDependency(block3)
        
        operationQueue.addOperation(block1)
        operationQueue.addOperation(block2)
        operationQueue.addOperation(block3)
    }
}

// MARK: - Perform task
extension ViewController {
    func syncPerformTask(queue: DispatchQueue, perform:() -> Void) {
        queue.sync {
            // print(Thread.current)
            perform()
        }
    }
    
    func asyncPerformTask(queue: DispatchQueue, perform: @escaping () -> Void) {
        queue.async {
            // print(Thread.current)
            perform()
        }
    }
    
    func task1() {
        print("task 1 start")
        sleep(1)
        print("task 1 finish")
    }
    
    func task2() {
        print("task 2 start")
        sleep(2)
        print("task 2 finish")
    }
    
    func task3() {
        print("task 3 start")
        sleep(3)
        print("task 3 finish")
    }
}


