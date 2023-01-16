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
//func stringResult(string: String, query: String, length: Int) -> String? {
//  guard let range = string.firstRangeContaining(query)
//  else { return nil }
//
//  let left = string[string.startIndex..<range.lowerBound]
//  let midd = string[range]
//  let rigt = string[range.upperBound..<string.endIndex]
//
//  if string.count < length {
//    return string
//  }
//
//  return nil
//}
//
//extension String {
//  func firstRangeContaining(_ query: String) -> Range<String.Index>? {
//
//    // Creates an array of strings, representing the sequential appending of
//    // each character in the string. For example:
//    // "foobar" = ["f", "fo", "foo", "foob" "fooba" "foobar"]
//    let queryAppendages = query.reduce(into: Array<String>(), { partial, next in
//      guard let mostRecent = partial.last
//      else {
//        partial.append(String(next))
//        return
//      }
//      partial.append(mostRecent + String(next))
//    })
//
//    let reversedQueryAppendages = queryAppendages.reversed()
//    var mostRecentRange: Range<String.Index>? = nil
//    for rQuery in reversedQueryAppendages {
//      guard let range = self.firstRange(of: rQuery)
//      else { continue }
//      mostRecentRange = range
//    }
//    return mostRecentRange
//  }
//}
