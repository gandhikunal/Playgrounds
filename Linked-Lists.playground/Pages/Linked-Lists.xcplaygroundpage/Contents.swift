//: Playground - noun: a place where people can play
//Time Complexities
//addition, read, modify at head is O(1), at tail is O(1), at a random position O(n)
// deletion at head is O(1) else is O(n)
//traversal is O(n)

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

class LinkedList<T: Equatable> {
    
    var head: Node<T>?
    
    var isEmpty: Bool { return head == nil }
    
    var length = 0
    
//    node needs to be passed in as an argument inorder to be able to reverse recurseively
    private func reverseListRecursion(node: Node<T>) {
        //      ensures exit condition for the recursion
                guard let temp = node.next else {
                    head = node
                    return
                }
                node.next = nil
                reverseListRecursion(node: temp)
                temp.next = node
                return
            }

//  No need to check for empty condition as the function is private only called internally before checking the necessary conditions
    private func traverse(count: Int? = nil, closure: (Node<T>, Node<T>?) -> Bool) -> Node<T>? {
        assert(head != nil)
        var node = head
//      ensure you want to traverse the whole linked list
        guard var count = count else {
            while let start = node {
                node = start.next
                if closure(start, nil) { return start }
            }
            assert(node == nil)
            return nil
        }
//      else travere to the point of desire and return the current and the previous node
        var previousNode: Node<T>? = nil
        var currentNode = node!
        while(count>1) {
            count -= 1
            previousNode = currentNode
            currentNode = currentNode.next!
        }
        closure(currentNode,previousNode)
        return nil
    }
    
//  Wrrapper function to enusre that the list reversal starts from the head node
    func reverseLinkedList() -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false }
        assert(head != nil)
        reverseListRecursion(node: head!)
        print("List reversed successfully.")
        return true
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
        length = length-1
        traverse(count: position) { (currentNode, previousNode) -> Bool in
//      ensures node to be modified is not the first node otherwise modify head pointer and exit
            guard let nodeToModify = previousNode else {
                head = currentNode.next
                return true
            }
            nodeToModify.next = currentNode.next
            return true
        }
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
        length = length+1
        
        guard !isEmpty else { head = newNode; return true }
        
//      ensure requested addition not at a certain position rather at head or tail
        guard let position = position else {
            if addAtHead {
                newNode.next = head
                head = newNode
                return true
            }else {
                traverse { (start, _) -> Bool in
                    if start.next == nil {
                        start.next = newNode
                        return true
                    }
                    return false
                }
                return true
            }
        }
        
//      ensure that the position at which insertion is requeted is not outside bounds
        guard position < length else {
            print("Error: Cannot add at the mentioned position linked list shorter than requested.")
            return false
        }
        traverse(count: position) { (currentNode, previousNode) -> Bool in
            newNode.next = currentNode
            guard let nodeToModify = previousNode else {  head = newNode; return true }
            nodeToModify.next = newNode
            return true
        }
        return true
    }
    
    
}

class LinkedListTests: XCTestCase {
    
    var list: LinkedList<String>!
    
    override func setUp() {
        super.setUp()
        list = LinkedList<String>()
    }
    
    func returnLastNode() -> Node<String> {
        var tempNode = list.head
        while tempNode!.next != nil {
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
        XCTAssert(list.reverseLinkedList() == false)
        XCTAssert(list.read(position: 1) == false)
        XCTAssert(list.removeNode(position: 10) == false)
        XCTAssert(list.modifyNode(data: "Test", position: 10) == false)
        XCTAssert(list.reverseLinkedList() == false)
    }
    
    func testAddNode() {
        list.addNode(value: "Second Node")
        XCTAssert(list.head != nil)
        XCTAssert(list.isEmpty != true)
        XCTAssert(list.length != 0)
        XCTAssert(list.head!.data == "Second Node")
        XCTAssert(list.head!.next == nil)
        
        list.addNode(value: "First Node")
        XCTAssert(list.length == 2)
        XCTAssert(list.head!.data == "First Node")
        XCTAssert(list.head!.next != nil)
        XCTAssert(list.head!.next!.data == "Second Node")
        XCTAssert(list.head!.next!.next == nil)
        
        list.addNode(value: "Fourth Node", addAtHead: false)
        XCTAssert(list.length == 3)
        var node = returnLastNode()
        XCTAssertEqual(list.head!.next!.next!.data,node.data)
        XCTAssert(node.next == nil)
        
        list.addNode(value: "Thrid Node", position: 3)
        var addedNodePosition = list.head!.next!.next!
        XCTAssert(list.length == 4)
        XCTAssert(addedNodePosition.data == "Thrid Node")
        node = returnLastNode()
        XCTAssertEqual(addedNodePosition.next!.data, node.data)
        
        list.addNode(value: "Fifth Node", position: 4)
        addedNodePosition = list.head!.next!.next!.next!
        XCTAssert(list.length == 5)
        XCTAssert(addedNodePosition.data == "Fifth Node")
        node = returnLastNode()
        XCTAssertEqual(addedNodePosition.next!.data, node.data)
    }
    func createTestList() {
        list.addNode(value: "First Node")
        list.addNode(value: "Second Node", addAtHead: false)
        list.addNode(value: "Third Node", addAtHead: false)
        list.addNode(value: "Fourth Node", addAtHead: false)
    }

    func testReverseLinkList() {
        createTestList()
        list.reverseLinkedList()
        XCTAssert(list.head != nil)
        XCTAssert(list.isEmpty != true)
        XCTAssert(list.length == 4)
        XCTAssert(list.head!.data == "Fourth Node")
        let node = returnLastNode()
        XCTAssert(node.data == "First Node")
        XCTAssert(node.next == nil)
        let secondNode = list.head!.next
        XCTAssert(secondNode != nil)
        XCTAssert(secondNode!.data == "Third Node")
        let thridNode = secondNode!.next
        XCTAssert(thridNode != nil)
        XCTAssert(thridNode!.data == "Second Node")
        XCTAssert(thridNode!.next! === node)
        
    }
    
    
    func testSearchNode() {
        createTestList()
        var searchedNode = list.search(data: "First Node")
        XCTAssert(searchedNode != nil)
        XCTAssert(searchedNode!.data == "First Node")
        searchedNode = list.search(data: "Fourth Node")
        XCTAssert(searchedNode != nil)
        XCTAssert(searchedNode!.data == "Fourth Node")
        XCTAssert(searchedNode!.next == nil)
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
        XCTAssert(list.removeNode(position: 3) == true)
        let lastNode = returnLastNode()
        XCTAssert(lastNode.data == "Third Node")
        XCTAssert(lastNode.next == nil)
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
LinkedListTests.defaultTestSuite.run()

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

