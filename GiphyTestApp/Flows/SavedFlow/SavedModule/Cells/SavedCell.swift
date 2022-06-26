//
//  SavedCell.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

import Kingfisher
import Combine

struct SavedCellVM {
    let gif: SavedGif
    let onSavedTap: SavedGifAction?
}

class SavedCell: UITableViewCell, CellInterface {
    
    private var removeCancellable: AnyCancellable?
    
    private lazy var gifImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    private lazy var saveButton: SaveButton = {
        let v = SaveButton()
        v.setActive(true)
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
        contentView.addSubview(saveButton)
        
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

extension SavedCell: CellConfigurable {
    typealias VMType = SavedCellVM
    
    func configure(with vm: SavedCellVM) {
        let provider = LocalFileImageDataProvider(fileURL: vm.gif.pathURL)
        gifImageView.kf.setImage(with: provider, placeholder: R.image.placeholder())
        
        removeCancellable = saveButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                vm.onSavedTap?(vm.gif)
            }
    }
}
