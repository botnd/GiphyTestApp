//
//  SearchCell.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import Kingfisher
import SnapKit
import Combine

struct SearchCellVM {
    let gif: Gif
    let onSaveTap: GifAction?
}

class SearchCell: UICollectionViewCell, CellInterface {
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var saveButton: SaveButton = {
        let v = SaveButton()
        
        return v
    }()
    
    private var saveCancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom
                .equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            
            make.top
                .equalToSuperview()
                .offset(10)
            
            make.trailing
                .equalToSuperview()
                .offset(-10)
        }
    }
}

extension SearchCell: CellConfigurable {
    typealias VMType = SearchCellVM
    
    func configure(with vm: SearchCellVM) {
        imageView.kf.setImage(
            with: vm.gif.downsized?.url,
            placeholder: R.image.placeholder()?.withTintColor(.black, renderingMode: .alwaysTemplate),
            options: [
                .cacheOriginalImage,
                .transition(.fade(1))
            ]
        )
        
        saveCancellable = saveButton
            .publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                vm.onSaveTap?(vm.gif)
                self?.saveButton.setActive(true)
            }
    }
}
