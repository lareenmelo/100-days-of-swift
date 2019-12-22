
import UIKit
// We can loop through arrays
let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}
/* But, it doesn't mean it's an array, because you still can't access indivual items like this */
//print(name[3])

/* if you want to read the 4 element of a string, then you're gonna have to start at the beggining until you find the one
 you've been looking for. */

let letter = name[name.index(name.startIndex, offsetBy: 3)]

// extension of that above.
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

// better to use .isempty instead of .count with string at least because of how strings work
// you would have to iterate all over the string's letter

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

// DELETE A PREFIX IF IT EXISTS
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
// DELETE A SUFFIX IF IT EXISTS
extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

let weather = "It's going to be cold"
//print(weather.capitalized) removed apparently
extension String {
    var capitalized: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

weather.capitalized

/* character type are single-letters strings, so uppercased it's a method on characters and not string.
 BUT PLOTTWIST, UPPERCASED ON CHARS RETURN STRING. Due to special languages like german where a character uppercased could be
 2 characters. */

// ATTRIBUTED STRINGS
/* 1. plain string
   2. dictionary of the attributes
   3. create & assign the attributted string
 */

let string = "This will work"
let attributes: [NSAttributedString.Key : Any] = [
    .foregroundColor : UIColor.white,
    .backgroundColor : UIColor.red,
    .font : UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)
//let attributedString = NSMutableAttributedString(string: string)
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
