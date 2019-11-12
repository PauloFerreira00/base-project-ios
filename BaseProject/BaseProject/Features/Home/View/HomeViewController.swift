//
//  HomeViewController.swift
//  BaseProject
//
//  Created by Paulo Ferreira de Jesus - PFR on 07/11/19.
//  Copyright © 2019 Iteris Consultoria. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, Identifiable {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var viewModel: HomeViewModelContract?

    static func instantiate(with viewModel: HomeViewModelContract) -> HomeViewController {
        let viewController: HomeViewController = UINib.instantiateViewController(from: .home)
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        fetch()
    }

    func setup() {
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
    }

    func fetch() {
        DispatchQueue.main.async {
            self.viewModel?.fetch(completion: { result in
                switch result {
                case .success:
                    self.stopRefresh()
                case .failure:
                    self.stopRefresh()
                }
            })
        }
    }

    func bind() {
        guard var viewModel = viewModel else { return }
        viewModel.stateChange = { [weak self] in
            switch viewModel.currentState {
            case .loaded:
                self?.reload()
            case .errored:
                self?.stopRefresh()
            case .loading:
                self?.refreshControl.beginRefreshing()
            default:
                break
            }
        }
    }

    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func stopRefresh() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

    @objc func refresh() {
        fetch()
    }

    @IBAction func didTapDetailButton() {
        viewModel?.navigateToDatail()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? Int.empty
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        return viewModel.cellFor(tableView: tableView, at: indexPath)
    }

}


