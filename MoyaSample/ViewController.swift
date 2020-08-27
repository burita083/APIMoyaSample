//
//  ViewController.swift
//  MoyaSample
//
//  Created by burita083 on 2020/08/27.
//  Copyright © 2020 burita083. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<AtCoderProblemsAPI>()
        provider.request(.problems) { result in
            switch result {
            case let .success(response):
                let jsonData = try? JSONDecoder().decode([AtCoderProblemsRepository].self, from: response.data)
                print(jsonData!.prefix(5))
            case let .failure(error):
                print(error)
            }
        }
    }


}

