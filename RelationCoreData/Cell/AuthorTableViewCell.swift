//
//  AuthorTableViewCell.swift
//  RelationCoreData
//
//  Created by Diffa Desyawan on 16/06/21.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameAuthorLabel: UILabel!
    @IBOutlet weak var hobbyAuthorLabel: UILabel!
    
    func setDataIntoCell(author: Author){
        nameAuthorLabel.text = author.name
        hobbyAuthorLabel.text = author.hobby
    }
}
