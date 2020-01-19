//
//  HomeViewController.swift
//  Instagram
//
//  Created by user1 on 2020/01/12.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import Firebase // Firestoreにアクセスできるようにする。
import SVProgressHUD


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    // 投稿データを格納する配列
    var commentArray: [CommentData] = []

    // Firestoreのリスナー　データ更新の監視を行う
    var listenerPostData: ListenerRegistration!
    var listenerCommentData: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    // -----------------------------------------------------
    // ホーム画面を再表示するたびに何度も呼ばれる
    // -----------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")

        
        // 現在のログイン状態を確認
        if Auth.auth().currentUser != nil {
            
            // ---------------------------------------------------
            // ログイン済み→はデータの読み込み(監視)を開始
            // ---------------------------------------------------
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
                    self.tableView.reloadData()
                }
            }
            // コメント　max1000
            if listenerCommentData == nil {
                var defaultStore : Firestore!

                defaultStore = Firestore.firestore()
                let refComments = defaultStore.collection(Const.CommentPostPath).order(by: "date", descending: true).limit(to: 1000)
                listenerCommentData = refComments.addSnapshotListener() { (querySnapshot, error) in
                   if let error = error {
                       print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                       return
                   }
                   // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                    self.commentArray = querySnapshot!.documents.map { document in
                       print("DEBUG_PRINT: comment取得 \(document.documentID)")
                       let commentData = CommentData(document: document)
                       return commentData
                   }
                    // TableViewの表示を更新する
                   self.tableView.reloadData()
               }

            }
        } else {
            // ---------------------------------------------------
            // ログイン未(またはログアウト済み)→データの読み込み(監視)を停止して、表示データをクリア
            // ---------------------------------------------------
            if listenerPostData != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listenerPostData.remove()
                listenerPostData = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        let postData = postArray[indexPath.row]
//        cell.setPostData(postArray[indexPath.row])
        cell.setPostData(postData)

        // セル内のボタンのアクションをソースコードで設定する
        // ※青い線を引っ張ってActionを設定する代わり
        cell.likeButton.addTarget(self, action:#selector(handleLikeButton(_:forEvent:)), for: .touchUpInside)

        cell.cmtButton.addTarget(self, action:#selector(handleCmtButton), for: .touchUpInside)
 
        return cell
    }

    // セル内のボタンがタップされた時に呼ばれるメソッド
    // 第一引数にはタップされたUIButtonのインスタンスが格納され、第二引数にはUIEvent型のタップイベントが格納されます。
    // タップイベントの中には、ボタンをタップした時の画面上の座標位置などが格納されています。
    // selector指定で呼び出されるメソッドは、先頭に @objcを付与してメソッドを宣言します。
    @objc func handleLikeButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            // Firestoreのlikes配列を更新すると、 addSnapshotListenerで監視しているリスナーが投稿データの更新を検出してクロージャを呼び出すため、テーブル表示は自動的に最新の状態に更新される。
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    // コメントボタンタップ
    @objc func handleCmtButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        let commentPostRef = Firestore.firestore().collection(Const.CommentPostPath).document()

        print("DEBUG_PRINT: Cmtボタンがタップされました。")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        let entryId = postData.id

        // likesを更新する
        let name = Auth.auth().currentUser?.displayName
            
        let commentRegDic = [
            "entryId": entryId,
            "name": name!,
            "comment": "コメント" + postData.caption!,

            "date": FieldValue.serverTimestamp(),
            ] as [String : Any]
        
        commentPostRef.setData(commentRegDic)
        
        SVProgressHUD.showSuccess(withStatus: "Cmtボタンがタップされ、投稿されました:" + postData.id)

        
        
        
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました:" + entryId )
        
        
        
        
    }
}
