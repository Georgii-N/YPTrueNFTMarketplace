//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - Private Properties:
    private var url: URL?
    private var progress: Float?
    private var observedProgress: Progress?
    
    // MARK: - UI:
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .whiteDay
        
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.5
        progressView.progressTintColor = .blackDay
        progressView.trackTintColor = .grayUniversal
        
        return progressView
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadWebView()
    }
    
    init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func setProgress() {
        
    }
    
    private func loadWebView() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

// MARK: - Setup Views:
extension WebViewViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        view.setupView(webView)
        view.setupView(progressView)
    }
}

// MARK: - Setup Constraints:
extension WebViewViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // WebView:
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ProgressView:
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
