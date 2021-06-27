//
//  DetailViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/27.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

  fileprivate lazy var shop = Shop()

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 5
    layout.minimumInteritemSpacing = 5
    let cl = UICollectionView(frame: .zero,
                              collectionViewLayout: layout)
    cl.backgroundColor = .white
    cl.showsVerticalScrollIndicator = false
    cl.delegate = self
    cl.dataSource = self
    cl.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "c")
    cl.register(DetailTableCell.self, forCellWithReuseIdentifier: "tbc")
    return cl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationItem.title = shop.shopName
    layoutCollectionView()
  }
  
  private func layoutCollectionView() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func config(_ shop: Shop) {
    self.shop = shop
    print("Call here!!!")
  }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 15
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.row {
      case 0:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tbc", for: indexPath) as? DetailTableCell
        cell?.delegate = self
        return cell!
      default:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
  }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.row == 0 {
      return CGSize(width: collectionView.frame.width, height: 250)
    }
    return CGSize(width: collectionView.frame.width, height: 100)
  }
}

extension DetailViewController: DetailTableCellDelegate {
  func didTapSeemore(detail: String) {
    print(detail)
  }
}
