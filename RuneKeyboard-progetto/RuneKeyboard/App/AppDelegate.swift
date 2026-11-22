import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = InstructionsViewController()
        w.makeKeyAndVisible()
        window = w
        return true
    }
}

final class InstructionsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.text = """
        Rune Keyboard

        Per attivarla:
        1. Apri Impostazioni > Generali > Tastiera > Tastiere
        2. Tocca "Aggiungi nuova tastiera…"
        3. Scegli "Rune Keyboard"

        Per usarla: in qualsiasi app tocca il globo 🌐 della tastiera finché compare Rune Keyboard.

        Campo di prova:
        """

        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Tocca qui e scrivi"

        let stack = UIStackView(arrangedSubviews: [label, field])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
}
