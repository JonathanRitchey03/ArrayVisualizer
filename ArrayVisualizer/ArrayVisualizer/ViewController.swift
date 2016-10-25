//
//  ViewController.swift
//  ArrayVisualizer
//
//  Created by Jonathan Ritchey on 10/24/16.
//  Copyright © 2016 Jonathan Ritchey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //testQuicksort()
        testArray2D()
        let v = Visualizer()
        let array = [1,2,3]
        v.observe(array)
        let array2: [Int?] = [1, nil, 2, 3, 4, 10, 100, 20]
        v.observe(array2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

