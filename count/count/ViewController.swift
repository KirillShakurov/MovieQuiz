//
//  ViewController.swift
//  count
//
//  Created by Kirill on 02.09.2022.
//

import UIKit

class ViewController: UIViewController {
    var count: Int = 0
   
    @IBOutlet weak var countName: UILabel!
    @IBOutlet weak var countView: UILabel!
    @IBOutlet weak var countButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countView.text = "0"
        countButton.setTitle("CLICK and COUNT", for: .normal)
    }



    @IBAction func countDo(_ sender: Any) {
        count = count + 1
        countView.text = "\(count)"
    }
    
}

