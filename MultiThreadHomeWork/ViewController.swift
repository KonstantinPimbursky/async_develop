//
//  ViewController.swift
//  MultiThreadHomeWork
//
//  Created by Alexey Golovin on 19.02.2021.
//
/*

 Разберитесь в коде, указанном в данном примере.
 Вам нужно определить где конкретно реализованы проблемы многопоточности (Race Condition, Deadlock) и укажите их. Объясните, из-за чего возникли проблемы.
 Попробуйте устранить эти проблемы.
 Готовый проект отправьте на проверку. 
 
*/

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exampleOne()
        exampleTwo()
    
    }
    
    //В первом методе мы наблюдаем Race Condition. Чтобы этого не возникало, необходимо очереди запустить синхронно.
    func exampleOne() {
        var storage: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        concurrentQueue.sync {
            for i in 0...1000 {
                sleep(1)
                storage.append("Cell: \(i)")
            }
        }

        concurrentQueue.sync {
            for i in 0...1000 {
                storage[i] = "Box: \(i)"
            }
        }
    }
    
    //Во втором методе мы наблюдаем DeadLock. На главном потоке запускается асинхронно очередь, которая запускает синхронно тоже на главном потоке вторую очередь. Синхронная очередь не может начать выполняться, пока не завершится первая, а первая не может завершиться, т.к. не может запустить вторую. Чтобы решить проблему, обе очереди запускаем асинхронно.
    func exampleTwo() {
        print("a")
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                print("b")
            }
            print("c")
        }
        print("d")
    }
}

