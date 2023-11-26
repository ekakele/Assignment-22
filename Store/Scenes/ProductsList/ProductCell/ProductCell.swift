//
//  ProductCell.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//  Modified by Eka Kelenjeridze on 26.11.23.
//

import UIKit

// MARK: - Cell Delegate
//set cell identifier "ProductCell"
//set class for the "File's Owner"
protocol ProductCellDelegate: AnyObject {
    func removeProduct(for cell: ProductCell)
    func addProduct(for cell: ProductCell)
}

//added 'final'
final class ProductCell: UITableViewCell {
    // MARK: - Property Outlets
    //added 'private' to outlets
    //reordered correctly according storyboard UI configuration
    @IBOutlet private weak var prodImageView: UIImageView!
    @IBOutlet private weak var prodTitleLbl: UILabel!
    @IBOutlet private weak var descrLbl: UILabel!
    @IBOutlet private weak var stockLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var quantityModifierView: UIView!
    @IBOutlet private weak var selectedQuantityLbl: UILabel!
    
    // MARK: - Properties
    weak var delegate: ProductCellDelegate?
    
    // MARK: - UITableViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Prepare For Reuse
    //added prepareForReuse func
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prodImageView.image = nil
        prodTitleLbl.text = nil
        descrLbl.text = nil
        stockLbl.text = nil
        priceLbl.text = nil
        selectedQuantityLbl.text = nil
    }
    
    // MARK: - Private Methods
    //added 'private'
    private func setupUI(){
        quantityModifierView.layer.cornerRadius = 5
        quantityModifierView.layer.borderWidth = 1
        quantityModifierView.layer.borderColor = UIColor.lightGray.cgColor
        
        quantityModifierView.isUserInteractionEnabled = true
    }
    
    // MARK: - Configure
    func reload(with product: ProductModel) {
        //TODO: reload images are not correct when reloading list after changing quantity
        //reordered correctly according storyboard UI configuration
        setImage(from: product.thumbnail)
        prodTitleLbl.text = product.title
        descrLbl.text = "\(product.description)"
        stockLbl.text = "\(product.stock)"
        priceLbl.text = "\(product.price)$"
        selectedQuantityLbl.text = "\(product.selectedAmount ?? 0)"
    }
    
    // MARK: - Private Methods
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.prodImageView.image = image
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addProduct(_ sender: Any) {
        delegate?.addProduct(for: self)
    }
    
    @IBAction func removeProduct(_ sender: Any) {
        delegate?.removeProduct(for: self)
    }
}
