//
//  ComicsVC.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import UIKit

class ComicsVC: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    
    private let viewModel: ComicsViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: ComicsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Configure

private extension ComicsVC {
    func configure() {
        navigationItem.title = "Comics"
        tableView.register(CharacterTableCell.self)
    }
}

// MARK: - UITableViewDataSource

extension ComicsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterTableCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ComicsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
