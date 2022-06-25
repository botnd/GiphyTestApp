//
//  SearchVC.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 24.06.2022.
//

class SearchVC: BaseVC {
    var viewModel: SearchVM!
    
    private var cells: [SearchCellVM] = []
    
    private lazy var searchView = SearchView()
    
    private lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .vertical
        fl.minimumInteritemSpacing = 10
        fl.minimumLineSpacing = 10

        let v = UICollectionView(frame: view.frame, collectionViewLayout: fl)
        v.delegate = self
        v.dataSource = self
        
        v.register(cellInterface: SearchCell.self)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchView)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp_bottom)
                .offset(5)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.cellsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.cells = cells
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        searchView.searchPublisher
            .assign(to: &viewModel.$searchQuery)
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let cellVM = self.cells[safeIndex: indexPath.row] {
            cell.configure(with: cellVM)
        }
        
        return cell
    }
}

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tapGif(indexPath.row)
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = (collectionView.bounds.width / 3) - 10
        let height: CGFloat
        
        if indexPath.row > 0 && (indexPath.row % 4 == 1 || indexPath.row % 4 == 2) {
            width = (width * 2) + 15
            height = (width - 15) / 2
        } else {
            height = width
        }
        
        return CGSize(width: width, height: height)
    }
}
