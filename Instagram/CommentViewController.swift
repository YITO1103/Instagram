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




//class CommentViewController: UIViewController {
class CommentViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var labelPost: UILabel!
    
    var postData: PostData!
    // コメントデータを格納する配列
    var commentArray: [CommentData] = []
        
    @IBOutlet weak var tableView: UITableView!
    // コメントを投稿
    @IBAction func tapRegButton(_ sender: Any) {
        let sCmt = textFieldComment.text!
        if sCmt.count < 0 {
            SVProgressHUD.showError(withStatus: "コメントを入力してください。")
            return
        }
        let commentRef = Firestore.firestore().collection(Const.CommentPostPath).document()
        ///print(textFieldComment.text)
        //let name = Auth.auth().currentUser?.displayName
        let commentDic = [
            "entryId": postData.id,
            "name": postData.name!,
            "comment": textFieldComment.text!,
            "date": FieldValue.serverTimestamp(),
            ] as [String : Any]
        
        commentRef.setData(commentDic)
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        self.dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        labelName.text = textFieldComment.text
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        let sbk = labelName.text
        labelName.text = textFieldComment.text
        labelName.text = sbk
        return true
    }
    var entryId: String = ""
    // キャンセル
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textFieldComment.delegate = self
        
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        entryId = postData.id
        // 画像の表示
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(entryId + ".jpg")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.setCommentData(commentArray[indexPath.row])
        return cell
    }
}
