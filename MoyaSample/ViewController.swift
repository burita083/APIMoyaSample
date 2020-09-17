//
//  ViewController.swift
//  MoyaSample
//
//  Created by burita083 on 2020/08/27.
//  Copyright © 2020 burita083. All rights reserved.
//

import UIKit
import Moya
import Parchment


class ViewController: UIViewController, Alert {

    @IBOutlet var testPushButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstViewController = FirstViewController.instantiateFromStoryboard(withIdentifier: "FirstViewController")
        firstViewController.title = "Test1"
        let secondViewController = UIViewController()
        secondViewController.title = "Test2"
        secondViewController.view.backgroundColor = UIColor.yellow
        
        let thirdViewController = UIViewController()
        thirdViewController.title = "Test3"
        thirdViewController.view.backgroundColor = UIColor.blue
        
        let fourthViewController = UIViewController()
        fourthViewController.title = "Test4"
        fourthViewController.view.backgroundColor = UIColor.green
        
        let fifthViewController = UIViewController()
        fifthViewController.title = "Test5"
        fifthViewController.view.backgroundColor = UIColor.purple
        
        let pagingViewController = PagingViewController(viewControllers: [
          firstViewController,
          secondViewController,
          thirdViewController,
          fourthViewController,
          fifthViewController
        ])
        


        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 64) // 動的に取りたいがTODO
        ])

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
        
        print("aaaaaaaaaa")
        let randomNumber = generateRandomNumber(maximum: -1)
        switch randomNumber {
        case .failure(let error):
            switch error {
            case .noAgeProvided:
                print("noAge")
            case .noEmailProvided:
                print("email")
            case .noLastNameProvided:
                print("last")
            }
        case .success(let num):
            print(num)
        }


        // test modalVC
        // property渡したい場合はこれだとだめ
        //self.present(TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController"), animated: true, completion: nil)
        
        //self.navigationController?.pushViewController(TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController"), animated: true)
        print("CanThrow")
        do {
            let str = try canThrowErrors(num: 0)
            print(str)
        } catch NumError.minus {
            print("minus")
        } catch NumError.zero(let errorMessage) {
            print(errorMessage)
        } catch UserValidationError.noEmailProvided {
            print("NoEmailProvided")
        } catch {
            print("Ohter")
        }
        
        

        do {
            try error()
        } catch FactorError.belowMinimum(let message) {
            print(message)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func buttonTap(_ sender: Any) {
        self.navigationController?.pushViewController(TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController"), animated: true)
    }
    
    func error() throws {
        throw FactorError.belowMinimum("0より小さいです")
    }
    

   

    func generateRandomNumber(maximum: Int) -> Result<Int, UserValidationError> {
        if maximum < 0 {
            //return .failure(.belowMinimum)
            return .failure(.noLastNameProvided)
        } else {
            return .success(1)
        }
    }
    
    
    
    private func canThrowErrors(num: Int) throws -> String {
        if num < 0 {
            throw UserValidationError.noAgeProvided
        }
        
        if num == 0 {
            throw UserValidationError.noEmailProvided
        }
        return String(num)
    }
    
}


enum UserValidationError: Error {
  case noLastNameProvided
  case noAgeProvided
  case noEmailProvided
}

extension UserValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noAgeProvided:
            return "年齢書いて"
        case .noEmailProvided:
            return "メール書いて"
        case .noLastNameProvided:
            return "名前かいて"
        }
    }
}

enum NumError: Error {
    case minus
    case zero(String)
}

extension FactorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .belowMinimum:
            return "マイナスです"
        case .isPrime:
            return "OK"
        }
    }
}

enum FactorError: Error {
    case belowMinimum(String)
    case isPrime
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



