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
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    let cl = UICollectionView(frame: .zero,
                              collectionViewLayout: layout)
    cl.backgroundColor = .white
    cl.showsVerticalScrollIndicator = false
    cl.delegate = self
    cl.dataSource = self
    cl.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "c")
    cl.register(DetailTableCell.self, forCellWithReuseIdentifier: "tbc")
    cl.register(SameCollectionViewCell.self, forCellWithReuseIdentifier: "sameCell")
    cl.register(TransportCell.self, forCellWithReuseIdentifier: "tr")
    cl.registerReusableCell(RadioCollectionViewCell.self)
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
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.row {
    case 0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tbc", for: indexPath) as? DetailTableCell
      cell?.delegate = self
      return cell!
    case 1:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sameCell", for: indexPath) as? SameCollectionViewCell
      cell?.delegate = self
      return cell!
    case 2:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tr", for: indexPath) as? TransportCell
      return cell!
    case 3:
      let cell: RadioCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
      cell.delegate = self
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath)
      cell.backgroundColor = .red
      return cell
    }
  }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return CGSize(width: collectionView.frame.width, height: 250)
    case 1:
      return CGSize(width: collectionView.frame.width, height: 230)
    case 2:
      return CGSize(width: collectionView.frame.width, height: 230)
    case 3:
      return CGSize(width: collectionView.frame.width, height: 70)
    default:
      return CGSize(width: collectionView.frame.width, height: 80)
    }
  }
}

extension DetailViewController: DetailTableCellDelegate {
  func didTapSeemore(detail: String) {
    print(detail)
  }
}

extension DetailViewController: SameCollectionViewCellDelegate {
  func didTapInCell(index: IndexPath) {
    let vc = ItemDetailViewController()
    vc.configTitle("\(index)")
    let nvc = UINavigationController(rootViewController: vc)
    self.present(nvc, animated: true, completion: nil)
  }
}

extension DetailViewController: RadioCollectionViewCellDelegate {
  func didSelected(index: Int) {
    print("Selected at \(index)")
  }
}
