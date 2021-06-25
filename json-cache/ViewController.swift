//
//  ViewController.swift
//  json-cache
//
//  Created by quan bui on 2021/06/25.
//

import UIKit
import QBToast

typealias Shops = [Shop]

class ViewController: UITableViewController, URLSessionDelegate {

  var shops: Shops = []
  private var currentTask: URLSessionTask?
  private let cache = Cache<String, Shops>()
  private let name = "fileName2"
  private let fresh = UIRefreshControl()

  override init(style: UITableView.Style) {
    super.init(style: style)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    fresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    tableView.refreshControl = fresh

    setNavButton()
    fetch()
  }

  func setNavButton() {
    let rightBarBtn = UIBarButtonItem(title: "Save cache", style: .plain, target: self, action: #selector(reloadDt))
    navigationItem.rightBarButtonItem = rightBarBtn
  }

  @objc func pullToRefresh() {
    fetch()
    fresh.endRefreshing()
  }

  private func fetch() {
    let folderUrls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    print(folderUrls)
    let fileUrl = folderUrls[0].appendingPathComponent(name).appendingPathExtension("cache")
    do {
      let cache = try JSONDecoder().decode(Cache<String, Shops>.self, from: try Data(contentsOf: fileUrl))
      if let data = cache.value(forKey: "shopList") {
        shops = data
        tableView.reloadData()
        QBToast(message: "Data from cache.", duration: 2.5, state: .info).showToast()
      } else {
        makeReq()
        QBToast(message: "Internet request", duration: 2.5, state: .success).showToast()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          do {
            try self.cache.saveToDisk(withName: self.name)
            print("Saved cache.")
          } catch let err {
            print(err)
          }
        }
      }
    } catch let err {
      print(err)
    }
  }

  @objc func reloadDt() {
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    currentTask?.cancel()
  }

  func makeReq() {
    let endPoint = ShopEndPoint.list

    let req = request(endpoint: endPoint)
    netWorkRequest(request: req, type: Shops.self) { [weak self] err, data in
      guard let self = self,
            err == nil,
            data != nil else { return }
      self.shops = data!
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.cache.insert(self.shops, forKey: "shopList")
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

extension ViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shops.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
    let shop = shops[indexPath.row]
    cell.textLabel?.text = "\(shop.shopName) \(shop.shopPhone)"
    cell.detailTextLabel?.text = "\(shop.shopPostalCode) \(shop.shopAddress)"
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
