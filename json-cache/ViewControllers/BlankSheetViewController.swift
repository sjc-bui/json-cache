//
//  BlankSheetViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/07/02.
//

import UIKit
import RxSwift

class BlankSheetViewController: UIViewController {
  private var options = [
    ["あ", "い", "う", "え", "お"],
    ["か", "き", "く", "け", "こ"],
    ["さ", "し", "す", "せ", "そ"],
    ["た", "ち", "つ", "て", "と"],
    ["な", "に", "ぬ", "ね", "の"],
    ["は", "ひ", "ふ", "へ", "ほ"],
    ["ま", "み", "む", "め", "も"],
    ["や", "ゆ", "よ"],
    ["ら", "り", "る", "れ", "ろ"],
    ["わ"]
  ]

  private var element: Int = 0
  private var selectedRow: Int = 0

  private lazy var tableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.showsVerticalScrollIndicator = false
    table.dataSource = self
    table.delegate = self
    table.isScrollEnabled = false
    return table
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    layoutTable()
  }

  private func layoutTable() {
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

extension BlankSheetViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "c")
    cell.textLabel?.text = "\(options[indexPath.row][element])"
    cell.textLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "注文履歴"
  }
}

extension BlankSheetViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectedRow != indexPath.row {
      element = 0
      self.tableView.reloadRows(at: [IndexPath(row: selectedRow, section: indexPath.section)], with: .automatic)
      selectedRow = indexPath.row
    }

    let indexCount = options[indexPath.row].count
    if element >= indexCount {
      element = 0
    }

    self.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
    element += 1
    self.tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 54
  }
}
