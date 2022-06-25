//
//  SearchHeaderView.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

class SearchView: UIView {
    
    var searchPublisher: AnyPublisher<String?, Never> {
        searchBar.searchTextField.textPublisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private lazy var searchBar: UISearchBar = {
        let v = UISearchBar()
        
        v.searchBarStyle = .default
        v.placeholder = R.string.localizable.searchBarPlaceholder()
        v.isTranslucent = false
        v.backgroundImage = UIImage()
        
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
    
    private func setupUI() {
        addSubview(searchBar)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.bottom
                .equalToSuperview()
        }
        searchBar.sizeToFit()
    }
}
