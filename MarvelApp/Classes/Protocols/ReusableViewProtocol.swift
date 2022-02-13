//
//  ReusableViewProtocol.swift
//  MarvelApp
//
//  Created by andrey rulev on 13.02.2022.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableViewProtocol where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
