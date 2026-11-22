import UIKit

final class KeyButton: UIButton {
    var normalColor: UIColor = .white { didSet { backgroundColor = normalColor } }
    var pressedColor: UIColor = .lightGray
    override var isHighlighted: Bool {
        didSet { backgroundColor = isHighlighted ? pressedColor : normalColor }
    }
}

struct KeySpec {
    enum Action { case insert(String), delete, shift, toNumbers, toLetters, globe, filler }
    let title: String
    let action: Action
    let weight: CGFloat      // -1 = larghezza flessibile
    let isFunction: Bool
}

final class KeyboardView: UIView {
    var onInsert: ((String) -> Void)?
    var onDelete: (() -> Void)?
    let globeButton = KeyButton(type: .custom)

    private var showingNumbers = false
    private var keyRows: [[(KeyButton, KeySpec)]] = []
    private var deleteTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        rebuild()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rebuild()
    }

    // MARK: Disposizione

    private static func runeKeys(_ letters: String) -> [KeySpec] {
        letters.map { ch in
            let r = RuneMap.rune(for: String(ch))
            return KeySpec(title: r, action: .insert(r), weight: 1, isFunction: false)
        }
    }

    private static func symbolKeys(_ chars: [String], weight: CGFloat = 1) -> [KeySpec] {
        chars.map { KeySpec(title: $0, action: .insert($0), weight: weight, isFunction: false) }
    }

    private func bottomRow(toggleTitle: String, toggle: KeySpec.Action) -> [KeySpec] {
        return [
            KeySpec(title: toggleTitle, action: toggle, weight: 1.25, isFunction: true),
            KeySpec(title: "", action: .globe, weight: 1.25, isFunction: true),
            KeySpec(title: "·", action: .insert("·"), weight: -1, isFunction: false),
            KeySpec(title: "invio", action: .insert("\n"), weight: 2, isFunction: true)
        ]
    }

    private func specs() -> [[KeySpec]] {
        let delete = KeySpec(title: "⌫", action: .delete, weight: 1.5, isFunction: true)
        if showingNumbers {
            return [
                Self.symbolKeys(Array("1234567890").map { String($0) }),
                Self.symbolKeys(["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""]),
                [KeySpec(title: "#+=", action: .filler, weight: 1.5, isFunction: true)]
                    + Self.symbolKeys([".", ",", "?", "!", "'"], weight: -1) + [delete],
                bottomRow(toggleTitle: "ABC", toggle: .toLetters)
            ]
        }
        return [
            Self.runeKeys("QWERTYUIOP"),
            Self.runeKeys("ASDFGHJKL"),
            [KeySpec(title: "⇧", action: .shift, weight: 1.5, isFunction: true)]
                + Self.runeKeys("ZXCVBNM") + [delete],
            bottomRow(toggleTitle: "123", toggle: .toNumbers)
        ]
    }

    // MARK: Costruzione tasti

    private static func dyn(_ light: UIColor, _ dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

    private func rebuild() {
        for row in keyRows { for (b, _) in row { b.removeFromSuperview() } }
        keyRows = specs().map { row in row.map { (makeButton($0), $0) } }
        setNeedsLayout()
    }

    private func makeButton(_ spec: KeySpec) -> KeyButton {
        let b: KeyButton
        if case .globe = spec.action { b = globeButton } else { b = KeyButton(type: .custom) }

        let text = Self.dyn(.black, .white)
        let dimmed = Self.dyn(UIColor(white: 0.55, alpha: 1), UIColor(white: 0.5, alpha: 1))
        let letterNormal = Self.dyn(.white, UIColor(white: 0.42, alpha: 1))
        let funcNormal = Self.dyn(UIColor(white: 0.67, alpha: 1), UIColor(white: 0.27, alpha: 1))

        b.setTitle(spec.title, for: .normal)
        b.setTitleColor(text, for: .normal)
        b.setTitleColor(dimmed, for: .disabled)
        b.tintColor = text
        if spec.title == "·" {
            b.titleLabel?.font = .systemFont(ofSize: 30)
        } else if spec.isFunction {
            b.titleLabel?.font = .systemFont(ofSize: 15)
        } else {
            b.titleLabel?.font = .systemFont(ofSize: 22)
        }
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.normalColor = spec.isFunction ? funcNormal : letterNormal
        b.pressedColor = spec.isFunction ? letterNormal : funcNormal
        b.layer.cornerRadius = 5
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.35
        b.layer.shadowOffset = CGSize(width: 0, height: 1)
        b.layer.shadowRadius = 0
        b.isEnabled = true

        switch spec.action {
        case .insert(let s):
            b.addAction(UIAction { [weak self] _ in self?.onInsert?(s) }, for: .touchUpInside)
        case .delete:
            b.addAction(UIAction { [weak self] _ in self?.beginDelete() }, for: .touchDown)
            for ev in [UIControl.Event.touchUpInside, .touchUpOutside, .touchCancel] {
                b.addAction(UIAction { [weak self] _ in self?.endDelete() }, for: ev)
            }
        case .shift, .filler:
            b.isEnabled = false          // SHIFT visibile ma senza funzione
        case .toNumbers:
            b.addAction(UIAction { [weak self] _ in self?.setNumbers(true) }, for: .touchUpInside)
        case .toLetters:
            b.addAction(UIAction { [weak self] _ in self?.setNumbers(false) }, for: .touchUpInside)
        case .globe:
            b.setImage(UIImage(systemName: "globe"), for: .normal)
        }
        addSubview(b)
        return b
    }

    private func setNumbers(_ on: Bool) {
        showingNumbers = on
        rebuild()
    }

    // MARK: Cancellazione con ripetizione

    private func beginDelete() {
        onDelete?()
        deleteTimer?.invalidate()
        let first = Timer(timeInterval: 0.4, repeats: false) { [weak self] _ in
            let rep = Timer(timeInterval: 0.07, repeats: true) { [weak self] _ in self?.onDelete?() }
            RunLoop.main.add(rep, forMode: .common)
            self?.deleteTimer = rep
        }
        RunLoop.main.add(first, forMode: .common)
        deleteTimer = first
    }

    private func endDelete() {
        deleteTimer?.invalidate()
        deleteTimer = nil
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !keyRows.isEmpty else { return }
        let side: CGFloat = 3, gap: CGFloat = 6, top: CGFloat = 10, bottom: CGFloat = 4, rowGap: CGFloat = 11
        let n = CGFloat(keyRows.count)
        let rowH = (bounds.height - top - bottom - rowGap * (n - 1)) / n
        let u = (bounds.width - 2 * side - 9 * gap) / 10

        for (r, row) in keyRows.enumerated() {
            let y = top + CGFloat(r) * (rowH + rowGap)
            var fixed: CGFloat = 0
            var flex: CGFloat = 0
            for (_, s) in row {
                if s.weight < 0 { flex += 1 } else { fixed += s.weight * u + (s.weight - 1) * gap }
            }
            let gaps = gap * CGFloat(row.count - 1)
            let flexW = flex > 0 ? (bounds.width - 2 * side - fixed - gaps) / flex : 0
            let total = fixed + flexW * flex + gaps
            var x = (bounds.width - total) / 2
            for (b, s) in row {
                let w = s.weight < 0 ? flexW : s.weight * u + (s.weight - 1) * gap
                b.frame = CGRect(x: x, y: y, width: w, height: rowH)
                x += w + gap
            }
        }
    }
}
