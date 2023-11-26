//
//  ProductsListViewController.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//  Modified by Eka Kelenjeridze on 26.11.23.
//

import UIKit

//added 'final'
final class ProductsListViewController: UIViewController {
    
    // MARK: - Properties
    private let productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .purple
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    private let totalPriceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "total: 0$"
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    private let productsViewModel = ProductsListViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProductsViewModel()
        productsViewModel.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    // MARK: - Private Methods
    
    //MARK: setup UI
    //added 'private'
    private func setupUI() {
        view.backgroundColor = .orange
        setupTableView()
        setupIndicator()
        setupTotalPriceLbl()
    }
    
    //added 'private'
    private func setupTableView() {
        view.addSubview(productsTableView)
        
        NSLayoutConstraint.activate([
            productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //set UITableView delegate & dataSource
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    //added 'private'
    private func setupIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //added 'private'
    private func setupTotalPriceLbl() {
        view.addSubview(totalPriceLbl)
        
        NSLayoutConstraint.activate([
            totalPriceLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPriceLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPriceLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Setup ViewModel Delegate
    private func setupProductsViewModel() {
        productsViewModel.delegate = self
    }
}

// MARK: - TableView Delegate & DataSource
extension ProductsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //replaced 10 with -> productsViewModel.products?.count ?? 0
        productsViewModel.products?.count ?? 0
        //        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let currentProduct = productsViewModel.products?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.reload(with: currentProduct)
        return cell
    }
}

// MARK: - ViewModel Delegate
extension ProductsListViewController: ProductsListViewModelDelegate {
    func productsFetched() {
        //update UI on the main thread
        DispatchQueue.main.async {
            self.productsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func productsAmountChanged() {
        //update UI on the main thread
        DispatchQueue.main.async {
            //added $ symbol in the String
            self.totalPriceLbl.text = "Total price: \(self.productsViewModel.totalPrice ?? 0)$"
        }
    }
    
    func showError(_ error: Error) {
        print("error while getting data from ViewModel")
    }
}

// MARK: - Cell Delegate
extension ProductsListViewController: ProductCellDelegate {
    func addProduct(for cell: ProductCell) {
        if let indexPath = productsTableView.indexPath(for: cell) {
            //correct: array is zero-based
            productsViewModel.addProduct(at: indexPath.row)
            //productsViewModel.addProduct(at: indexPath.row + 1)
            //added reloadRows()
            productsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func removeProduct(for cell: ProductCell) {
        if let indexPath = productsTableView.indexPath(for: cell) {
            //correct: array is zero-based
            productsViewModel.removeProduct(at: indexPath.row)
            //productsViewModel.removeProduct(at: indexPath.row + 1)
            //added reloadRows()
            productsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


