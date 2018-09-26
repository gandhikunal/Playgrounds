
import Foundation
import XCTest

class Node<T: Equatable> {
    var data: T
    var next: Node<T>?
    init(data: T, next: Node<T>? = nil) {
        self.data = data
        self.next = next
    }
}

class Stack<T: Equatable> {
    
    var top: Node<T>?
    
    var isEmpty: Bool { return top == nil }
    
    var length = 0
    
    func stackIsEmpty() -> Bool {
        guard !isEmpty else { return true }
        return false
    }
    
    func peek() -> Node<T>? {
        guard !isEmpty else { print("Stack is Empty"); return nil }
        if let nodeToPeek = top {
            return nodeToPeek
        }
        return nil
    }
    
    func pop() -> Bool {
        guard !isEmpty else { print("Stack is Empty"); return false }
        length -= 1
        if let nodeRemove = top {
            top = nodeRemove.next
            return true
        }
        return false
    }
    
    func push(value: T) -> Bool {
        let newNode = Node(data: value)
        length = length+1
        guard let topNode = top else { top = newNode; return true }
        newNode.next = topNode
        top = newNode
        return true
    }
}


class ExpressionCoverter {
    let expToConvert: String
    let stackHolder = Stack<Character>()
    let openingParanthesis:[Character] = ["{","(","["]
    let closingParanthesis:[Character] = ["}",")","]"]
    
    func validateExp() -> Bool {
        for (_, element) in expToConvert.enumerated() {
            if (openingParanthesis.contains(element)) {
                stackHolder.push(value: element)
            } else if (closingParanthesis.contains(element)) {
                if(stackHolder.isEmpty) {
                    return false
                }
                switch element {
                case "}":
                    if (stackHolder.peek()?.data == "{") {
                        stackHolder.pop()
                    } else {
                        return false
                    }
                case ")":
                    if (stackHolder.peek()?.data == "(") {
                        stackHolder.pop()
                    } else {
                        return false
                    }
                case "]":
                    if (stackHolder.peek()?.data == "[") {
                        stackHolder.pop()
                    } else {
                        return false
                    }
                default:
                    continue
                }
            }
        }
        if stackHolder.isEmpty {
            return true
        } else {
            return false
        }
        
    }
    
    let operators:[Character] = ["/","+","-","*","^"]
    var convertedExp = ""
    
    func convertExpPostfix() -> String? {
        for (_, element) in expToConvert.enumerated()  {
            if (("a" >= element) && (element <= "z")) {
                convertedExp.append(element)
            }
            else if(openingParanthesis.contains(element)) {
                stackHolder.push(value: element)
            } else if (closingParanthesis.contains(element)) {
                switch element {
                case "}":
                    while (!stackHolder.isEmpty && stackHolder.peek()?.data != "{") {
                        convertedExp.append(stackHolder.top!.data)
                        stackHolder.pop()
                    }
                    if (stackHolder.peek()?.data != "{") {
                        return nil
                    } else {
                        stackHolder.pop()
                    }
                case ")":
                    while (!stackHolder.isEmpty && stackHolder.peek()?.data != "(") {
                        convertedExp.append(stackHolder.top!.data)
                        stackHolder.pop()
                    }
                    if (stackHolder.peek()?.data != "(") {
                        return nil
                    }else {
                        stackHolder.pop()
                    }
                case "]":
                    while (!stackHolder.isEmpty && stackHolder.peek()?.data != "[") {
                        convertedExp.append(stackHolder.top!.data)
                        stackHolder.pop()
                    }
                    if (stackHolder.peek()?.data != "[") {
                        return nil
                    }else {
                        stackHolder.pop()
                    }
                default:
                    continue
                }
                
            } else {
                while (!stackHolder.stackIsEmpty() && prec(element: element) <= prec(element: stackHolder.top!.data)) {
                    convertedExp.append(stackHolder.top!.data)
                    stackHolder.pop()
                }
                stackHolder.push(value: element)
            }
        }
        
        while (!stackHolder.isEmpty) {
            convertedExp.append(stackHolder.top!.data)
        }
        return convertedExp
    }
    
    func prec(element: Character) -> Int {
        switch element {
        case "+":
            return 1
        case "-":
            return 1
        case "*":
            return 2
        case "/":
            return 2
        case "^":
            return 3
        default:
            return 0
        }
    }
    init(expToConvert: String) {
        self.expToConvert = expToConvert
    }
}

class StackTests: XCTestCase {
    
    var stack: Stack<String>!
    
    override func setUp() {
        super.setUp()
        stack = Stack<String>()
    }
    
    
    func testEmptyStack() {
        XCTAssert(stack.top == nil)
        XCTAssert(stack.stackIsEmpty() == true)
        XCTAssert(stack.pop() == false)
        XCTAssert(stack.peek() == nil)
        XCTAssert(stack.length == 0)
    }
    
    func testStack() {
        
        stack.push(value: "First Value")
        XCTAssert(stack.length == 1)
        XCTAssert(stack.stackIsEmpty() == false)
        XCTAssert(stack.top != nil)
        XCTAssert(stack.top!.data == "First Value")
        stack.push(value: "Second Value")
        stack.push(value: "Third Value")
        stack.push(value: "Fourth Value")
        XCTAssert(stack.length == 4)
        XCTAssert(stack.stackIsEmpty() == false)
        XCTAssert(stack.top != nil)
        XCTAssert(stack.peek()!.data == "Fourth Value")
        let lastNode = stack.top!.next!.next!.next
        XCTAssert(lastNode!.data == "First Value")
        XCTAssert(lastNode!.next == nil)
        stack.pop()
        XCTAssert(stack.length == 3)
        XCTAssert(stack.peek()!.data == "Third Value")
        
    }
    
    
}

class TestObserver: NSObject, XCTestObservation {
    
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
//StackTests.defaultTestSuite.run()
