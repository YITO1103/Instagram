//
//  PostViewController.swift
//  Instagram
//
//  Created by user1 on 2020/01/12.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func handlePostButton(_ sender: Any) {
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 受け取った画像をImageViewに設定する
        imageView.image = image
    }

}
