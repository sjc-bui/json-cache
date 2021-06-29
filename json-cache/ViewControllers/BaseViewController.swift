//
//  BaseViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

enum BarButtonPosition {
  case left
  case right
}

typealias Target = (target: Any?, selector: Selector)
struct BarButtonModel {
  var image: UIImage?
  var title: String?
  var target: Target

  init(image: UIImage?, target: Target) {
    self.image  = image
    self.target = target
  }

  init(image: UIImage?, title: String?, target: Target) {
    self.image  = image
    self.title  = title
    self.target = target
  }
}

class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    handleNotificationExample()
  }

  func setLeftBarButton(image: UIImage? = nil) {
    if image != nil {
      let btnTarget: Target = (target: self, selector: #selector(touchUpLeftBtn))
      let leftButton = BarButtonModel(image: image, target: btnTarget)
      addBarItems(with: [leftButton], position: .left)
    }
  }

  func addBarItems(with items: [BarButtonModel], position: BarButtonPosition = .right) {
    var barButtonItems: [UIBarButtonItem] = []
    items.forEach {
      barButtonItems.append(buildBarButton(from: $0))
    }
    switch position {
      case .left:
        navigationItem.leftBarButtonItems  = barButtonItems
      case .right:
        navigationItem.rightBarButtonItems = barButtonItems
    }
  }

  func buildBarButton(from itemModel: BarButtonModel) -> UIBarButtonItem {
      let target = itemModel.target
      let customButton = UIButton(type: .custom)
      customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      if itemModel.image != nil {
          let image = itemModel.image?.withRenderingMode(.alwaysTemplate)
          customButton.setImage(image, for: .normal)
          customButton.tintColor = UIColor.white
      } else if itemModel.title != nil {
          customButton.setTitle(itemModel.title!, for: .normal)
          customButton.setTitleColor(UIColor.white, for: .normal)
      }
      
      customButton.addTarget(target.target, action: target.selector, for: .touchUpInside)
      return UIBarButtonItem(customView: customButton)
  }
  
  @objc func touchUpLeftBtn() { }

  func handleNotificationExample() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleNotification),
                                           name: NSNotification.Name.example,
                                           object: nil)
  }

  @objc func handleNotification() {
    print("Do something !!!")
  }

  deinit {
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name.example,
                                              object: nil)
  }
}
