import Foundation

enum PlayerIcon {
    static let defaultEmojis: [String] = [
        "dice",
        "rocket",
        "star",
        "flame",
        "bolt",
        "crown",
        "heart",
        "diamond",
        "clover",
        "moon",
        "sun",
        "sparkles"
    ]

    private static let emojiMap: [String: String] = [
        "dice": "\u{1F3B2}",
        "rocket": "\u{1F680}",
        "star": "\u{2B50}",
        "flame": "\u{1F525}",
        "bolt": "\u{26A1}",
        "crown": "\u{1F451}",
        "heart": "\u{2764}\u{FE0F}",
        "diamond": "\u{1F48E}",
        "clover": "\u{1F340}",
        "moon": "\u{1F319}",
        "sun": "\u{2600}\u{FE0F}",
        "sparkles": "\u{2728}"
    ]

    static func `default`(forIndex index: Int) -> String {
        defaultEmojis[index % defaultEmojis.count]
    }

    static func randomIcon() -> String {
        defaultEmojis.randomElement() ?? defaultEmojis[0]
    }

    static func randomIcon(excluding excludedIcons: Set<String>) -> String {
        let availableIcons = defaultEmojis.filter { !excludedIcons.contains($0) }
        return availableIcons.randomElement() ?? defaultEmojis[0]
    }

    static func displayText(for icon: String) -> String? {
        emojiMap[icon]
    }
}
