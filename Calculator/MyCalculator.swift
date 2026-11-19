//
//  MyCalculator.swift
//  Calculator
//
//  Created by SOFIA VERDUGO on 18/11/26.
//

import SwiftUI

struct MyCalculator: View {
    @State private var screen = ""
    @State private var operationText = ""
    @State private var num1 = 0.0
    @State private var operation = ""
    @State private var startNew = true
    let rows = [
        ["DEL","C"],
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text(operationText)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 30, alignment: .trailing)
            
            Text(screen.isEmpty ? "0" : screen)
                .font(.system(size: 64, weight: .light))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { btn in
                        BotonCalc(btn: btn) {
                            click(btn)
                        }
                    }
                }
            }
    }
    .padding()
    }
    
    func click(_ btn: String) {
        switch btn {
            case "C":
                clickClearAll()
            case "DEL":
                screen = String(screen.dropLast())
            case "=":
                clickEqual()
            case "+", "-", "*", "/":
                clickOperation(btn)
            default:
                clickDigit(btn)
        }
    }
    
    func clickDigit(_ digit: String) {
        if digit == "." && screen.contains("."){
            return
        } else if startNew {
            screen = digit
            startNew = false
        }
        else {
            screen += digit
        }
    }
    
    func clickOperation(_ op: String) {
        if !op.isEmpty {
                clickEqual()
            }
        guard let number = Double(screen) else { return }
        num1 = number
        operation = op
        operationText = screen + " " + op
        screen = ""
    }
    
    func clickEqual() {
        guard let number2 = Double(screen), !operation.isEmpty else { return }
        var result = ""
        switch operation {
            case "+": result = format(num1 + number2)
            case "-": result = format(num1 - number2)
            case "*": result = format(num1 * number2)
            case "/":
                if number2 == 0 {
                    result = "Error"
                }
                else {
                    result = format(num1 / number2)
                }
            default: break
        }
        startNew = true
        screen = result
        operationText = ""
        operation = ""
    }
    
    func clickClearAll() {
        screen = ""
        operationText = ""
        num1 = 0
        operation = ""
    }
    
    func format(_ x: Double) -> String {
        if x == x.rounded() && abs(x) < 1e15 {
        return String(Int(x))
        }
        return String(x)
    }
}


struct BotonCalc: View {
    let btn: String
    let action: () -> Void
    var isNumber: Bool {
        Int(btn) != nil || btn == "."
    }
    
    var bgColor: Color {
        if isNumber {
            return .gray.opacity(0.2)
        } else if btn == "C" {
            return .red
        } else {
            return .orange
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(btn)
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(bgColor)
                .foregroundStyle(isNumber ? Color.primary : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MyCalculator()
}
