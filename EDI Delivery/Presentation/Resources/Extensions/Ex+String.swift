
internal import Foundation
import UIKit


extension String {
    func replace(_ dictionary: [String : String]) -> String {
        var result = String()
        var i = -1
        for (of, with) : (String, String) in dictionary {
            i += 1
            if i < 1 {
                result = self.replacingOccurrences(of: of, with: with)
            } else {
                result = result.replacingOccurrences(of: of, with: with)
            }
        }
        return result
    }
    
    func withYellowText(text: String, secondText: String = "") -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: self, attributes: [:])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "yellow_color") ?? .black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let range = (self as NSString).range(of: text)
        if !secondText.isEmpty {
            let range2 = (self as NSString).range(of: secondText)
            fullString.addAttributes(boldFontAttribute, range: range2)
        }
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
    
    public func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
    }
    
    
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    var decodeUrl: String {
        return self.removingPercentEncoding ?? self
    }
    
}


extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func withYellowText(text: String, secondText: String = "", color: UIColor, size: CGFloat) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: self, attributes: [:])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size)]
        let range = (self as NSString).range(of: text)
        if !secondText.isEmpty {
            let range2 = (self as NSString).range(of: secondText)
            fullString.addAttributes(boldFontAttribute, range: range2)
        }
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""
    
    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted) B"
        
    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted) mln"
        
    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted) K"
        
    case 0...:
        return "\(n)" + " so'm"
    default:
        return "\(sign)\(n)" + " so'm"
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}


extension NSAttributedString {
    func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.strikethroughStyle,
                                      value: style,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}


extension UITapGestureRecognizer {
    
    func didTapAttributedString(_ string: String, in label: UILabel) -> Bool {
        
        guard let text = label.text else {
            
            return false
        }
        
        let range = (text as NSString).range(of: string)
        return self.didTapAttributedText(label: label, inRange: range)
    }
    
    private func didTapAttributedText(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        guard let attributedText = label.attributedText else {
            
            assertionFailure("attributedText must be set")
            return false
        }
        
        let textContainer = createTextContainer(for: label)
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        if let font = label.font {
            
            textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedText.length))
        }
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let alignmentOffset = aligmentOffset(for: label)
        
        let xOffset = ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        
        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: label.bounds.size.width, y: label.font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return characterTapped < charsInLineTapped ? targetRange.contains(characterTapped) : false
    }
    
    private func createTextContainer(for label: UILabel) -> NSTextContainer {
        
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        return textContainer
    }
    
    private func aligmentOffset(for label: UILabel) -> CGFloat {
        
        switch label.textAlignment {
            
        case .left, .natural, .justified:
            
            return 0.0
        case .center:
            
            return 0.5
        case .right:
            
            return 1.0
            
        @unknown default:
            
            return 0.0
        }
    }
}

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension String {
    func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: Date())
    }

    func nsRange(in text: String) -> NSRange? {
        guard let range = text.range(of: self) else { return nil }
        return NSRange(range, in: text)
    }
}

extension Optional where Wrapped == String {
    var nonOptional: String { self ?? "" }
    
    var isNilOrEmpty: Bool { nonOptional.isEmpty }
}

