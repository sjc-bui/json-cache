//
//  TransportCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

enum TransportType: Int {
  case tietKiem = 0
  case vnPost   = 1

  var logo: UIImage? {
    switch self {
    case .tietKiem:
      return ImageManager.logoGHTK
    case .vnPost:
      return ImageManager.logoVietNamPost
    }
  }
}

class TransportCell: BaseCollectionViewCell {

  fileprivate var transporterType: TransportType?

  fileprivate lazy var transportTable: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    tableView.layer.cornerRadius  = 6
    tableView.layer.masksToBounds = true
    tableView.layer.borderColor   = UIColor.red.cgColor
    tableView.layer.borderWidth   = 1
    tableView.registerReuseCell(TransporterTableViewCell.self)
    return tableView
  }()

  override func initialize() {
    super.initialize()
    addSubview(transportTable)
    transportTable.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
      make.height.equalTo(150)
    }
  }
}

extension TransportCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    transporterType = TransportType(rawValue: indexPath.row)
    transportTable.reloadData()
  }
}

extension TransportCell: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TransporterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    if let type = TransportType(rawValue: indexPath.row) {
      cell.configCell(type: type)
    }
    cell.isSelected = (transporterType == TransportType(rawValue: indexPath.row))
    return cell
  }
}
