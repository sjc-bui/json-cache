//
//  DetailTableCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/27.
//

import UIKit

protocol DetailTableCellDelegate: AnyObject {
  func didTapSeemore(detail: String)
}

class DetailTableCell: BaseCollectionViewCell {

  weak var delegate: DetailTableCellDelegate?

  private var detail: String = ""

  fileprivate lazy var tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .plain)
    tb.delegate = self
    tb.dataSource = self
    tb.separatorStyle = .none
    tb.backgroundColor = UIColor.white
    tb.isScrollEnabled = false
    tb.showsVerticalScrollIndicator = false
    tb.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
    return tb
  }()
  
  fileprivate lazy var seemoreButton: UIButton = {
    let button = UIButton()
    button.setTitle("See more", for: .normal)
    button.backgroundColor = UIColor.clear
    button.setTitleColor(.gray, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.addTarget(self, action: #selector(tapSeeMore), for: .touchUpInside)
    return button
  }()
  
  @objc func tapSeeMore() {
    delegate?.didTapSeemore(detail: detail)
  }
  
  override func initialize() {
    super.initialize()
    layoutTableView()
    layoutSeemore()
    detail = "Detail cell"
  }
  
  func layoutTableView() {
    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview().offset(30)
      make.right.equalToSuperview().offset(-30)
      make.height.equalTo(200)
    }
  }
  
  func layoutSeemore() {
    addSubview(seemoreButton)
    seemoreButton.snp.makeConstraints { (make) in
        make.bottom.equalToSuperview()
        make.centerX.equalToSuperview()
        make.height.equalTo(50)
        make.width.equalTo(100)
    }
  }
}

extension DetailTableCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

extension DetailTableCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
    cell.textLabel?.text = "Cell \(indexPath.row)"
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor.lightGray
    } else {
      cell.backgroundColor = UIColor.white
    }
    cell.selectionStyle = .none
    return cell
  }
}
