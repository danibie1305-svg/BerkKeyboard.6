import Foundation

enum RuneMap {
    static let table: [String: String] = [
        "A": "ᚨ", "B": "ᛒ", "C": "ᚲ", "D": "ᛞ", "E": "ᛖ", "F": "ᚠ",
        "G": "ᚷ", "H": "ᚻ", "I": "ᛁ", "J": "ᛁ", "K": "ᚲ", "L": "ᛚ",
        "M": "ᛗ", "N": "ᚾ", "O": "ᛟ", "P": "ᛈ", "Q": "ᚲᚢ", "R": "ᚱ",
        "S": "ᛋ", "T": "ᛏ", "U": "ᚢ", "V": "ᚢ", "W": "ᚹ", "X": "X",
        "Y": "ᛦ", "Z": "ᛉ"
    ]

    static func rune(for letter: String) -> String {
        return table[letter.uppercased()] ?? letter
    }
}
