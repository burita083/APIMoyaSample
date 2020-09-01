//
//  TestViewController.swift
//  MoyaSample
//
//  Created by burita083 on 2020/09/01.
//  Copyright © 2020 burita083. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.isModalInPresentation = true
        self.modalPresentationStyle = .formSheet //or .overFullScreen for transparency
    }
}
extension TestViewController: Instantiatable {}
