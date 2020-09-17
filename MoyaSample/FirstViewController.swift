//
//  FirstViewController.swift
//  MoyaSample
//
//  Created by burita083 on 2020/09/17.
//  Copyright © 2020 burita083. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    let data = ["ピカチュウ", "コラッタ", "イーブイ", "カビゴン", "ポッポ"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }
}

extension FirstViewController: Instantiatable {}


// データ・ソース
extension FirstViewController: UITableViewDataSource {

    // セクションごとにデータ要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
        // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // セル生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        //cell.textLabel?.text = data[indexPath.row]
        //cell.accessoryType = .disclosureIndicator
        //cell.accessoryView = UISwitch() // スィッチ

        return cell
    }
}

// セルタップ時の動作定義など
extension FirstViewController: UITableViewDelegate {
    // セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)

         alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
            let testVC = TestViewController.instantiateFromStoryboard(withIdentifier: "TestViewController")
            testVC.modalPresentationStyle = .automatic
            self.isModalInPresentation = false
            testVC.isModalInPresentation = false
            self.present(UINavigationController(rootViewController: testVC), animated: true, completion: nil)
             print("User click Approve button")
         }))

         alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
             print("User click Edit button")
         }))

         alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
             print("User click Delete button")
         }))

         alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
             print("User click Dismiss button")
         }))

         self.present(alert, animated: true, completion: {
             print("completion block")
         })
    }
}
