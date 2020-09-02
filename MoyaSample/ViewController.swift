//
//  ViewController.swift
//  MoyaSample
//
//  Created by burita083 on 2020/08/27.
//  Copyright © 2020 burita083. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController, Alert {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<AtCoderProblemsAPI>()
        provider.request(.problems) { result in
            switch result {
            case let .success(response):
                let jsonData = try? JSONDecoder().decode([AtCoderProblemsRepository].self, from: response.data)
                jsonData!.prefix(5).forEach { print($0.title) }
            case let .failure(error):
                print(error)
            }
        }
        
        // test modalVC
        // property渡したい場合はこれだとだめ
        //self.present(TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController"), animated: true, completion: nil)
        
        self.navigationController?.pushViewController(TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController"), animated: true)
    }
}


protocol Alert where Self: UIViewController {
    func showAlert(title: String?, message: String?, callback: @escaping () -> Void)
}

extension Alert {
    func showAlert(title: String?, message: String?, callback: @escaping () -> Void) {
           let alertController = UIAlertController(title: title,
                                                   message: message,
                                                   preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK",
                                        style: .default) { action in
               callback()
           }
           let cancelAction = UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil)
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           present(alertController, animated: true, completion: nil)
       }
}

protocol Instantiatable {
    static var storyboardName: String { get }
}

extension Instantiatable where Self: UIViewController {
    static var storyboardName: String {
        return ""
    }

    private static var _storyboardName: String {
        if storyboardName.isEmpty {
            return className
        } else {
            return storyboardName
        }
    }

    private static var storyboard: UIStoryboard {
        return UIStoryboard.init(name: _storyboardName, bundle: nil)
    }

    private static var className: String {
        return String(describing: Self.self)
    }

    static func instantiateFromStoryboard() -> Self {
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Can no instantiate \(Self.className) from \(storyboardName).storyboard")
        }
        return vc
    }

    static func instantiateFromStoryboard(withIdentifier id: String) -> Self {
        guard let vc = storyboard.instantiateViewController(withIdentifier: id) as? Self else {
            fatalError("Can no instantiate \(Self.className) from \(storyboardName).storyboard with id: \(id)")
        }
        return vc
    }
}



