//
//  DetailViewController.swift
//  BlogReader
//
//  Created by Aliona on 02/09/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    func configureView() {
        if let content = entry?.content,
        let view = webView {
            view.loadHTMLString(content, baseURL: nil)
        }
        if let name = entry?.name {
            title = name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var entry: Entry? {
        didSet {
            configureView()
        }
    }
}

