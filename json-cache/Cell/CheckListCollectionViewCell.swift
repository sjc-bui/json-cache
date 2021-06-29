//
//  CheckListCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/29.
//

import UIKit

class CheckListCollectionViewCell: BaseCollectionViewCell {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Please select bellow options."
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .gray
    return label
  }()

  fileprivate lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.headerReferenceSize = CGSize(width: self.frame.width, height: 20)
    layout.footerReferenceSize = CGSize(width: self.frame.width, height: 24)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.clear
    collectionView.isScrollEnabled = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerReusableCell(CheckBoxCollectionViewCell.self)
//    collectionView.registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
//    collectionView.registerReusableSupplementaryView(BaseCollectionViewHeaderFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    return collectionView
  }()

  fileprivate let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()

  fileprivate lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18,
                                                weight: .bold)
    button.backgroundColor = .lightGray
    button.layer.borderColor = UIColor.separator.cgColor
    button.layer.borderWidth = 1.0
    button.layer.cornerRadius = 5
    return button
  }()

  fileprivate lazy var confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("Confirm", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18,
                                                weight: .bold)
    button.backgroundColor = .systemRed
    button.layer.cornerRadius = 5
    return button
  }()
  
  private let viewModel = CheckBoxViewModel()

  override func initialize() {
    super.initialize()
    layoutTitle()
    layoutCollectionView()
    layoutLineView()
  }

  func layoutTitle() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
    }
  }

  func layoutCollectionView() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-16)
      make.left.equalToSuperview().offset(16)
      make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
      make.height.equalTo(200)
    }
  }

  func layoutLineView() {
    addSubview(lineView)
    lineView.snp.makeConstraints { make in
      make.width.centerX.equalToSuperview()
      make.height.equalTo(1)
      make.top.equalTo(collectionView.snp.bottom)
    }
  }
}

extension CheckListCollectionViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (collectionView.frame.width - 3) / 2, height: 50)
  }
}

extension CheckListCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CheckBoxCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    let isSelected = self.viewModel.isSelected(index: indexPath.row)
    cell.configureData(with: "選択オプション\(indexPath.row)", isSelected)
    return cell
  }
}

extension CheckListCollectionViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.viewModel.didSelectedAt(index: indexPath.row)
    self.collectionView.reloadData()
    print(self.viewModel.selectedIndex)
  }
}

class CheckBoxViewModel: NSObject {

  // MARK: - Variables

  private (set) var selectedIndex: [Int] = [] // getter is public, but setter is private (inaccessible)

  // MARK: - Public methods

  func didSelectedAt(index: Int) {
    if self.selectedIndex.contains(index) {
      if let i = selectedIndex.firstIndex(of: index),
         !selectedIndex.isEmpty {
        self.selectedIndex.remove(at: i)
      }
    } else {
      selectedIndex.append(index)
    }
  }

  func isSelected(index: Int) -> Bool {
    return self.selectedIndex.contains(index)
  }
}
