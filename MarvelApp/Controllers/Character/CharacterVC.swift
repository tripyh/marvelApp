//
//  CharacterVC.swift
//  MarvelApp
//
//  Created by andrey rulev on 12.02.2022.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class CharacterVC: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    @IBOutlet private var searchBar: UISearchBar!
    
    private let viewModel: CharacterViewModel
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
    
    init(viewModel: CharacterViewModel) {
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
        viewModel.loadCharacters()
    }
}

// MARK: - BindingViewModel

private extension CharacterVC {
    func bindingViewModel() {
        tableView.reactive.reloadData <~ viewModel.reload
        loaderView.reactive.isAnimating <~ viewModel.loading
        showError <~ viewModel.showError
        insertIndexPath <~ viewModel.insertIndexPath
        deleteIndexPath <~ viewModel.deleteIndexPath
        updateIndexPath <~ viewModel.updateIndexPath
    }
}

// MARK: - Configure

private extension CharacterVC {
    func configure() {
        navigationItem.title = "Characters"
        tableView.register(CharacterTableCell.self)
    }
}

// MARK: - UITableViewDataSource

extension CharacterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterTableCell = tableView.dequeueReusableCell(for: indexPath)
        let character = viewModel.character(at: indexPath.row)
        cell.configure(character)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharacterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let character = viewModel.character(at: indexPath.row) {
            pushToComicsCharacterId(character.id)
        }
    }
}

// MARK: - UISearchBarDelegate

extension CharacterVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: - Navigation

private extension CharacterVC {
    func pushToComicsCharacterId(_ characterId: Int64) {
        view.endEditing(true)
        
        let comicsViewModel = ComicsViewModel(characterId: characterId)
        let comicsController = ComicsVC(viewModel: comicsViewModel)
        navigationController?.pushViewController(comicsController, animated: true)
    }
}

// MARK: - Private

private extension CharacterVC {
    func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.viewModel.loadCharacters()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(tryAgainAction)
        present(alertController, animated: true, completion: nil)
    }
}
