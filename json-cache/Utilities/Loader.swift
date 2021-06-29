//
//  Loader.swift
//  json-cache
//
//  Created by quan bui on 2021/06/29.
//

import UIKit

public final class Loader {

  static let shared = Loader()

  fileprivate lazy var overlayView: UIView = {
    let view = UIView(frame: .zero)
    view.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin,
                                    .flexibleRightMargin, .flexibleBottomMargin]
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    return view
  }()

  fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
    let ai = UIActivityIndicatorView()
    ai.color = .gray
    ai.style = .medium
    ai.hidesWhenStopped = true
    return ai
  }()

  fileprivate lazy var bgView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = UIColor.systemGroupedBackground
    view.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,
                             .flexibleBottomMargin,.flexibleHeight, .flexibleWidth]
    view.layer.opacity = 0
    return view
  }()

  public func show(view: UIView) {
    bgView.frame = view.bounds
    bgView.addSubview(overlayView)
    overlayView.snp.makeConstraints { make in
      make.width.height.equalTo(80)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    overlayView.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.width.height.equalTo(40)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    view.addSubview(self.bgView)
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: .curveEaseInOut) {
      self.bgView.layer.opacity = 1
    } completion: { _ in
      self.activityIndicator.startAnimating()
    }
  }

  public func hide() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: .curveEaseInOut) {
      self.bgView.layer.opacity = 0
    } completion: { _ in
      self.activityIndicator.stopAnimating()
      self.bgView.removeFromSuperview()
    }
  }
}
