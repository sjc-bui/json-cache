//
//  SameCollectionViewCell.swift
//  json-cache
//
//  Created by quan bui on 2021/06/27.
//

import UIKit

protocol SameCollectionViewCellDelegate: AnyObject {
  func didTapInCell(index: IndexPath)
}

class SameCollectionViewCell: BaseCollectionViewCell {

  weak var delegate: SameCollectionViewCellDelegate?

  fileprivate lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    let cl = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cl.backgroundColor = .white
    cl.showsHorizontalScrollIndicator = false
    cl.delegate = self
    cl.dataSource = self
    cl.registerReusableCell(ItemCollectionViewCell.self)
    cl.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
    return cl
  }()

  override func initialize() {
    super.initialize()
    layoutCell()
  }

  func layoutCell() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().offset(-8)
    }
  }
}

extension SameCollectionViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 3 * 16) / 3
    return CGSize(width: width, height: 220)
  }
}

extension SameCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.config("\(indexPath.row)")
    cell.backgroundColor = .green
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didTapInCell(index: indexPath)
  }
}
