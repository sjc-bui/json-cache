//
//  BlankSheetViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/07/02.
//

import UIKit
import RxSwift

class BlankSheetViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    example()
  }

  private func example() {
    let obj = Observable.from(["dog", "monkey", "cat", "shark"])
    obj.subscribe(onNext: { data in
      print(data)
    }, onError: { error in
      print(error)
    }, onCompleted: {
      print("Completed")
    }).dispose()
  }
}
