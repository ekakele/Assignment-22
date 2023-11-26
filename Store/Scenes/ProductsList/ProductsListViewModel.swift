//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//  Modified by Eka Kelenjeridze on 26.11.23.
//

import Foundation

// MARK: - ViewModel Delegate
protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched()
    func productsAmountChanged()
    //added error handling
    func showError(_ error: Error)
}

// MARK: - Error Enum
//added error handling
enum ProductError: Error {
    case outOfStock
    case productNotFound
    case selectedQuantityIsAlreadyZero
}

//added 'final'
final class ProductsListViewModel {
    // MARK: - Properties
    weak var delegate: ProductsListViewModelDelegate?
    var products: [ProductModel]?
    var totalPrice: Double? {
        //fixed an issue with the types: convert $1.price to Double
        products?.reduce(0) { $0 + Double($1.price) * Double(($1.selectedAmount ?? 0))}
    }
    
    // MARK: - ViewLifeCycle
    func viewDidLoad() {
        fetchProducts()
    }
    
    // MARK: - Private Methods
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                //added error handling
                self?.delegate?.showError(error)
                //TODO: handle Error
                break
            }
        }
    }
    
    // MARK: - Internal Methods
    //updated func: handled if products are out of stock
    func addProduct(at index: Int) {
        //TODO: handle if products are out of stock
        guard var product = products?[index] else {
            delegate?.showError(ProductError.productNotFound)
            return
        }
        
        guard product.stock > 0 else {
            delegate?.showError(ProductError.outOfStock)
            return
        }
        product.selectedAmount = (products?[index].selectedAmount ?? 0) + 1
        delegate?.productsAmountChanged()
        
        product.stock -= 1
        products?[index] = product
    }
    
    //updated func: handled if selected quantity of product is already 0
    func removeProduct(at index: Int) {
        //TODO: handle if selected quantity of product is already 0
        guard var product = products?[index] else {
            delegate?.showError(ProductError.productNotFound)
            return
        }
        
        guard product.selectedAmount ?? 0 > 0 else {
            delegate?.showError(ProductError.selectedQuantityIsAlreadyZero)
            return
        }
        product.selectedAmount = (products?[index].selectedAmount ?? 0) - 1
        delegate?.productsAmountChanged()
        product.stock += 1
        products?[index] = product
    }
}
