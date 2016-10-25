//  Visualizer.swift
//  ArrayVisualizer
//  Created by Jonathan Ritchey on 10/24/16.
//  Copyright © 2016 Jonathan Ritchey. All rights reserved.

import Foundation

class Visualizer: NSObject {
    var array: Array<Any?>?
    var array2D: Array<Array<Any?>>?
    
    var drawKit = DrawKit()
    
    func observe(_ array: Array<Any?>) {
        self.array = array
    }
    
    func observe2D(_ array2D: Array<Array<Any?>>) {
        self.array2D = array2D
    }
    
    func look() {
        
    }
    
    open func debugQuickLookObject() -> AnyObject? {
        if let _ = array {
            return drawKit.render(array)
        }
        if let _ = array2D {
            return drawKit.render2D(array2D)
        }
        return nil
    }
}

func testQuicksort() {
    var array: [Int] = []
    let size = 50
    for _ in 0..<size {
        array.append(-10 + Int(arc4random() % 30))
    }
    quicksort(&array, lo: 0, hi: array.count - 1)
}

func testArray2D() {
    var array2D: [[Int]] = [[]]
    for _ in 0..<10 {
        var row: [Int] = []
        for _ in 0..<10 {
            row.append(-10 + Int(arc4random() % 30))
        }
        array2D.append(row)
    }
    let v = Visualizer()
    v.observe2D(array2D)
    v.look()
    print("")
}

func quicksort(_ array: inout Array<Int>, lo: Int, hi: Int) {
    let v = Visualizer()
    if lo < hi {
        v.observe(array)
        let p = quicksortPartition(&array, lo: lo, hi: hi)
        v.observe(array)
        quicksort(&array,lo:lo,hi:p-1)
        v.observe(array)
        quicksort(&array,lo:p+1,hi:hi)
    }
}

func quicksortPartition(_ array: inout Array<Int>, lo: Int, hi: Int) -> Int {
    let p = array[hi]
    var i = lo
    for j in lo..<hi {
        let aj = array[j]
        if aj < p {
            swap(&array, i, j)
            i += 1
        }
    }
    swap(&array, i, hi)
    return i
}

func swap(_ array: inout Array<Int>, _ i: Int, _ j: Int) {
    let temp = array[i]
    array[i] = array[j]
    array[j] = temp
}
