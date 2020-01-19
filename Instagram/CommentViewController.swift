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
    
    
    
    
    
    func setViewData(_ postData: PostData){
        

    }
    
    
    
    @IBAction func tapRegButton(_ sender: Any) {
        

        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        self.dismiss(animated: true, completion: nil)

    }
    

    var entryId: String = ""
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /// ローカルストレージ(UserDefaults)から値を取得
        guard let obj = UserDefaults.standard.object(forKey: "entryId") else {
            return
        }
        entryId = obj as? String ?? ""
        //bprint("1111entryId:" + entryId)

        
        
         if listenerPostData == nil {
            // -------------------------------------------------------
            // listener未登録なら、登録してスナップショットを受信する
            // データベースの参照場所と取得順序を指定したクエリを作成
            // postsフォルダに格納されているドキュメントを投稿日時の新しい順に取得する
            // -------------------------------------------------------
            let postsRef = Firestore.firestore().collection(Const.PostPath).limit(to: 100).order(by: "date", descending: true)
            listenerPostData = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                // TableViewの表示を更新する
                //self.tableView.reloadData()
                let arrP = self.postArray.filter { $0.id  == self.entryId }
                let postData: PostData = arrP[0]
                //print(postData.name)
                //        // 画像の表示
                //.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(self.entryId + ".jpg")
                //postImageView.sd_setImage(with: imageRef)
                self.postImageView.sd_setImage(with: imageRef)
                var sDate = ""

                if let date = postData.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    sDate = formatter.string(from: date)
                }
                self.labelPost.text = sDate + "  " + postData.name! + "\n" + postData.caption!
                //print(self.labelPost.text)
                self.labelName.text = postData.name! // + "：" + postData.caption!
                
            }
        }

        
        
    }
    


}
