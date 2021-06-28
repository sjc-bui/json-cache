//
//  ItemDetailViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

class ItemDetailViewController: BaseViewController {

  fileprivate lazy var tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .plain)
    tb.register(UITableViewCell.self, forCellReuseIdentifier: "tb")
    tb.showsVerticalScrollIndicator = false
    tb.separatorStyle  = .none
    tb.backgroundColor = UIColor.white
//    tb.isScrollEnabled = false
    tb.delegate = self
    tb.dataSource = self
    return tb
  }()
  
  private var navTitle: String = ""
  func configTitle(_ title: String) {
    self.navTitle = title
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setLeftBarButton(image: UIImage(named: "dismiss_close"))
    navigationItem.title = navTitle
    layoutTable()

  }

  func layoutTable() {
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  override func touchUpLeftBtn() {
    self.dismiss(animated: true, completion: nil)
  }
}

extension ItemDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension ItemDetailViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tb")
    cell.textLabel?.text = "indexPath \(indexPath.row)"
    cell.detailTextLabel?.text = "Desc"
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor(hex: "#EFEFEF")
    } else {
      cell.backgroundColor = UIColor.white
    }
    cell.selectionStyle = .none
    return cell
  }
}
