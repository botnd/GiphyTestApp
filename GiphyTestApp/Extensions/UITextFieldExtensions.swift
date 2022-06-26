//
//  UITextFieldExtensions.swift
//  GiphyTestApp
//
//  Created by Dmitri Isakov on 25.06.2022.
//

import Combine

extension UITextField {
    /// Combine Publisher for text property
    ///
    /// Emits new values whenever UITextField.textDidChangeNotification is triggered on this object
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .map { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}
