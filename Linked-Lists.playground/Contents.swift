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
    func reverseListRecursion(node: Node<T>) -> Bool {
        guard !isEmpty else { return false }
//      ensures exit condition for the recursion
        guard let temp = node.next else {
            head = node
            return true
        }
        node.next = nil
        reverseListRecursion(node: temp)
        temp.next = node
        return true
    }
    
    
    func traverse(count: Int? = nil, closure: (Node<T>, Node<T>?) -> Bool) -> Node<T>? {
        var node = head
//        ensure you want to traverse the whole loop
        guard var count = count else {
            while let start = node {
                node = start.next
                if closure(start, nil) { return start }
                
            }
            assert(node == nil)
            return nil
        }
        var previousNode: Node<T>? = nil
        var currentNode = node!
        while(count>1) {
            count -= 1
            previousNode = node
            currentNode = currentNode.next!
        }
        closure(currentNode,previousNode)
        return nil
    }
    
    
    func search(data: T) -> Node<T>? {
        guard !isEmpty else { return nil}
        let node = traverse { (start,_) in
            if (start.data == data) {
                print("Value found")
                return true
            } else { return false }
        }
        
        if let returnValue = node { return returnValue }
        else { return nil }
    }
    
    func printAll() {
        guard !isEmpty else { print("Linked List is Empty"); return }
        traverse { (start , _) in
            print("\(start.data),")
            return false
        }
        
    }

    func modifyNode(data: T, position: Int) -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false }
        guard position < length else {print("Linked List is Empty"); return false}
        traverse(count: position) { (nodeToModify, _) -> Bool in
            nodeToModify.data = data
            return true
        }
        return true
    }
    
    func removeNode(position: Int) -> Bool {
        guard !isEmpty else { print("Linked List is Empty"); return false }
        guard position < length else {print("Error: Cannot access at the mentioned position linked list shorter than requested."); return false}
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
    
    
    
    
    func read(position: Int) {
        guard !isEmpty else { print("Linked List is Empty"); return }
        guard position < length else {print("Error: Cannot add at the mentioned position linked list shorter than requested."); return}
        traverse(count: position) { (currentNode, _) -> Bool in
            print("Value at node \(position): \(currentNode.data)")
            return true
        }
        
        
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
                        return false
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

struct Employee {
    
    
    var firstName: String
    var lastName: String
    var middleName: String
    var age: Int
}

extension Employee: Equatable {
    static func == (lhs: Employee, rhs:Employee) -> Bool {
        return
            lhs.firstName == rhs.firstName &&
            lhs.middleName == rhs.middleName &&
            lhs.lastName == rhs.lastName &&
            lhs.age == rhs.age
    }
}
extension Employee: CustomStringConvertible {
    var description: String {
        return "\(firstName) \(middleName) \(lastName), Age: \(age)"
    }
}

class LinkedListTests: XCTest {
    
    
}
let list = LinkedList<String>()
//// Adding at the head
//list.printAll()
list.addNode(value: "First Node")
list.addNode(value: "Second Node")
list.addNode(value: "Third Node")
list.addNode(value: "Fourth Node")
//list.printAll()
//
list.removeNode(position: 1)
//list.printAll()
//

list.removeNode(position: 2)
//list.printAll()
//
//// Adding at the tail
list.addNode(value: "Fifth Node", addAtHead: false)
list.addNode(value: "Sixth Node", addAtHead: false)
list.addNode(value: "Wild Card", position: 2)
//list.printAll()
//
list.modifyNode(data: "Second Node", position: 2)
list.printAll()
//
list.read(position: 2)
let result = list.search(data: "Sixth Node")
//let listEmployee = LinkedList<Employee>()
//Adding at the head
//listEmployee.addNode(value: Employee(firstName: "Kunal", lastName: "Gandhi", middleName: "Narendra", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Pritesh", lastName: "Shah", middleName: "Jayesh", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Saral", lastName: "Shah", middleName: "Dinesh", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Rakesh", lastName: "Shetty", middleName: "Gopal", age: 34))

////listEmployee.printAll()
//listEmployee.removeNode(position: 1)
////listEmployee.printAll()
//listEmployee.removeNode(position: 2)
////listEmployee.printAll()
////Adding at tail
//listEmployee.addNode(value: Employee(firstName: "Rakesh", lastName: "Shetty", middleName: "Gopal", age: 34), addAtHead: false)
////listEmployee.printAll()
//listEmployee.addNode(value: Employee(firstName: "Sachin", lastName: "Shah", middleName: "Kunal", age: 34), position: 2)
////listEmployee.printAll()
//listEmployee.modifyNode(data: Employee(firstName: "Pritesh", lastName: "Shah", middleName: "Jayesh", age: 35), position: 2)
//listEmployee.printAll()
//listEmployee.read(position: 4)
//let (sucess,value) = listEmployee.search(data: Employee(firstName: "Pritesh", lastName: "Shah", middleName: "Jayesh", age: 35))
//if sucess {
//    print(value!)
//} else {
//    print("Failure")
//}
//listEmployee.reverseListRecursion(node: listEmployee.head!)
//listEmployee.printAll()
