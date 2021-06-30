//
//  NumPadViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/30.
//

import UIKit

class NumPadViewController: UIViewController {

  fileprivate lazy var containerView: UIView = {
      let view = UIView()
      view.backgroundColor = .systemGroupedBackground
      view.layer.cornerRadius = 4
      view.clipsToBounds = true
      return view
  }()

  lazy var numpad: Numpad = {
    let pad = DefaulNumpad()
    return pad
  }()

  private let defaultHeight: CGFloat = 250
  var containerViewHeightConstraint: NSLayoutConstraint?
  var containerViewBottomConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
    layoutNumpad()
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDismiss)))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    numpad.invalidateLayout()
  }

  @objc func tapDismiss() {
    self.dismiss(animated: true, completion: nil)
  }

  func layoutNumpad() {

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.autoresizingMask = [.flexibleRightMargin,
                                      .flexibleLeftMargin,
                                      .flexibleBottomMargin,
                                      .flexibleTopMargin]

    self.view.addSubview(containerView)
    containerView.addSubview(numpad)
    numpad.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }
}
