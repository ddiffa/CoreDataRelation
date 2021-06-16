//
//  BookTableViewCell.swift
//  RelationCoreData
//
//  Created by Diffa Desyawan on 16/06/21.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDescLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    func setDataIntoCell(book: Book){
        print("set data : \(book)")
        bookTitleLabel.text = book.title
        bookDescLabel.text = book.desc
        authorNameLabel.text = book.author?.name
        thumbnailImage.image = UIImage(data: book.image!)
    }
}
