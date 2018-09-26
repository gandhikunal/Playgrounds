import Foundation
import XCTest

class Node<T: Equatable> {
    var data: T
    var next: Node?
    init(data: T, next: Node? = nil) {
        self.data = data
        self.next = next
    }
}

class CircularLinkedList<T: Equatable> {
    
    var head: Node<T>?
    
    var isEmpty: Bool { return head == nil }
    
    var length = 0
    
    
    //  No need to check for empty condition as the function is private only called internally before checking the necessary conditions
    private func traverse(count: Int? = nil, closure: (Node<T>, Node<T>?) -> Bool) -> Node<T>? {
        assert(head != nil)
        var node = head!
        //      ensure you want to traverse the whole linked list
        guard var count = count else {
            for _ in 1...length {
                if closure(node, nil) { return node }
                node = node.next!
            }
            return nil
        }
        //      else travere to the point of desire and return the current and the previous node
        var previousNode: Node<T>? = nil
        var currentNode = node
        while(count > 1) {
            count -= 1
            previousNode = currentNode
            currentNode = currentNode.next!
        }
        closure(currentNode,previousNode)
        return nil
    }
    
    
    func search(data: T) -> Node<T>? {
        guard !isEmpty else { print("Linked List is Empty"); return nil}
        let node = traverse { (start,_) in
            if (start.data == data) {
                print("Value found")
                return true
            } else {  return false }
        }
        
        if let returnValue = node { return returnValue }
        else { print("Value Not Found."); return nil }
    }
    
    func printAll() -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false}
        traverse { (start , _) in
            print("\(start.data),")
            return false
        }
        return true
    }
    
    func modifyNode(data: T, position: Int) -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false }
        guard position <= length else { print("Error: Cannot access at the mentioned position linked list shorter than requested."); return false}
        traverse(count: position) { (nodeToModify, _) -> Bool in
            nodeToModify.data = data
            return true
        }
        return true
    }
    
    func removeNode(position: Int) -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false }
        guard position <= length else { print("Error: Cannot access at the mentioned position linked list shorter than requested."); return false}
        
        traverse(count: position) { (currentNode, previousNode) -> Bool in
            //      ensures node to be modified is not the first node otherwise modify head pointer, last element and exit
            guard let nodeToModify = previousNode else {
//              traversing to the last node to build link pointer to new head
                var node = head!
                for _ in 1...length-1 {
                    node = node.next!
                }
                head = currentNode.next
                node.next = head
                return true
            }
            nodeToModify.next = currentNode.next
            return true
        }
        length = length-1
        return true
    }
    
    
    
    
    func read(position: Int) -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false}
        guard position <= length else { print("Error: Cannot access at the mentioned position linked list shorter than requested."); return false}
        traverse(count: position) { (currentNode, _) -> Bool in
            print("Value at node \(position): \(currentNode.data)")
            return true
        }
        return true
    }
    
    func addNode(value: T, position:Int?=nil, addAtHead:Bool=true) -> Bool {
        let newNode = Node(data: value)
        guard !isEmpty else { let newNode = Node(data: value, next: head)
            head = newNode
            newNode.next = head
            length = length+1
            return true
        }
        
        //      ensure requested addition not at a certain position rather at head or tail
        guard let position = position else {
            newNode.next = head
            traverse(count: length) { (currentNode, previousNode) in
                if addAtHead {
                    head = newNode
                    currentNode.next = head
                } else {
                    currentNode.next = newNode
                }
                return true
            }
            length = length+1
            return true
        }
        
        //      ensure that the position at which insertion is requeted is not outside bounds
        guard position <= length else {
            print("Error: Cannot add at the mentioned position linked list shorter than requested.")
            return false
        }
        traverse(count: position) { (currentNode, previousNode) -> Bool in
            newNode.next = currentNode
            guard let nodeToModify = previousNode else {
                var node = head!
//              traversing to the last node to build link pointer to new head
                for _ in 1...length-1 {
                    node = node.next!
                }
                head = newNode;
                node.next = head
                return true

            }
            nodeToModify.next = newNode
            return true
        }
        length = length+1
        return true
    }
    
}

class CircularLinkedListTests: XCTestCase {
    
    var list: CircularLinkedList<String>!
    
    override func setUp() {
        super.setUp()
        list = CircularLinkedList<String>()
    }
    
    func returnLastNode() -> Node<String> {
        var tempNode = list.head
        for _ in 1...list.length-1 {
            tempNode = tempNode!.next
        }
        return tempNode!
    }
    func testEmptyList() {
        XCTAssert(list.head == nil)
        XCTAssert(list.isEmpty == true)
        XCTAssert(list.length == 0)
        XCTAssert(list.printAll() == false)
        XCTAssert(list.search(data: "Test") == nil)
        XCTAssert(list.read(position: 1) == false)
        XCTAssert(list.removeNode(position: 10) == false)
        XCTAssert(list.modifyNode(data: "Test", position: 10) == false)
    }
    
    func testAddNode() {
        list.addNode(value: "Second Node")
        XCTAssert(list.head != nil)
        XCTAssert(list.isEmpty != true)
        XCTAssert(list.length != 0)
        XCTAssert(list.head!.data == "Second Node")
        XCTAssert(list.head!.next === list.head)
        
        list.addNode(value: "First Node")
        XCTAssert(list.length == 2)
        XCTAssert(list.head!.data == "First Node")
        XCTAssert(list.head!.next != nil)
        XCTAssert(list.head!.next!.data == "Second Node")
        XCTAssert(list.head!.next!.next === list.head)
        
        list.addNode(value: "Fourth Node", addAtHead: false)
        XCTAssert(list.length == 3)
        var node = returnLastNode()
        XCTAssertEqual(list.head!.next!.next!.data,node.data)
        XCTAssert(node.next === list.head)
        
        list.addNode(value: "Thrid Node", position: 3)
        var addedNodePosition = list.head!.next!.next!
        XCTAssert(list.length == 4)
        XCTAssert(addedNodePosition.data == "Thrid Node")
        node = returnLastNode()
        XCTAssertEqual(addedNodePosition.next!.data, node.data)
        XCTAssert(node.next === list.head)
        
        list.addNode(value: "Fifth Node", position: 4)
        addedNodePosition = list.head!.next!.next!.next!
        XCTAssert(list.head != nil)
        XCTAssert(list.isEmpty != true)
        XCTAssert(list.length == 5)
        XCTAssert(addedNodePosition.data == "Fifth Node")
        node = returnLastNode()
        XCTAssertEqual(addedNodePosition.next!.data, node.data)
        XCTAssert(node.next === list.head)
    }
    func createTestList() {
        list.addNode(value: "First Node")
        list.addNode(value: "Second Node", addAtHead: false)
        list.addNode(value: "Third Node", addAtHead: false)
        list.addNode(value: "Fourth Node", addAtHead: false)
    }
    
    func testSearchNode() {
        createTestList()
        var searchedNode = list.search(data: "First Node")
        XCTAssert(searchedNode != nil)
        XCTAssert(searchedNode!.data == "First Node")
        searchedNode = list.search(data: "Fourth Node")
        XCTAssert(searchedNode != nil)
        XCTAssert(searchedNode!.data == "Fourth Node")
        XCTAssert(searchedNode!.next === list.head)
        searchedNode = list.search(data: "Random String")
        XCTAssert(searchedNode == nil)
    }
    
    func testReadNode() {
        createTestList()
        XCTAssert(list.read(position: 10) == false)
        XCTAssert(list.read(position: 1) == true)
        XCTAssert(list.read(position: 4) == true)
    }
    
    func testModifyNode() {
        createTestList()
        list.printAll()
        XCTAssert(list.length == 4)
        XCTAssert(list.modifyNode(data: "Random", position: 10) == false)
        XCTAssert(list.modifyNode(data: "First Node Modified", position: 1) == true)
        XCTAssert(list.head!.data == "First Node Modified")
        XCTAssert(list.modifyNode(data: "Fourth Node Modified", position: 4) == true)
        let lastNode = returnLastNode()
        XCTAssert(lastNode.data == "Fourth Node Modified")
    }
    
    func testRemoveNode() {
        createTestList()
        XCTAssert(list.removeNode(position: 6) == false)
        XCTAssert(list.removeNode(position: 1) == true)
        XCTAssert(list.length == 3)
        XCTAssert(list.head != nil)
        XCTAssert(list.head!.data == "Second Node")
        var lastNode = returnLastNode()
        print(lastNode.next!.data)
        XCTAssert(lastNode.next === list.head)
        XCTAssert(list.removeNode(position: 3) == true)
        lastNode = returnLastNode()
        XCTAssert(lastNode.data == "Third Node")
        XCTAssert(lastNode.next === list.head)
        XCTAssert(list.length == 2)
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
CircularLinkedListTests.defaultTestSuite.run()
