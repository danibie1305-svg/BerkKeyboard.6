import UIKit

@objc(KeyboardViewController)
final class KeyboardViewController: UIInputViewController {
    private let keyboardView = KeyboardView()

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let height = view.heightAnchor.constraint(equalToConstant: 260)
        height.priority = UILayoutPriority(999)
        height.isActive = true

        keyboardView.onInsert = { [weak self] text in
            self?.textDocumentProxy.insertText(text)
        }
        keyboardView.onDelete = { [weak self] in
            self?.textDocumentProxy.deleteBackward()
        }
        // Tasto globo: metodo ufficiale Apple per cambiare tastiera
        keyboardView.globeButton.addTarget(self,
                                           action: #selector(handleInputModeList(from:with:)),
                                           for: .allTouchEvents)
    }
}
