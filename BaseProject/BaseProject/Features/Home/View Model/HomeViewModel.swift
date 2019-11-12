//
//  HomeViewModel.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 08/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func navigateToDetail()
}

protocol HomeViewModelContract {
    func navigateToDatail()
    func fetch(completion: @escaping (Result<Void, BaseError>) -> Void)
    func cellFor(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    var products: [ProductInformation] { get }
    var numberOfRows: Int { get }
    var stateChange: (()-> Void)? { get set }
    var currentState: ViewState { get }
}

class HomeViewModel: HomeViewModelContract {

    weak var delegate: HomeViewModelDelegate?

    var stateChange: (()-> Void)?

    var currentState: ViewState = .loading {
        didSet {
            stateChange?()
        }
    }

    lazy var products: [ProductInformation] = []

    var numberOfRows: Int {
        if case .loaded = currentState {
            return products.count
        }
        return Int.zero
    }

    func navigateToDatail() {
        delegate?.navigateToDetail()
    }

    func fetch(completion: @escaping (Result<Void, BaseError>) -> Void) {
        currentState = .loading

        HomeService.shared.listProducts { (products, response, error) in

            if let error = error {
                completion(.failure(.generic(error)))
            }

            if let products = products {
                self.currentState = .loaded
                self.products = products
                completion(.success(()))
            }
        }
    }

    func cellFor(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {

        if case .loaded = currentState {
            return tableView.dequeueReusableCell(of: ProductCell.self, for: indexPath) { [weak self] cell in
                guard let self = self else { return }
                cell.configure(with: self.products[indexPath.row])
            }
        }
        return UITableViewCell()
    }

}
