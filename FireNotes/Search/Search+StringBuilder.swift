import Foundation
///**
//  Define a function indexRange, where given String A and String B, the function returns an index set containing
//  where B starts and ends in A
// */
//
////extension String {
////  func indexRange(of query: String) -> (Int, Int) {
////    if let i = self.firstRange(of: query)
////  }
////}
//
//
//// Displays a list of notes with the following principles:
///**
// Displays a list of notes with the following principles:
//  1. Search by title and content
//  2. Sort by most relevant title+content to querry
//
//  For each result, there should be highlighted content:
//    1. Title
//    2. Description
//
//  1. The Title
// if title contains the query you're searching for ignoring case...
//   if the result length is too long...
//      cut off anything before the query like: "...<query>
//   else
//      "blah <query>
//
// else
//  title can just be the title
//
// 2. The Description
//  same thing as the title, but if the title contains the query and the description doesnt', then just but a description
//  the only challenge vs the title is how to get a description that doesnt look like garbage or something...
//  I think what Apple's app does is find words that relate to the query and puts them in
//  That seems pretty complicated, well, I just don't want to push the scope of this app too far, so...
//  What we could do to make it as simple as possible is the following while being like Apple's:
//    - the result should always be  "<fillerLeftSide><query><fillerRightSide>"
//    - fillers should be dervied from splitting results from a string via a space delimiter and should try to use as many
//      words as possible to fit..
// */
//
////if title contains the query you're searching for ignoring case...
////  if the result length is too long...
////     cut off anything before the query like: "...<query>
////  else
////     "blah <query>
////
////else
//// title can just be the title
//
//
//func noteResult(_ note: Note, for query: String, length: Int) -> (String?, String?) {
//  let t = note.title.lowercased()
//  let d = note.body.lowercased()
//  let q = query.lowercased()
//  let l = length
//
//  let titleResult = stringResult(string: t, query: q, length: l)
//  let descriptionResult = stringResult(string: d, query: q, length: l)
//  return (titleResult, descriptionResult)
//}
//
///**
//  Assumptions:
// - Assume strings are all lower case
// - Assume query is shorter than the length, by a relatively decent amount... i.e. quey.length = 10, length = 30
//
// */

import Foundation

func stringResult3(
  source sourceRaw: String,
  query queryRaw: String,
  length: Int,
  caseInsensitive: Bool = true
) -> String? {
  
  let source: String = {
    caseInsensitive ? sourceRaw.lowercased() : sourceRaw
  }()
  let query: String = {
    caseInsensitive ? queryRaw.lowercased() : queryRaw
  }()
  
  
  guard let nsregex = try? NSRegularExpression(
    pattern: NSRegularExpression.escapedPattern(for: query)
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .folding(
        options: .regularExpression,
        locale: .current
      )
    ,
    options: caseInsensitive ? .caseInsensitive : .init()
  ) else {
      return nil
  }
  guard let regex = try? Regex(nsregex.pattern)
  else { return nil }

  let ranges = source.ranges(of: regex)
  let foundWords = ranges.compactMap { range -> String? in
    // Go back till you find a space, this will be the new range start index
    guard let newStartIdx: Int = {
      let leftTemp = source[source.startIndex...range.lowerBound]
      var x = -1
      for (idx, char) in leftTemp.reversed().enumerated() {
        if char == " " {
          x = idx
          break
        }
      }
      let lbound = source.distance(from: source.startIndex, to: range.lowerBound)
      let i = x == -1 ? nil : lbound - x
      print("query: ", query, " i: ", i, "for: ", source, "\n")
      return i
    }()
    else { return nil }
    
    // Go back forward till you find a space, this will be the new range end index
    guard let newEndIdx: Int = {
      let rightTemp = source[range.upperBound..<source.endIndex]
      var x = -1
      for (idx, char) in rightTemp.enumerated() {
        if char == " " {
          x = idx
          break
        }
      }
      let lbound = source.distance(from: source.startIndex, to: range.lowerBound)
      let i = x == -1 ? nil : lbound + x
      print("query: ", query, " i: ", i, "for: ", source, "\n")
      return i
    }()
    else { return nil }
    
    let x = source.index(source.startIndex, offsetBy: newStartIdx)
    let y = source.index(source.startIndex, offsetBy: newEndIdx)
    let finalStr = source[x...y]
    print("finalStr: ", finalStr)
    return String(finalStr)
  }
  
  foundWords.forEach { print("foundWord:", $0)}
  let finalResult = foundWords.joined(separator: " ")
  return finalResult
}


func stringResult2(
  source sourceRaw: String,
  query queryRaw: String,
  length: Int,
  caseInsensitive: Bool = true
) -> String? {
  
  let source: String = {
    caseInsensitive ? sourceRaw.lowercased() : sourceRaw
  }()
  let query: String = {
    caseInsensitive ? queryRaw.lowercased() : queryRaw
  }()
  
  // Find the range where the string contains the query
  guard let range = source.firstRangeContaining(query)
  else { return nil }
  print(
    "range: ",
    Int(source.distance(from: source.startIndex, to: range.lowerBound)),
    " ",
    Int(source.distance(from: source.startIndex, to: range.upperBound)),
    ": ",
    source[range]
  )
  
  
  // However, we need to make sure we get a word, so we need to
  // fix the range a little bit.
  
  
  // Go back till you find a space, this will be the new range start index
  guard let newStartIdx: Int = {
    let leftTemp = source[source.startIndex...range.lowerBound]
    var x = -1
    for (idx, char) in leftTemp.reversed().enumerated() {
      if char == " " {
        x = idx
        break
      }
    }
    let lbound = source.distance(from: source.startIndex, to: range.lowerBound)
    let i = x == -1 ? nil : lbound - x
    print("query: ", query, " i: ", i, "for: ", source, "\n")
    return i
  }()
  else { return nil }
  
  // Go back forward till you find a space, this will be the new range end index
  guard let newEndIdx: Int = {
    let rightTemp = source[range.upperBound..<source.endIndex]
    var x = -1
    for (idx, char) in rightTemp.enumerated() {
      if char == " " {
        x = idx
        break
      }
    }
    let lbound = source.distance(from: source.startIndex, to: range.lowerBound)
    let i = x == -1 ? nil : lbound + x
    print("query: ", query, " i: ", i, "for: ", source, "\n")
    return i
  }()
  else { return nil }
  
  let x = source.index(source.startIndex, offsetBy: newStartIdx)
  let y = source.index(source.startIndex, offsetBy: newEndIdx)
  let finalStr = source[x...y]
  print("finalStr: ", finalStr)
  
  
  
  return nil
}

/// Returns a string that represents a substring of a given string that contains a given query, up to a given length.
/// If the string does not contain the query, then return nil.
///
/// - Parameters:
///   - source: The string to check
///   - query: The string we are checking if the source contains
///   - length: The maximum length of the resulting string
///   - caseInsensitive: Boolean if case does not matter
///
func stringResult(
  source sourceRaw: String,
  query queryRaw: String,
  length: Int,
  caseInsensitive: Bool = true
) -> String? {
  
  let source: String = {
    caseInsensitive ? sourceRaw.lowercased() : sourceRaw
  }()
  let query: String = {
    caseInsensitive ? queryRaw.lowercased() : queryRaw
  }()
  
  /**
   Much simpler:
   1. find the range where the query occurs
   2. compare the length of that range to your maxLength
   3. split the string surrounding the two
   4. add words from left, then right
   */
  
  // Find the range where the string contains the query
  guard let range = source.firstRangeContaining(query)
  else { return nil }
  print(
    "range: ",
    Int(source.distance(from: source.startIndex, to: range.lowerBound)),
    " ",
    Int(source.distance(from: source.startIndex, to: range.upperBound)),
    ": ",
    source[range]
  )
  

  // Split the string into left, middle, and right.
  let left = source[source.startIndex...range.lowerBound].split(separator: " ")
  let midd = source[range]
  let rigt = source[range.upperBound..<source.endIndex].split(separator: " ")
  
  // Well, the midd should be split by " ", and iterate and added to left and right...
  // Well, we could do the following:
  //  - split the midd
  //  -
  
  print("splits: ")
  print(left)
  print(midd)
  print(rigt)
  print()
  
  // Build the result by iteratively adding parts of the left side string, then
  // the right side string, up to the given length.
  var result = String(midd)
  var idx = 0
  while idx < left.count && idx < rigt.count {
    if idx < left.count {
      let newLeft = result + left[idx]
      if newLeft.count < length {
        if result.last != " " { result += " " }
        result = newLeft + " " + result
      }
    }
    
    if idx < rigt.count {
      let newRigt = result + rigt[idx]
      if newRigt.count < length {
        if result.last != " " { result += " " }
        result = result + " " + newRigt
      }
    }
    idx += 1
  }
  
  print("result:", result)
  return result
}

extension String {
  func firstRangeContaining(
    _ queryRaw: String,
    caseInsensitive: Bool = true
  ) -> Range<String.Index>? {

    let query: String  = {
      caseInsensitive ? queryRaw.lowercased() : queryRaw
    }()
    // Creates an array of strings, representing the sequential appending of
    // each character in the string. For example:
    // "foobar" = ["f", "fo", "foo", "foob" "fooba" "foobar"]
    let queryAppendages = query.reduce(into: Array<String>(), { partial, next in
      guard let mostRecent = partial.last
      else {
        partial.append(String(next))
        return
      }
      partial.append(mostRecent + String(next))
    })

    let reversedQueryAppendages = queryAppendages.reversed()
    var mostRecentRange: Range<String.Index>? = nil
    for rQuery in reversedQueryAppendages {
      guard let range = self.firstRange(of: rQuery)
      else { continue }
      mostRecentRange = range
    }
    return mostRecentRange
  }
}

