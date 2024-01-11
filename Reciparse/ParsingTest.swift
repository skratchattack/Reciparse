//
//  ParsingTest.swift
//  Reciparse
//
//  Created by Orri Arnórsson on 4.1.2024.
//

import CoreML
import SwiftUI

struct ParsingTest: View {
    private var exampleRecipeOneString = "40 g all purpose flour\n115 g almond flour\n135 g icing sugar\n7 g egg white powder\n70 g granulated sugar (US)\n190 g egg whites\n100 g dark chocolate 70% finely crushed"
    private var slippurinn = [
    "500 ml milk",
    "500 ml warm water",
    "3 tablespoons active dried yeast",
    "500 g sugar",
    "500 g plain all-purpose flour",
    "1.5 kg rye flour",
    "3 tablespoons sea salt"
    ]
    
    
    private var exampleRecipe2 = [
    "40 g all purpose flour",
    "115 g almond flour",
    "135 g icing sugar",
    "7 g egg white powder",
    "70 g granulated sugar (US)",
    "190 g egg whites",
    "100 g dark chocolate 70% finely crushed"
    ]
    private var exampleRecipe = [
        "100 g white chocolate melted",
        "200 g cream",
        "10 g gelatin bloomed"
    ]
    @State private var parsedIngredients: [ParsedIngredient] = []

    var body: some View {
        VStack(alignment: .center) {
            List(parsedIngredients, id: \.self) { ingredient in
                HStack(alignment: .top) {
                        Text("\(ingredient.value)\(ingredient.measure) \(ingredient.combination)").fontWeight(.bold)
                        .frame(width: 80, alignment: .leading)
                    VStack(alignment: .leading) {
                            Text("\(ingredient.ingredient)".capitalized)
                            Text("\(ingredient.comment)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .italic()
                        }
                    }
                }
            .onAppear {
                parseIngredients()
            }
        }
        .padding()
    }

    struct ParsedIngredient: Hashable {
        var combination: String
        var ingredient: String
        var measure: String
        var comment: String
        var value: String
    }
    
    func parseIngredients() {
            for ingredientString in slippurinn {
                let parsedIngredient = parseIngredientLine(ingredientString: ingredientString)
                parsedIngredients.append(parsedIngredient)
            }
        }

    func parseIngredientLine(ingredientString: String) -> ParsedIngredient {

        do {
            let config = MLModelConfiguration()
            let model = try Reciparser(configuration: config)
            
            if let prediction = try? model.prediction(text: ingredientString) {
                let outputTags = prediction.labels // shows the tags of each word
                var tagIndex = 0
                
                let components = ingredientString.components(separatedBy: " ")
                print(components)
                var combinationText = ""
                var ingredientText = ""
                var measureText = ""
                var commentText = ""
                var valueText = ""
                
                for component in components {
                    guard tagIndex < outputTags.count else {
                        print("Tag index out of bounds: \(tagIndex)")
                        break
                    }
                    
                    let tag = outputTags[tagIndex]
                    print("Tag: \(tag), Component: \(component)")
                    
                    switch tag {
                    case "combination":
                        combinationText += component + " "
                    case "ingredient":
                        ingredientText += component + " "
                    case "measure":
                        measureText += component + " "
                    case "comment":
                        commentText += component + " "
                    case "value":
                        valueText += component + " "
                    default:
                        break
                    }
                    
                    tagIndex += 1
                }
                
                return ParsedIngredient(
                    combination: combinationText.trimmingCharacters(in: .whitespaces),
                    ingredient: ingredientText.trimmingCharacters(in: .whitespaces),
                    measure: measureText.trimmingCharacters(in: .whitespaces),
                    comment: commentText.trimmingCharacters(in: .whitespaces),
                    value: valueText.trimmingCharacters(in: .whitespaces)
                )
            }
            
            return ParsedIngredient(combination: "", ingredient: "", measure: "", comment: "", value: "")
        } catch {
            print("Something went wrong - \(error.localizedDescription)")
            return ParsedIngredient(combination: "", ingredient: "", measure: "", comment: "", value: "")
        }
    }
}

struct ParsingTest_Previews: PreviewProvider {
    static var previews: some View {
        ParsingTest()
    }
}
