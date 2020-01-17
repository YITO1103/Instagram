//
//  PostData.swift
//  Instagram
//
//  Created by user1 on 2020/01/16.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String              // 投稿ID（保存する際に作られたユニークなID）
    var name: String?           // 投稿者名
    var caption: String?        // キャプション
    var date: Date?             // 日時
    var likes: [String] = []    // いいねした人のIDの配列
    var isLiked: Bool = false   // 自分がいいねしたかどうかのフラグ

    init(document: QueryDocumentSnapshot) {
        
        //
        self.id = document.documentID
        let postDic = document.data()
    
        //
        self.name = postDic["name"] as? String
        //
        self.caption = postDic["caption"] as? String
        //
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        //
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        //
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
    }
}
