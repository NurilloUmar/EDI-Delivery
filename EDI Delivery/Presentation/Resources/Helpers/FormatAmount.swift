internal import Foundation

 func formatAmount(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    formatter.maximumFractionDigits = 0
    return (formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))") + " UZS"
}
