import Foundation

public func tt_suffixNumber(number: Double, zeroText: String?) -> String {
    var num: Double = number
    let sign = ((num < 0) ? "-" : "" )

    num = abs(num)

    if (num < 1000.0){
        if num > 0 || zeroText == nil {
            return "\(sign)\(Int(num))"
        } else {
            return zeroText ?? "0"
        }
    }

    let exp: Int = Int(log10(num) / 3.0 ); //log10(1000));

    let units: [String] = ["K","M","G","T","P","E"]

    let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10

    return "\(sign)\(roundedNum)\(units[exp-1])"
}
