import SwiftUI

/// Unique visual identity for Layaway - Payment Plan Log.
enum Theme {
    static let accent = Color(red: 0.5412, green: 0.3529, blue: 0.1686)
    static let background = Color(red: 0.1020, green: 0.0784, blue: 0.0510)
    static let textPrimary = Color(red: 0.9686, green: 0.9373, blue: 0.8941)
    static let card = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static func statusColor(_ status: String) -> Color {
        switch status {
        case "Active": return accent
        case "Cancelled": return .gray
        default: return accent.opacity(0.7)
        }
    }
}
