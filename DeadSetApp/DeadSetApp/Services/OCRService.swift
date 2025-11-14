//
//  OCRService.swift
//  DeadSetApp
//
//  Created on 2025-01-13.
//

import Foundation
import Vision
import UIKit

class OCRService {

    static let shared = OCRService()

    private init() {}

    func recognizeText(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRError.invalidImage))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(OCRError.noTextFound))
                return
            }

            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")

            completion(.success(recognizedText))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }

    func extractReceiptData(from text: String) -> (merchant: String?, total: Decimal?, date: Date?) {
        var merchant: String?
        var total: Decimal?
        var date: Date?

        let lines = text.components(separatedBy: .newlines)

        // Extract merchant (usually first line)
        if let firstLine = lines.first, !firstLine.isEmpty {
            merchant = firstLine
        }

        // Extract total amount
        let totalPattern = #"(?:total|amount|sum)[:\s]*\$?(\d+[.,]\d{2})"#
        if let totalMatch = text.range(of: totalPattern, options: [.regularExpression, .caseInsensitive]) {
            let totalString = String(text[totalMatch])
            let numberString = totalString.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,")).inverted).joined()
            if let decimal = Decimal(string: numberString.replacingOccurrences(of: ",", with: ".")) {
                total = decimal
            }
        }

        // Try to extract any dollar amount as fallback
        if total == nil {
            let amountPattern = #"\$(\d+[.,]\d{2})"#
            let amounts = text.matches(of: amountPattern)
            if !amounts.isEmpty {
                // Get the largest amount (likely the total)
                let dollarAmounts = amounts.compactMap { match -> Decimal? in
                    let str = String(text[match.range]).replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ".")
                    return Decimal(string: str)
                }
                total = dollarAmounts.max()
            }
        }

        // Extract date (basic implementation)
        let datePattern = #"\d{1,2}/\d{1,2}/\d{2,4}"#
        if let dateMatch = text.range(of: datePattern, options: .regularExpression) {
            let dateString = String(text[dateMatch])
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            date = formatter.date(from: dateString)

            if date == nil {
                formatter.dateFormat = "MM/dd/yy"
                date = formatter.date(from: dateString)
            }
        }

        return (merchant, total, date)
    }

    enum OCRError: LocalizedError {
        case invalidImage
        case noTextFound

        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "The provided image is invalid"
            case .noTextFound:
                return "No text could be found in the image"
            }
        }
    }
}

// Helper extension for regex matching
extension String {
    func matches(of pattern: String) -> [Range<String.Index>] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return []
        }

        let nsString = self as NSString
        let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))

        return results.compactMap { result in
            Range(result.range, in: self)
        }
    }
}
