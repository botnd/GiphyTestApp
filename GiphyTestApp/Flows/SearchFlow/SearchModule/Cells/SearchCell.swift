//
//  SearchCell.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

struct SearchCellVM {
    let gif: Gif
}

class SearchCell: UICollectionViewCell, CellInterface {
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
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
        // TODO: configure image w kingfisher
    }
}
