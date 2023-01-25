import Foundation
import IdentifiedCollections
import XCTestDynamicOverlay

// MARK: - ViewModel
final class SearchViewModel: ObservableObject {
  @Published var notes: IdentifiedArrayOf<Note>
  
  var topHits: IdentifiedArrayOf<Note> {
    .init(notes.prefix(2))
  }
  
  var noteTapped: (Note) -> Void = unimplemented("SearchViewModel.noteTapped")
  
  init(notes: IdentifiedArrayOf<Note>) {
    self.notes = notes
  }
}

// MARK: - Search Result Functionality

/// Returns a string containing as many words containing the query in the source, up to a given length,
/// case insensitively or not.
///
/// Words are represented as a sequence of characters, separated by any whitespace.
/// Resulting string does not have partial words, so entire words will be cut off.
///
/// i.e.
///
///  let result = stringSearchResult(
///   source: "molly sold seashells at the seashore",
///   query: "sea",
///   length: "50"
///   caseInsensitive: true
///  )
///
///  print(result) <-- "sold seashells seashore"
///
///  let result = stringSearchResult(
///   source: "molly sold seashells at the seashore",
///   query: "sea",
///   length: "20"
///   caseInsensitive: true
///  )
///
///  print(result) <-- "sold seashells"
///
///
/// - Parameters:
///   - source: The string to check
///   - query: The string representing what the source should contain
///   - length: The maximum length of the resuult
///   - caseInsensitive: boolean representing if search should be case insensitive
///
func stringSearchResult(
  source sourceRaw: String,
  query queryRaw: String,
  length: Int,
  caseInsensitive: Bool = true
) -> String? {
  
  let source: String = { caseInsensitive ? sourceRaw.lowercased() : sourceRaw }()
  let query: String = { caseInsensitive ? queryRaw.lowercased() : queryRaw }()
  
  guard let regex: Regex<AnyRegexOutput> = {
    guard let reg = nsRegex(query: query, caseInsensitive: caseInsensitive)
    else { return nil }
    return try? Regex(reg.pattern)
  }()
  else { return nil }
  
  let ranges = source.ranges(of: regex)
  let foundWords: [String] = ranges.compactMap { range -> String? in
    
    // Go back till you find a space, this will be the new range start index
    guard let newStartIdx: Int = {
      let leftSide = source[source.startIndex...range.lowerBound]
      var x = -1
      for (idx, char) in leftSide.reversed().enumerated() {
        if char == " " {
          x = idx
          break
        }
      }
      let leftOffset = source.distance(from: source.startIndex, to: range.lowerBound)
      let i = x == -1 ? nil : leftOffset - x
      return i
    }()
    else { return nil }
    
    // Go back forward till you find a space, this will be the new range end index
    guard let newEndIdx: Int = {
      let rightSide = source[range.upperBound..<source.endIndex]
      var x = -1
      for (idx, char) in rightSide.enumerated() {
        if char == " " {
          x = idx
          break
        }
      }
      let rightOffset = source.distance(from: source.startIndex, to: range.upperBound)
      let i = x == -1 ? nil : rightOffset + x
      return i
    }()
    else { return nil }
    
    // Return the extracted string.
    let x = source.index(source.startIndex, offsetBy: newStartIdx)
    let y = source.index(source.startIndex, offsetBy: newEndIdx)
    let finalStr = String(source[x...y])
    return String(finalStr)
  }
  .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
  
  var finalResult = ""
  for word in foundWords {
    let new = finalResult + " " + word + " "
    if new.count < length {
      finalResult = new
    }
  }
  finalResult = String(finalResult[finalResult.startIndex..<finalResult.endIndex])
  return finalResult
}

func nsRegex(query: String, caseInsensitive: Bool = true) -> NSRegularExpression? {
  try? NSRegularExpression(
    pattern: NSRegularExpression.escapedPattern(for: query)
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .folding(
        options: .regularExpression,
        locale: .current
      )
    ,
    options: caseInsensitive ? .caseInsensitive : .init()
  )
}
