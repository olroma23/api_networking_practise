//
//  CourseWebViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 29.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import WebKit

class CourseWebViewController: UIViewController {
    
    var url: URL?
    var courseName: String?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = courseName
        let request = URLRequest(url: url!)
        webView.load(request)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
