//
//  CommentData.swift
//  Instagram
//
//  Created by user1 on 2020/01/18.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import Firebase



class CommentData: NSObject {
    var id: String              // 投稿ID（保存する際に作られたユニークなID）
    var name: String?           // 投稿者名
    var comment: String?        // コメント
    var date: Date?             // 日時
    
    
    init(document: QueryDocumentSnapshot) {

        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String
        self.comment = postDic["comment"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
}
