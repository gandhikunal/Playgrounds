//: Playground - noun: a place where people can play
//Time Complexities
//  modify, read at head is O(1), at a random position is  O(n)
//addition or deletion is O(n)
// search is O(n)
//traversal is O(n)
import Foundation
class Node <T: Equatable> {
    var data :T
    var next: Node?
    init(data: T, next: Node?=nil) {
        self.data = data
        self.next = next
    }
}

class CircularLinkedList <T: Equatable> {
    
    var head: Node<T>?
    var isEmpty: Bool {
        get {
            if head == nil { return true }
            else { return false }
        }
    }
    var lenght: Int = 0
    
    func search(data: T) -> (Bool,Int?) {
        var start = head
        var count = 0
        while start!.next !== head {
            count = +1
            if start!.data == data {
                return(true,count+1)
            }
            start = start!.next
        }
        if(start!.data == data) {
            return(true,lenght)
        }
        return (false,nil)
    }
    
    private func traverseToNode(count: inout Int) -> (Node<T>?,Node<T>?) {
        var currentNode = head
        var previousNode: Node<T>? = nil
        while(count>1){
            count = count-1
            previousNode = currentNode
            currentNode = currentNode!.next
        }
        return (previousNode,currentNode)
    }
    
    func modifyNode(data: T, position: Int) {
        if position > lenght {
            print("Error: Trying to modify elemt out of range")
        } else {
            
            var count = position
            var currentNode: Node<T>?
            (_, currentNode) = traverseToNode(count: &count)
            currentNode!.data = data
        }
    }
    
    func printAll() {
        if isEmpty {
            print("Linked List is empty.")
        } else {
            var currentNode = head
            repeat {
                print("\(currentNode!.data),")
                currentNode = currentNode?.next
            }while(currentNode?.next !== head)
            print(currentNode!.data)
            
        }
    }
    
    
    func read(position: Int) {
        
        if isEmpty {
            print("Linked List is empty.")
        } else if (position > lenght) {
            print("Accessing element outside range.")
        } else {
            var count = position
            var currentNode: Node<T>?
            (_, currentNode) = traverseToNode(count: &count)
            print("Value at node \(position): \(currentNode!.data)")
        }
        
    }
    
    func removeNode(position: Int) {
        if isEmpty {
            print("Linked List is empty.")
        } else if position > lenght {
            print("Position out of range.")
        } else {
            var count = position
            let (previousNode, currentNode) = traverseToNode(count: &count)
            if previousNode == nil {
                var temp = currentNode!.next
                while(temp!.next !== head){
                    temp = temp!.next
                }
                head = currentNode?.next
                temp!.next = head
            } else if currentNode!.next === head {
                previousNode!.next = head
            }
            else {
                previousNode?.next = currentNode?.next
            }
            lenght = lenght-1
        }
    }
    
    func addNode(value: T, position:Int?=nil, addAtHead:Bool=true) {
        let newNode = Node(data: value)
        lenght = lenght+1
        if isEmpty {
            head = newNode
            newNode.next = head
            return
        } else {
            if position == nil {
                if addAtHead {
                    var temp = head
                    while (temp!.next !== head) {
                        temp = temp!.next
                    }
                    newNode.next = head
                    head = newNode
                    temp!.next = head
                    
                }else {
                    var temp = head
                    while (temp!.next !== head) {
                        temp = temp!.next
                    }
                    temp!.next = newNode
                    newNode.next = head
                }
                
            } else {
                if (position! > lenght) {
                    print("Error: Cannot add at the mentioned position linked list shorter than requested.")
                    return
                }
                var count = position!
                let (previousNode, currentNode) = traverseToNode(count: &count)
                if previousNode == nil {
                    var temp = currentNode!.next        
                    while(temp!.next !== head!){
                        temp = temp!.next
                    }
                    newNode.next = head
                    temp?.next = newNode
                    head = newNode
                } else if currentNode!.next === head {
                    currentNode!.next = newNode
                    newNode.next = head
                }
                else {
                    newNode.next = currentNode
                    previousNode!.next = newNode
                }
                return
            }
        }
        
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

let list = CircularLinkedList<String>()
list.addNode(value: "Kunal")
// Adding at the head
list.addNode(value: "First Node")
list.addNode(value: "Second Node")
list.addNode(value: "Third Node")
list.addNode(value: "Fourth Node")
//list.printAll()
////
list.removeNode(position: 1)
//list.printAll()
////
list.removeNode(position: 4)
//list.printAll()
////
////// Adding at the tail
list.addNode(value: "Fifth Node", addAtHead: false)
list.addNode(value: "Sixth Node", addAtHead: false)
list.addNode(value: "Wild Card", position: 1)
list.addNode(value: "Wild Card End", position: 6)
//list.printAll()
////
list.modifyNode(data: "Second Node", position: 1)
list.printAll()
////
list.read(position: 10)
let (sucess,value) = list.search(data: "Second Node")
if sucess {
    print(value!)
} else {
    print("Failure")
}
//let listEmployee = LinkedList<Employee>()
////Adding at the head
//listEmployee.addNode(value: Employee(firstName: "Kunal", lastName: "Gandhi", middleName: "Narendra", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Pritesh", lastName: "Shah", middleName: "Jayesh", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Saral", lastName: "Shah", middleName: "Dinesh", age: 34))
//listEmployee.addNode(value: Employee(firstName: "Rakesh", lastName: "Shetty", middleName: "Gopal", age: 34))
//
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
////let (sucess,value) = listEmployee.search(data: Employee(firstName: "Pritesh", lastName: "Shah", middleName: "Jayesh", age: 35))
////if sucess {
////    print(value!)
////} else {
////    print("Failure")
////}
//listEmployee.reverseListRecursion(node: listEmployee.head!)
//listEmployee.printAll()
