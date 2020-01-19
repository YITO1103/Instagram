//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by user1 on 2020/01/16.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit
import FirebaseUI





class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var cmtButton: UIButton!
    
    @IBOutlet weak var cmtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData, _ arrComments: [CommentData] ) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        // コメントの表示
        var sComment = ""

        if arrComments.count > 0 {
            sComment = "\(arrComments.count)件のコメント"
            
            let cmtData = arrComments[0]
    
            var sName = ""
            var sCmt = ""
            var sDate = ""
            
            if (postData.name != nil)  {
                sName = cmtData.name!
            }
            if let date = cmtData.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                sDate = formatter.string(from: date)
            }
            if (cmtData.comment != nil)  {
                sCmt = cmtData.comment!
            }

            sComment += "\n\(sDate) \(sName)さん \(sCmt)"



            if sName.count > 1 {
                sComment += " など…"
            }

            self.cmtLabel.text = sComment
            
            /*
            self.cmtLabel.text = "コメント：" + arrComments.count.description
            for i in 0..<arrComments.count - 1 {
                let cmtData = arrComments[i]
                var str1 = ""
                var str2 = ""
                if (postData.name != nil)  {
                    str1 = cmtData.name!
                    
                }
                if (cmtData.comment != nil)  {
                    str2 = cmtData.comment!
                }
                if let date = cmtData.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy/MM/dd HH:mm:ss"
                    let dateString = formatter.string(from: date)
                    str2 = dateString + str2
                }
                let sWork  = "\(str1) : \(str2)"
                if sComment.count > 0 {
                    sComment += "\n"
                }
                sComment += sWork
                
            }
            self.cmtLabel.text = sComment
 */
        }

        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }    
}
