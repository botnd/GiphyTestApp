//
//  SaveButton.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 26.06.2022.
//

class SaveButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        clipsToBounds = true
        tintColor = .red
        
        setActive(false)
    }
    
    func setActive(_ value: Bool) {
        setImage(
            UIImage(systemName: value ? "heart.fill" : "heart")?
                .withTintColor(.red, renderingMode: .alwaysTemplate),
            for: .normal
        )
    }
}
