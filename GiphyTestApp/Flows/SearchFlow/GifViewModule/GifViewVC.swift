//
//  GifViewVC.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Kingfisher

class GifViewVC: BaseVC {
    var viewModel: GifViewVM!
    
    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        imageView.kf.setImage(
            with: viewModel.gif.original?.url,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom
                .equalToSuperview()
        }
    }
}
