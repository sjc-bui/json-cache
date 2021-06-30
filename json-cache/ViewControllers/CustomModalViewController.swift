//
//  CustomModalViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/29.
//

import UIKit

protocol CustomModalViewDelegate: AnyObject {
  func selectedAt(index: Int)
}

class CustomModalViewController: UIViewController {

  weak var delegate: CustomModalViewDelegate?
  private var selected = 0

  private let defaultHeight: CGFloat = 300
  private let dismissHeight: CGFloat = 200
  private let maxHeight: CGFloat = UIScreen.main.bounds.height - 64
  private var currentHeight: CGFloat = 300
  let maxDimmedAlpha: CGFloat = 0.6

  fileprivate lazy var containerView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.layer.cornerRadius = 16
      view.clipsToBounds = true
      return view
  }()

  fileprivate lazy var dimmedView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      view.alpha = 0
      return view
  }()

  fileprivate lazy var tableView: UITableView = {
    let table = UITableView()
    table.showsVerticalScrollIndicator = false
    table.registerReuseCell(ModalViewCell.self)
    table.separatorStyle = .none
    table.delegate = self
    table.dataSource = self
    return table
  }()

  fileprivate lazy var lineView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()

  var containerViewHeightConstraint: NSLayoutConstraint?
  var containerViewBottomConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    panGesture()
  }

  func animateShowDimmedView() {
    UIView.animate(withDuration: 0.3) {
        self.dimmedView.alpha = self.maxDimmedAlpha
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateShowDimmedView()
    animatePresent()
  }

  func setupView() {
    view.backgroundColor = .clear
  }

  func panGesture() {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureModal(sender:)))
    gesture.delaysTouchesBegan = false
    gesture.delaysTouchesEnded = false
    view.addGestureRecognizer(gesture)
  }

  @objc func panGestureModal(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    let newHeight = currentHeight - translation.y
    let draggingDown = translation.y > 0

    switch sender.state {
      case .changed:
        if newHeight < maxHeight {
          self.containerViewHeightConstraint?.constant = newHeight
          self.view.layoutIfNeeded()
        }
      case .ended:
        if newHeight < dismissHeight {
          self.animateDismiss()
        } else if newHeight < defaultHeight {
          self.updateHeight(height: defaultHeight)
        } else if newHeight < maxHeight && draggingDown {
          self.updateHeight(height: defaultHeight)
        } else if newHeight > defaultHeight && !draggingDown {
          self.updateHeight(height: maxHeight)
        }
      default:
        break
    }
  }

  func updateHeight(height: CGFloat) {
    UIView.animate(withDuration: 0.34,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.6,
                   options: .curveEaseInOut) {
      self.containerViewHeightConstraint?.constant = height
      self.view.layoutIfNeeded()
    }
    currentHeight = height
  }

  func setupConstraints() {
    view.addSubview(dimmedView)
    dimmedView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateDismiss)))

    view.addSubview(containerView)
    containerView.addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.height.equalTo(0.5)
      make.width.equalToSuperview()
      make.top.equalToSuperview().offset(50)
    }

    containerView.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(lineView.snp.bottom)
    }

    containerView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }

  func animatePresent() {
    UIView.animate(withDuration: 0.34,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.6,
                   options: .curveEaseInOut) {
      self.containerViewBottomConstraint?.constant = 0
      self.view.layoutIfNeeded()
    }
  }

  @objc func animateDismiss() {
    UIView.animate(withDuration: 0.36,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseInOut) {
      self.containerViewBottomConstraint?.constant = self.currentHeight
      self.view.layoutIfNeeded()
    }

    UIView.animate(withDuration: 0.36) {
        self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
}

extension CustomModalViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.selectedAt(index: indexPath.row)
    self.selected = indexPath.row
    tableView.reloadData()
  }
}

extension CustomModalViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ModalViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.config(title: "テキスト: \(indexPath.row)", status: "none")
    cell.isSelected = (self.selected == indexPath.row)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
