//
//  ViewController.swift
//  TestProj
//
//  Created by Aleksandr on 09.10.2018.
//  Copyright © 2018 qqq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet fileprivate weak var avatarImageView: UIImageView!
  @IBOutlet fileprivate weak var sizeLabel: UILabel!
  @IBOutlet fileprivate weak var loginLabel: UILabel!
  @IBOutlet fileprivate weak var fullNameLabel: UILabel!
  @IBOutlet fileprivate weak var descriptionLabel: UILabel!
  @IBOutlet fileprivate weak var avatarWidthConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var randomBtn: UIButton!
  
  var interactor: MainInteractorType!
  var adapter: MainAdapterType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupAdapterCallbacks()
    load(page: 0)
  }
  
  @IBAction func randomBtnClicked(_ sender: UIButton) {
    updateUI()
  }
  
  fileprivate func load(page: Int) {
    interactor.loadGitHubRepos(page: page, withCache: false, success: { [weak self] (result) in
      self?.adapter.setModel(result)
      self?.randomBtn.isEnabled = true
      if page == 0 {
        self?.updateUI()
      }
      }, failure: { error in
        
    })
  }
  
  fileprivate func setupAdapterCallbacks() {
    adapter.onLoadMore = { [weak self] page in
      self?.load(page: page)
    }
    
    adapter.onDisableRandomBtn = { [weak self] in
      self?.randomBtn.isEnabled = false
    }
  }
  
  fileprivate func updateUI() {
    guard let repository = adapter.randomRepository else { return }
    avatarImageView.load(repository.avatarURL, defaultImage: nil)
    sizeLabel.text = repository.size
    loginLabel.text = repository.login
    fullNameLabel.text = repository.fullName
    descriptionLabel.text = repository.description
    avatarWidthConstraint.constant = CGFloat(repository.imageProportionsize)
  }
}

