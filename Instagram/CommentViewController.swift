//
//  CommentViewController.swift
//  Instagram
//
//  Created by user1 on 2020/01/19.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import Firebase // Firestoreにアクセスできるようにする。
import SVProgressHUD




class CommentViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textGieldComment: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var labelPost: UILabel!
    
    var postData: PostData!
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // 投稿データを格納する配列
    var commentArray: [CommentData] = []
    
    


    // Firestoreのリスナー　データ更新の監視を行う
    var listenerPostData: ListenerRegistration!
    var listenerCommentData: ListenerRegistration!
    

    
    
    @IBAction func tapRegButton(_ sender: Any) {
        

        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        self.dismiss(animated: true, completion: nil)

    }
    

    var entryId: String = ""
    // キャンセル
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        entryId = postData.id
        // 画像の表示
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.entryId + ".jpg")
        self.postImageView.sd_setImage(with: imageRef)
        
        // 初期表示
        var sDate = ""

        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            sDate = formatter.string(from: date)
        }
        self.labelPost.text = sDate + "  " + postData.name! + "\n" + postData.caption!
        self.labelName.text = "コメント投稿者名：" + postData.name!
    }
}
