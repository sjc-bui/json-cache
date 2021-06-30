//
//  ViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit
import QBToast

typealias Shops = [Shop]

class ViewController: BaseViewController, URLSessionDelegate {

  var shops: Shops = []
  private var currentTask: URLSessionTask?
  private let cache = Cache<String, Shops>()
  private let name = "fileName2"

  private lazy var tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .plain)
    tb.showsVerticalScrollIndicator = false
    tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tb.delegate = self
    tb.dataSource = self
    tb.separatorStyle = .none
    tb.refreshControl = fresh
    return tb
  }()

  private lazy var fresh: UIRefreshControl = {
    let fr = UIRefreshControl()
    fr.tintColor = .systemRed
    fr.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    return fr
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    layoutTableView()
    setNavButton()
    fetch()
  }

  func layoutTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func setNavButton() {
    let rightBarBtn = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(reloadDt))
    let left = UIBarButtonItem(title: "Numpad", style: .plain, target: self, action: #selector(nump))
    navigationItem.rightBarButtonItem = rightBarBtn
    navigationItem.leftBarButtonItem = left
  }

  @objc func pullToRefresh() {
    fetch()
    fresh.endRefreshing()
  }

  private func fileURL(forFileName name: String) -> URL {
    let folderUrls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    let fileUrl = folderUrls.first!.appendingPathComponent(name).appendingPathExtension("cache")
    return fileUrl
  }

  private func readCache<T: Codable>(key: String, type: T.Type, completion: @escaping (Result<T?, Error>) -> Void) {
    let cacheObj = Cache<String, T>.self
    let fileUrl = fileURL(forFileName: name)
    do {
      let cache = try JSONDecoder().decode(cacheObj, from: try Data(contentsOf: fileUrl))
      if let data = cache.value(forKey: key) {
        completion(.success(data))
      } else {
        throw NSError(domain: "err", code: 101, userInfo: nil)
      }
    } catch let err {
      completion(.failure(err))
    }
  }

  private func fetch() {
    readCache(key: "shopList", type: Shops.self) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        self.shops = data!
        self.tableView.reloadData()
        break
      case .failure(_):
        self.makeReq()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          do {
            try self.cache.saveToDisk(withName: self.name)
            print("Saved cache.")
          } catch let err {
            print(err)
          }
        }
        break
      }
    }
  }

  @objc func reloadDt() {
    let modal = CustomModalViewController()
    modal.modalPresentationStyle = .overCurrentContext
    modal.delegate = self
    self.present(modal, animated: false, completion: nil)
  }
  
  @objc func nump() {
    let numpad = NumPadViewController()
    self.present(numpad, animated: true, completion: nil)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    currentTask?.cancel()
  }

  func makeReq() {
    Loader.shared.show(view: self.view)
    let endPoint = ShopEndPoint.list

    let req = request(endpoint: endPoint)
    netWorkRequest(request: req, type: Shops.self) { [weak self] err, data in
      guard let self = self,
            err == nil,
            let dt = data else {
        Loader.shared.hide()
        return
      }

      self.shops = dt
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.cache.insert(self.shops, forKey: "shopList")
        Loader.shared.hide()
      }
    }
  }

  private func request(endpoint: ShopEndPoint) -> URLRequest? {
    let user = "admin"
    let pass = "hirono123"

    var request = URLRequest(url: endpoint.baseURL)
    request.httpMethod = endpoint.httpMethod.rawValue
    guard let cridentialData = "\(user):\(pass)".data(using: String.Encoding.utf8) else { return nil }
    let cridential = cridentialData.base64EncodedString(options: [])
    let basicData = "Basic \(cridential)"
    request.setValue(basicData, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }

  fileprivate func netWorkRequest<T>(request: URLRequest?, type: T.Type, completion: @escaping ((_ error: APIError?, _ obj: T?) -> Void)) where T: Decodable {
    guard let request = request else { return }

    let config: URLSessionConfiguration = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10
    config.timeoutIntervalForResource = 50
    let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)

    currentTask = session.dataTask(with: request) { data, response, error in
      guard let res = response as? HTTPURLResponse else {
        completion(.requestFailed(description: error?.localizedDescription ?? "No description"), nil)
        return
      }

      guard res.statusCode == 200 else {
        completion(.responseUnsuccessful(description: "\(res.statusCode)"), nil)
        return
      }

      guard let data = data else {
        completion(.invalidData, nil)
        return
      }

      do {
        let result = try JSONDecoder().decode(T.self, from: data)
        completion(nil, result)
      } catch let err {
        completion(.jsonConversionFailure(description: "\(err.localizedDescription)"), nil)
      }
    }
    currentTask?.resume()
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shops.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    let shop = shops[indexPath.row]
    cell.textLabel?.text = "\(shop.shopName) \(shop.shopPhone)"
    cell.detailTextLabel?.text = "\(shop.shopPostalCode) \(shop.shopAddress)"
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor(hex: "#EFEFEF")
    } else {
      cell.backgroundColor = .white
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = shops[safe: indexPath.row] else { return }
    let detail = DetailViewController()
    detail.config(item)
    self.navigationController?.pushViewController(detail, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
//    NotificationCenter.default.post(name: NSNotification.Name.example, object: nil)
  }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    if index < count && index >= 0 {
      return self[index]
    } else {
      return nil
    }
  }
}

extension UIWindow {
  static var key: UIWindow? {
    if #available(iOS 13, *) {
      return UIApplication.shared.windows.first { $0.isKeyWindow }
    } else {
      return UIApplication.shared.keyWindow
    }
  }
}

extension ViewController: CustomModalViewDelegate {
  func selectedAt(index: Int) {
    print("Select from bottom modal at index = \(index).")
  }
}
