//
//  ComicsVC.swift
//  MarvelApp
//
//  Created by andrey rulev on 14.02.2022.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ComicsVC: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    
    private let viewModel: ComicsViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showError: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showError(message)
        })
    }
    
    private var insertIndexPath: BindingTarget<IndexPath> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] indexPath in
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        })
    }
    
    private var deleteIndexPath: BindingTarget<IndexPath> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
    }
    
    private var updateIndexPath: BindingTarget<IndexPath> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] indexPath in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
    }
    
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
        bindingViewModel()
        viewModel.loadComics()
    }
}

// MARK: - Configure

private extension ComicsVC {
    func configure() {
        navigationItem.title = "Comics"
        tableView.register(CharacterTableCell.self)
    }
}

// MARK: - BindingViewModel

private extension ComicsVC {
    func bindingViewModel() {
        tableView.reactive.reloadData <~ viewModel.reload
        loaderView.reactive.isAnimating <~ viewModel.loading
        showError <~ viewModel.showError
        insertIndexPath <~ viewModel.insertIndexPath
        deleteIndexPath <~ viewModel.deleteIndexPath
        updateIndexPath <~ viewModel.updateIndexPath
    }
}

// MARK: - UITableViewDataSource

extension ComicsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterTableCell = tableView.dequeueReusableCell(for: indexPath)
        let comics = viewModel.comics(at: indexPath.row)
        cell.configure(comics)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ComicsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private

private extension ComicsVC {
    func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.viewModel.loadComics()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(tryAgainAction)
        present(alertController, animated: true, completion: nil)
    }
}
