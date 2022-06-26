//
//  SavedCell.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

import Kingfisher

struct SavedCellVM {
    let gif: SavedGif
    let onSavedTap: SavedGifAction?
}

class SavedCell: UITableViewCell, CellInterface {
    
    private lazy var gifImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(gifImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
            
            make.top.equalToSuperview()
                .offset(5)
            
            make.bottom.equalToSuperview()
                .offset(-5)
        }
    }
}

extension SavedCell: CellConfigurable {
    typealias VMType = SavedCellVM
    
    func configure(with vm: SavedCellVM) {
        let provider = LocalFileImageDataProvider(fileURL: vm.gif.pathURL)
        gifImageView.kf.setImage(with: provider, placeholder: R.image.placeholder())
    }
}
