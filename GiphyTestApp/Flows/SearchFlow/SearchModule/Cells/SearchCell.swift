//
//  SearchCell.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

import Kingfisher
import SnapKit

struct SearchCellVM {
    let gif: Gif
}

class SearchCell: UICollectionViewCell, CellInterface {
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    
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
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom
                .equalToSuperview()
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
    }
}
