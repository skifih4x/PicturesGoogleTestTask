//
//  WebViewController.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 08.02.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKUIDelegate {
    
    // MARK: UI Element
    
    @IBOutlet var detailSiteWebKit: WKWebView?
    
    var referenceSite: String?
    var nameReference: String?
    
    // MARK: Methods Life Cicle
    
    override func loadView() {
        loadWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        loadSite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = nameReference
    }
    
    // MARK: Private Method
    
    private func loadWebView() {
        let webConfig = WKWebViewConfiguration()
        detailSiteWebKit = WKWebView(frame: .zero, configuration: webConfig)
        detailSiteWebKit?.uiDelegate = self
        view = detailSiteWebKit
    }
    
    private func setNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(tapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(tapRefresh))
    }
    
    private func loadSite() {
        guard let myUrl = URL(string:  self.referenceSite ?? "") else { return}
        let req = URLRequest(url: myUrl)
        detailSiteWebKit?.load(req)
    }
    
    @objc private func tapDone() {
        dismiss(animated: true)
    }
    
    @objc private func tapRefresh() {
        guard let myUrl = URL(string:  self.referenceSite ?? "") else { return }
        let req = URLRequest(url: myUrl)
        self.detailSiteWebKit?.load(req)
    }
}
