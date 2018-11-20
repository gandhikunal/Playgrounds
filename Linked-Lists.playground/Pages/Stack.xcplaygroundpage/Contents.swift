
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
StackTests.defaultTestSuite.run()

//struct Employee {
//
//
//    var firstName: String
//    var lastName: String
//    var middleName: String
//    var age: Int
//}
//
//extension Employee: Equatable {
//    static func == (lhs: Employee, rhs:Employee) -> Bool {
//        return
//            lhs.firstName == rhs.firstName &&
//            lhs.middleName == rhs.middleName &&
//            lhs.lastName == rhs.lastName &&
//            lhs.age == rhs.age
//    }
//}
//extension Employee: CustomStringConvertible {
//    var description: String {
//        return "\(firstName) \(middleName) \(lastName), Age: \(age)"
//    }
//}

