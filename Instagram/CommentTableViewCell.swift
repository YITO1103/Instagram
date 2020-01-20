//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by user1 on 2020/01/19.
//  Copyright © 2020 yutaka.ito4. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // CommentDataの内容をセルに表示
    func setCommentData(_ commentData:CommentData) {
        // 日時の表示
        self.labelDate.text = ""
        if let date = commentData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: date)
            self.labelDate.text = dateString
        }
        //
        labelName.text = commentData.name
        //
        labelComment.text = commentData.comment
        
    }
}
