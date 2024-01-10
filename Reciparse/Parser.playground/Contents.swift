import Foundation
import PlaygroundSupport

// MARK: - Prepared values

/// Sentence element types
enum Label: String, Encodable {
    
    case value
    case measure
    case comment
    
    case ingredient
    case combination
    
}

/// Sentence element
struct WordObject: Hashable {
    
    var token: String
    var label: Label
    
}

/// Sentence
class SentenceObject: Encodable {
    
    var tokens: [String] = []
    var labels: [Label] = []
    
}

/// Final JSON
struct FinalJSON: Encodable {
    
    var objects: [SentenceObject]
    
}

// MARK: - JSON Data preparing

/// Loading of the "IngredientListJsonObjects.json" from the "Resource" folder.
/// Don't forget to add this file to the "Resource" folder before

func loadJSONList() -> Data? {
    guard let jsonURL = Bundle.main.url(forResource: "IngredientDataSet", withExtension: "json") else {
        print("JSON file is not found")
        return nil
    }
    return try? Data(contentsOf: jsonURL, options: .alwaysMapped)
}

/// Parsing of uniqe ingredient names from JSON

func getIngredients() -> [WordObject] {
    let decoder = JSONDecoder()
    
    guard let jsonData = loadJSONList(), let jsonArray = try? decoder.decode([IngredientArray].self, from: jsonData) else {
        return []
    }
    
    return Set(jsonArray.flatMap { $0.ingredients }).map {
        return WordObject(token: $0, label: .ingredient)
    }
}


/// Values preparing
///
///
func getComments() -> [WordObject] {
    
    var comments: [String] = [
        "sifted",
        "packed",
        "chopped",
        "diced",
        "minced",
        "sliced",
        "grated",
        "peeled",
        "cored",
        "seeded",
        "halved",
        "quartered",
        "cubed",
        "crushed",
        "mashed",
        "juiced",
        "zested",
        "toasted",
        "cooked",
        "uncooked",
        "drained",
        "rinsed",
        "dried",
        "frozen",
        "thawed",
        "softened",
        "melted",
        "chilled",
        "warmed",
        "boiled",
        "steamed",
        "roasted",
        "grilled",
        "baked",
        "fried",
        "sauteed",
        "caramelized",
        "blanched",
        "braised",
        "broiled",
        "poached",
        "stewed",
        "stir-fried",
        "marinated",
        "seasoned",
        "diced",
        "minced",
        "sliced",
        "grated",
        "partially melted",
        "partially frozen",
        "partially thawed",
        "partially softened",
        "finely chopped",
        "finely diced",
        "finely minced",
        "finely sliced",
        "finely grated",
        "finely zested",
        "finely toasted",
        "finely cooked",
        "ground",
        "crumbled",
        "shredded",
        "julienned",
        "pureed",
        "blended",
        "more to taste",
        "for drizzling",
        "for garnish",
        "for sprinkling",
        "for dusting",
        "for rolling",
        "for coating",
        "for frying",
        "for greasing",
        "for brushing",
        "for basting",
        "for topping",
        "for serving",
        "for dipping",
        "for spreading",
        "for layering",
        "for lining",
        "for dusting",
        "for rolling",
        "for coating",
        "for frying",
        "for greasing",
        "for brushing",
        "ripe",
        "unripe",
        "firm",
        "soft",
        "hard",
        "crisp",
        "crunchy",
        "tender",
        "meaty",
        "lean",
        "fatty",
        "thick",
        "thin",
        "large",
        "small",
        "medium",
        "extra large",
        "extra small",
        "boneless",
        "skinless",
        "bone-in",
        "skin-on",
        "whole",
        "halved",
        "quartered",
        "cubed",
        "crushed",
        "1%",
        "2%",
        "3%",
        "4%",
        "5%",
        "6%",
        "7%",
        "8%",
        "9%",
        "10%",
        "11%",
        "12%",
        "13%",
        "14%",
        "15%",
        "16%",
        "17%",
        "18%",
        "19%",
        "20%",
        "21%",
        "22%",
        "23%",
        "24%",
        "25%",
        "26%",
        "27%",
        "28%",
        "29%",
        "30%",
        "31%",
        "32%",
        "33%",
        "34%",
        "35%",
        "36%",
        "37%",
        "38%",
        "39%",
        "40%",
        "41%",
        "42%",
        "43%",
        "44%",
        "45%",
        "46%",
        "47%",
        "48%",
        "49%",
        "50%",
        "51%",
        "52%",
        "53%",
        "54%",
        "55%",
        "56%",
        "57%",
        "58%",
        "59%",
        "60%",
        "61%",
        "62%",
        "63%",
        "64%",
        "65%",
        "66%",
        "67%",
        "68%",
        "69%",
        "70%",
        "71%",
        "72%",
        "73%",
        "74%",
        "75%",
        "76%",
        "77%",
        "78%",
        "79%",
        "80%",
        "81%",
        "82%",
        "83%",
        "84%",
        "85%",
        "86%",
        "87%",
        "88%",
        "89%",
        "90%",
        "91%",
        "92%",
        "93%",
        "94%",
        "95%",
        "96%",
        "97%",
        "98%",
        "99%",
        "100%"
        
    ]
    
    comments += comments.flatMap { Array(repeating: $0, count: 2)}
    comments += (10 ... 1000).filter { $0 % 25 == 0}.map { String($0)}
    
    return comments.map { WordObject(token: $0, label: .comment) }.shuffled()
}


func getValues() -> [WordObject] {
    var values: [String] = [
        "1/2", "1/3", "1/4", "1/5", "2/3", "3/4",
        "0,25", "0.25", "0,5", "1,5", "0.5", "1.5", "2.5", "2,5",
        "1", "2", "3", "4", "5", "6", "7", "8", "9"
    ]
    
    values += values.flatMap { Array(repeating: $0, count: 2) }
    values += (10 ... 1000).filter { $0 % 25 == 0 }.map { String($0) }
    
    return values.map { WordObject(token: $0, label: .value) }.shuffled()
}

/// Measures preparing

func getMeasures() -> [WordObject] {
    var measures = ["tbsp", "tbsp.", "tablespoon", "tablespoons", "tb.", "tb", "tbl.", "tbl", "tsp", "tsp.", "teaspoon", "teaspoons", "oz", "oz.", "ounce", "ounces", "c", "c.", "cup", "cups", "qt", "qt.", "quart", "pt", "pt.", "pint", "pints", "ml", "milliliter", "milliliters", "g", "gram", "grams", "kg", "kilo", "kilos", "kilogram", "kilograms", "l", "liter", "liters", "pinch", "pinches", "gal", "gal.", "gallons", "lb.", "lb", "pkg.", "pkg", "package", "packages","can", "cans", "box", "boxes", "stick", "sticks", "bag", "bags"]
    
    measures += ["fluid ounce", "fluid ounces", "fl. oz"].flatMap { Array(repeating: $0, count: 10) }
    return measures.map { WordObject(token: $0, label: .measure) }.shuffled()
}

struct IngredientArray: Decodable {
    let ingredients: [String]
}


/// Save a final JSON file

func save(_ data: Data, fileName: String) {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) else {
        print("Couldn't create json object")
        return
    }
    
    guard let newData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), let string = String(data: newData, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "") else {
        return
    }
    
    let fileManager = FileManager()
    let url = playgroundSharedDataDirectory.appendingPathComponent("\(fileName).json")
    
    do {
        try fileManager.createDirectory(at: playgroundSharedDataDirectory, withIntermediateDirectories: true, attributes: [:])
        try string.write(to: url, atomically: true, encoding: .utf8)
        
        print("New JSON file was saved here: \(url)")
    } catch {
        print(error)
    }
}

/// Sentences generation
///
/// Here we create different types of sentences for each ingredient type

func generateSentences(ingredients: [WordObject], measures: [WordObject], values: [WordObject], comments: [WordObject]) -> Set<[WordObject]> {
    var measureIndex = 0
    var valueIndex = 0
    var commentIndex = 0
    
    var isFirstWay = true
    
    return ingredients.reduce(into: Set<[WordObject]>()) { sentences, ingredient in
        if measureIndex == measures.count {
            measureIndex = 0
        }
        
        if valueIndex == values.count {
            valueIndex = 0
        }
        
        if commentIndex == comments.count {
            commentIndex = 0
        }
        
        let measure = measures[measureIndex]
        let value = values[valueIndex]
        let comment = comments[commentIndex]
        
        measureIndex += 1
        valueIndex += 1
        commentIndex += 1
        
        let token = value.token + measure.token
        let combination = WordObject(token: token, label: .combination)
        
        if isFirstWay {
            sentences.insert([value, ingredient]) // 10 sugar
            sentences.insert([combination, ingredient]) // 10tbsp sugar
        } else {
            sentences.insert([ingredient]) // sugar
        }
        
        let sentenceWithComments = [value, measure, ingredient, comment].shuffled()
        sentences.insert(sentenceWithComments) // 10 tbsp sugar (diced)
        isFirstWay.toggle()
        
    }
}

/// Collocation separation
///
/// Here we should handle a case if an ingredient name or a measure consists few words
///
/// Example:
/// "cold black tea" -> ["cold", "black", "tea"] where each word has the "ingredient" label
/// "fl. oz" -> ["fl.", "oz"] where each word has the "measure" label

func separateCollocations(in senteces: Set<[WordObject]>) -> [SentenceObject] {
    return sentences.compactMap { sentence in
        let sentenceObject = SentenceObject()
        
        sentence.map { word in
            word.token.split(separator: " ").map { part in
                let newToken = String(part)
                
                sentenceObject.tokens.append(newToken)
                sentenceObject.labels.append(word.label)
            }
        }
        
        return sentenceObject
    }
}

// MARK: - Programm

var values = getValues()
var measures = getMeasures()
var ingredients = getIngredients()
var comments = getComments()

print("Ingredient: \(ingredients.count)")
print("Values: \(values.count)")
print("Measures: \(measures.count)")


let sentences = generateSentences(ingredients: ingredients, measures: measures, values: values, comments: comments)
let preparedSentences = separateCollocations(in: sentences)

/// Encode and save a final JSON

let json = FinalJSON(objects: preparedSentences)
let data = try JSONEncoder().encode(json.objects)

save(data, fileName: "orri-data-02")

/// [Run] Launch this programm here
