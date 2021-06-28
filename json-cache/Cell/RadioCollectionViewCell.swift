//
//  RadioCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/28.
//

import UIKit

protocol RadioCollectionViewCellDelegate: AnyObject {
  func didSelected(index: Int)
}

class RadioCollectionViewCell: BaseCollectionViewCell {

  weak var delegate: RadioCollectionViewCellDelegate?

  private var defaultSelected = 0

  fileprivate lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cl.backgroundColor = .white
    cl.showsHorizontalScrollIndicator = false
    cl.delegate = self
    cl.dataSource = self
    cl.registerReusableCell(RadioButtonViewCell.self)
    cl.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    return cl
  }()
  
  override func initialize() {
    super.initialize()
    layoutCollection()
  }

  func layoutCollection() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-8)
    }
  }
}

extension RadioCollectionViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 3 * 10) / 3
    return CGSize(width: width, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    defaultSelected = indexPath.row
    delegate?.didSelected(index: indexPath.row)
    collectionView.reloadData()
  }
}

extension RadioCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: RadioButtonViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.config("\(indexPath.row)")
    cell.isSelected = (defaultSelected == indexPath.row)
    return cell
  }
}
