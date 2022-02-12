//
//  CharacterVC.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import UIKit

class CharacterVC: UIViewController {
    
    // MARK: - Private properties
    
    let viewModel: CharacterViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
