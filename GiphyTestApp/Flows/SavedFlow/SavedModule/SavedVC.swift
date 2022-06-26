//
//  SavedVC.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

class SavedVC: BaseVC {
    var viewModel: SavedVM!
    
    private var cells: [SavedCellVM] = []
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        
        v.separatorStyle = .none
        v.dataSource = self
        v.delegate = self
        
        v.register(cellInterface: SavedCell.self)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom
                .equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.cellsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cells in
                self?.cells = cells
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SavedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SavedCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let vm = cells[safeIndex: indexPath.row] {
            cell.configure(with: vm)
        }
        
        return cell
    }
}

extension SavedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellVM = viewModel.getVM(for: indexPath.row) else {
            return 150
        }
        
        let width = cellVM.gif.width
        let height = cellVM.gif.height
        
        return CGFloat((Float(tableView.bounds.width) * height) / width) + 10
    }
}
