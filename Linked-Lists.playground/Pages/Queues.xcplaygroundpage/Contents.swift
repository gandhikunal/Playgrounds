
import Foundation
import XCTest

class Node<T: Equatable> {
    var data: T
    var next: Node<T>?
    init(data: T, next: Node? = nil) {
        self.data = data
        self.next = next
    }
}

class Queue<T: Equatable> {
    
    var front: Node<T>?
    var rear: Node<T>?
    var isEmpty: Bool {
        return (front == nil)
    }
    var length = 0
    
    func enqueue(data: T) -> Bool {
        
        let newNode = Node(data: data)
        length += 1
        guard !isEmpty else { front = newNode; rear = newNode; return true }
        guard let rearPointer = rear else { return false }
//        newNode.next = rearPointer
        rearPointer.next = newNode
        rear = newNode
        return true
    }
    
    func dequeue() -> Node<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = front else { return nil }
        length -= 1
        guard let _ = returnNode.next else { rear = nil; front = nil; return returnNode }
        front = returnNode.next
        return returnNode
        
    }
    
    func frontNode() -> Node<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = front else { return nil }
        return returnNode
    }
    
    func rearNode() -> Node<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = rear else { return nil }
        return returnNode
    }
    
}

class QueueTests: XCTestCase {
    
    var queue: Queue<String>!
    
    override func setUp() {
        super.setUp()
        queue = Queue<String>()
    }
    
    
    func testEmptyQueue() {
        XCTAssert(queue.front == nil)
        XCTAssert(queue.rear == nil)
        XCTAssert(queue.isEmpty == true)
        XCTAssert(queue.length == 0)
        XCTAssert(queue.frontNode() == nil)
        XCTAssert(queue.rearNode() == nil)
        XCTAssert(queue.dequeue() == nil)
    }
    
    func testQueue() {
        
        queue.enqueue(data: "First Node")
        XCTAssert(queue.front != nil)
        XCTAssert(queue.rear != nil)
        XCTAssert(queue.isEmpty == false)
        XCTAssert(queue.length == 1)
        queue.enqueue(data: "Second Node")
        queue.enqueue(data: "Third Node")
        queue.enqueue(data: "Fourth Node")
        queue.enqueue(data: "Fifth Node")
        XCTAssert(queue.front != nil)
        XCTAssert(queue.rear != nil)
        XCTAssert(queue.length == 5)
        XCTAssert(queue.frontNode()?.data == "First Node")
        XCTAssert(queue.rearNode()?.data == "Fifth Node")
        XCTAssert(queue.dequeue()?.data == "First Node")
        XCTAssert(queue.dequeue()?.data == "Second Node")
        XCTAssert(queue.dequeue()?.data == "Third Node")
        XCTAssert(queue.dequeue()?.data == "Fourth Node")
        XCTAssert(queue.dequeue()?.data == "Fifth Node")
        XCTAssert(queue.front == nil)
        XCTAssert(queue.rear == nil)
        XCTAssert(queue.isEmpty == true)
        XCTAssert(queue.length == 0)
        
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
QueueTests.defaultTestSuite.run()

