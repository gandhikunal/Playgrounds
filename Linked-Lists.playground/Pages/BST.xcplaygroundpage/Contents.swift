
import Foundation
import XCTest

class NodeQueue<T> {
    var data: T
    var next: NodeQueue<T>?
    init(data: T, next: NodeQueue? = nil) {
        self.data = data
        self.next = next
    }
}

class Queue<T> {
    
    var front: NodeQueue<T>?
    var rear: NodeQueue<T>?
    var isEmpty: Bool {
        return (front == nil)
    }
    var length = 0
    
    func enqueue(data: T) -> Bool {
        
        let newNode = NodeQueue(data: data)
        length += 1
        guard !isEmpty else { front = newNode; rear = newNode; return true }
        guard let rearPointer = rear else { return false }
        rearPointer.next = newNode
        rear = newNode
        return true
    }
    
    func dequeue() -> NodeQueue<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = front else { return nil }
        length -= 1
        guard let _ = returnNode.next else { rear = nil; front = nil; return returnNode }
        front = returnNode.next
        return returnNode
        
    }
    
    func frontNode() -> NodeQueue<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = front else { return nil }
        return returnNode
    }
    
    func rearNode() -> NodeQueue<T>? {
        guard !isEmpty else { print("Error: Queue is empty."); return nil }
        guard let returnNode = rear else { return nil }
        return returnNode
    }
    
}

class Node<T: Comparable> {
    var data: T
    var leftChild: Node<T>?
    var rightChild: Node<T>?
    
    init(data: T, leftChild: Node<T>? = nil, rightChild: Node<T>? = nil) {
        self.data = data
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

class BST<T: Comparable> {
    
    var root: Node<T>?
    
    private func arrayToBalancedBST(valueArray: Array<T>, start: Int, end: Int) -> Node<T>? {
        if start > end {
            return nil
        }
        let midPoint = (start+end)/2
//        balancedTree.addChild(data: valueArray[midPoint], root: balancedTree.root)
        let rootNode = Node(data: valueArray[midPoint])
        rootNode.leftChild = arrayToBalancedBST(valueArray: valueArray, start: start, end: midPoint-1)
        rootNode.rightChild = arrayToBalancedBST(valueArray: valueArray, start: midPoint+1, end: end)
        return rootNode
    }
    
    func transformTreeBalanced(treeToTransform: BST<T>) -> BST<T> {
        guard let rootNode = treeToTransform.root else { print("Tree to transform is empty"); return treeToTransform }
        var sortedArray = Array<T>()
        preOrderTraversal(root: rootNode, traversedArray: &sortedArray) { (data, collectionArray) in
            collectionArray.append(data)
        }
        let balancedTree = BST<T>()
        let arrayEnd = sortedArray.count-1
        balancedTree.root = arrayToBalancedBST(valueArray: sortedArray, start: 0, end: arrayEnd)
        return balancedTree
    }
    
    private func isBalancedBST(root: Node<T>?) -> Bool {
        guard let rootNode = root else { return true }
        let lftreeHt = getHeight(root: rootNode.leftChild)
        let rgtreeHt = getHeight(root: rootNode.rightChild)
        if (abs(lftreeHt-rgtreeHt) <= 1) {
            return (isBalancedBST(root: rootNode.leftChild) && isBalancedBST(root: rootNode.rightChild))
        } else {
            return false
        }
    }
//  wrapper function for isBalancedBST to implicitly pass root node.
    func isTreeBalanced() -> Bool {
        guard let rootNode = root else { print("Tree is empty"); return true }
        return isBalancedBST(root: rootNode)
    }
    
    func inorderSucessor(data: T) -> Node<T>? {
        guard let rootNode = root else { print("Tree is empty"); return nil}
        guard let searchedNode = searchTree(data: data, root: rootNode) else { print("Node does not exist"); return nil }
        guard let searchedRightChild = searchedNode.rightChild else {
            var sucessor: Node<T>?
            var ancestor = rootNode
            while (ancestor !== searchedNode) {
                if (searchedNode.data < ancestor.data) {
                    sucessor = ancestor
                    ancestor = ancestor.leftChild!
                } else {
                    ancestor = ancestor.rightChild!
                }
            }
            return sucessor
        }
        return findMin(root: searchedRightChild)
    }
    
    func inorderPrdecessor(data: T) -> Node<T>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        guard let searchedNode = searchTree(data: data, root: rootNode) else { print("Node does not exist"); return nil }
        guard let searchedLeftChild = searchedNode.leftChild else {
            var predecessor: Node<T>?
            var ancestor = rootNode
            while (ancestor !== searchedNode) {
                if (searchedNode.data < ancestor.data) {
                    ancestor = ancestor.leftChild!
                } else {
                    predecessor = ancestor
                    ancestor = ancestor.rightChild!
                }
            }
            return predecessor
        }
        return findMax(root: searchedLeftChild)
    }
    
    private func preOrderTraversal(root: Node<T>?, traversedArray: inout Array<T>, closure: (T, inout Array<T>) -> Void) -> Bool {
        guard let rootNode = root else { return false }
//        print(rootNode.data)
        closure(rootNode.data, &traversedArray)
        preOrderTraversal(root: rootNode.leftChild, traversedArray: &traversedArray, closure: closure)
        preOrderTraversal(root: rootNode.rightChild, traversedArray: &traversedArray, closure: closure)
        return true
    }
    
    private func inOrderTraversal(root: Node<T>?, traversedArray: inout Array<T>, closure: (T, inout Array<T>) -> Void) -> Bool {
        guard let rootNode = root else { return false }
        inOrderTraversal(root: rootNode.leftChild, traversedArray: &traversedArray, closure: closure)
//        print(rootNode.data)
        closure(rootNode.data, &traversedArray)
        inOrderTraversal(root: rootNode.rightChild, traversedArray: &traversedArray, closure: closure)
        return true
    }
    
    private func postOrderTraversal(root: Node<T>?, traversedArray: inout Array<T>, closure: (T, inout Array<T>) -> Void) -> Bool {
        guard let rootNode = root else { return false }
        postOrderTraversal(root: rootNode.leftChild, traversedArray: &traversedArray, closure: closure)
        postOrderTraversal(root: rootNode.rightChild, traversedArray: &traversedArray, closure: closure)
//        print(rootNode.data)
        closure(rootNode.data, &traversedArray)
        return true
    }
    
    private func levelOrderTraversal(root: Node<T>?, traversedArray: inout Array<T>, closure: (T, inout Array<T>) -> Void) -> Bool{
        guard let rootNode = root else { return false}
        let q = Queue<Node<T>>()
        q.enqueue(data: rootNode)
        while !q.isEmpty {
            guard let front = q.front else { return false }
//            print(front.data.data)
            closure(front.data.data, &traversedArray)
            if front.data.leftChild != nil {
                q.enqueue(data:  front.data.leftChild!)
            }
            if front.data.rightChild != nil {
                q.enqueue(data:  front.data.rightChild!)
            }
            q.dequeue()
        }
        return true
    }
    
    enum traversalOptions: String {
        case preOrder
        case postOrder
        case inOrder
        case levelOrder
    }
    
    func traverseBST(traversalType: traversalOptions) -> Array<T>? {
        guard let rootNode = root else { print("Tree is empty"); return nil }
        var travesedArray = Array<T>()
        var returnBool = false
        switch traversalType {
        case .preOrder:
            returnBool = preOrderTraversal(root: rootNode, traversedArray: &travesedArray) { (data, travesedArray) in
                travesedArray.append(data)
            }
        case .postOrder:
            returnBool = postOrderTraversal(root: rootNode, traversedArray: &travesedArray) { (data, travesedArray) in
                travesedArray.append(data)
            }
        case .levelOrder:
            returnBool = levelOrderTraversal(root: rootNode, traversedArray: &travesedArray) { (data, travesedArray) in
                travesedArray.append(data)
            }
        default:
            returnBool = inOrderTraversal(root: rootNode, traversedArray: &travesedArray) { (data, travesedArray) in
                travesedArray.append(data)
            }
        }
        
        if returnBool {
            return travesedArray
        } else {
            return nil
        }
    }
    
    
    private func deleteNode(data: T, root: Node<T>?, nodeFound: inout Bool) -> Node<T>? {
        guard let rootNode = root else { return nil }
        if (data < rootNode.data) {
            guard let _ = rootNode.leftChild else { nodeFound = true; return nil }
            rootNode.leftChild = deleteNode(data: data, root: rootNode.leftChild, nodeFound: &nodeFound)
            return rootNode
        } else if (data > rootNode.data) {
            guard let _ = rootNode.rightChild else { nodeFound = true; return nil }
            rootNode.rightChild = deleteNode(data: data, root: rootNode.rightChild, nodeFound: &nodeFound)
            return rootNode
        } else {
            nodeFound = true
            if (rootNode.leftChild == nil && rootNode.rightChild == nil) {
                return nil
            } else if (rootNode.leftChild == nil) {
                return rootNode.rightChild
            } else if (rootNode.rightChild == nil) {
                return rootNode.leftChild
            } else {
                guard let node = findMin(root: rootNode.rightChild) else { return nil }
                rootNode.data = node.data
                rootNode.rightChild = deleteNode(data: node.data, root: rootNode.rightChild, nodeFound: &nodeFound)
                return rootNode
            }
        }
    }
//  wrapper function over search to ensure starting travesal is always from root
    func deleteNodeBST(data: T) -> Bool {
        var nodeFound = false
        guard let rootNode = root else { print("Tree is empty"); return false }
        let nodeReturned = deleteNode(data: data, root: rootNode, nodeFound: &nodeFound)
        if  nodeFound {
            root = nodeReturned
            return true
        } else {
            print("Value not found.")
            return false
        }
    }
    
    func isBST(root: Node<T>?, upperBound: T, lowerBound: T) -> Bool {
        guard let rootNode = root else { return true }
        
        if (rootNode.data > upperBound || rootNode.data <= lowerBound) {
            return false
        }
        
        return (isBST(root: rootNode.leftChild, upperBound: rootNode.data, lowerBound: lowerBound) && isBST(root: rootNode.rightChild, upperBound: upperBound, lowerBound: rootNode.data))
    }
    
    private func getHeight(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        if rootNode.leftChild == nil && rootNode.rightChild == nil {
            return 0
        } else {
            return max(getHeight(root: rootNode.leftChild),getHeight(root: rootNode.rightChild)) + 1
        }
    }
    
    private func minDepth(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        var returnVal = 0
        if(rootNode.leftChild == nil && rootNode.rightChild != nil) {
            returnVal = minDepth(root: rootNode.rightChild) + 1
        }
        else if (rootNode.leftChild != nil && rootNode.rightChild == nil) {
            returnVal = minDepth(root: rootNode.leftChild) + 1
        } else {
            let minLt = minDepth(root: rootNode.leftChild)
            let minRt = minDepth(root: rootNode.rightChild)
            returnVal = min(minLt,minRt)+1
        }
        return returnVal
    }
//    wrapper function for min depth
    func getMinDepth() -> Int {
        guard let rootNode = root else { print("tree is empty"); return 0 }
        return minDepth(root: rootNode)
    }
    
    private func maxDepth(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        return max(maxDepth(root: rootNode.leftChild),maxDepth(root: rootNode.rightChild)) + 1
    }
    //    wrapper function for max depth
    func getMaxDepth() -> Int {
        guard let rootNode = root else { print("tree is empty"); return 0 }
        return maxDepth(root: rootNode)
    }
    
    private func nodeDepth(data: T, root: Node<T>?, nodeFound: inout Bool) -> Int {
        guard let rootNode = root else { print("tree is empty"); return 0 }
        if (data > rootNode.data) {
            guard let _ = rootNode.rightChild else { return 0 }
            return nodeDepth(data: data, root: rootNode.rightChild, nodeFound: &nodeFound) + 1
        } else if (data < rootNode.data) {
            guard let _ = rootNode.leftChild else { return 0 }
            return nodeDepth(data: data, root: rootNode.leftChild, nodeFound: &nodeFound) + 1
        } else {
            nodeFound = true
            return 0
        }
    }
    
    func getNodeDepth(data: T) -> Int {
        var nodeFound = false
        guard let rootNode = root else { print("Tree is empty."); return 0 }
        let depth = nodeDepth(data: data, root: rootNode, nodeFound: &nodeFound)
        if nodeFound {
            return depth
        } else {
            print("Node not found.")
            return 0
        }
    }
    
    func getTreeHeight() -> Int {
        guard let rootNode = root else { return 0 }
        return getHeight(root: rootNode)
    }
    
    func findMax(root: Node<T>?) -> Node<T>? {
        guard var rootNode = root else { return nil }
        if (rootNode.rightChild != nil) {
            rootNode = findMax(root: rootNode.rightChild)!
        }
        return rootNode
    }
    
    func findMin(root: Node<T>?) -> Node<T>? {
        guard var rootNode = root else { return nil }
        if (rootNode.leftChild != nil) {
            rootNode = findMin(root: rootNode.leftChild)!
        }
        return rootNode
    }
    
    private func searchTree(data: T, root: Node<T>?) -> Node<T>? {
        guard let rootNode = root else { return nil }
        if (rootNode.data == data) {
            return rootNode
        }
        else if (data<=rootNode.data) {
            let temp = searchTree(data: data, root: rootNode.leftChild)
            return temp
        } else {
            let temp = searchTree(data: data, root: rootNode.rightChild)
            return temp
        }
    }
    
//  wrapper function over search to ensure starting travesal is always from root
    func searchBST(data: T) -> Bool {
        guard let rootNode = root else {print("Tree is empty"); return false}
        if searchTree(data: data, root: rootNode) != nil {
            print("Value found.")
            return true
        } else {
            print("Value not found.")
            return false
        }
    }
    
    private func addChild(data: T, root: Node<T>?) -> Node<T>? {
        
        guard let rootNode = root else { return Node(data: data) }
        if (data<=rootNode.data) {
            rootNode.leftChild = addChild(data: data, root: rootNode.leftChild)
        } else {
            rootNode.rightChild = addChild(data: data, root: rootNode.rightChild)
        }
        return rootNode
    }
//  wrapper function over addtion to ensure starting travesal is always from root
    func addNode(data: T) -> Bool {
        root = addChild(data: data, root: root)
        return true
    }
}



class BSTTests: XCTestCase {
    
    var tree: BST<Int>!
    
    override func setUp() {
        super.setUp()
        tree = BST<Int>()
    }
    
    func testEmptyTree() {
        XCTAssert(tree.root == nil)
        XCTAssert(tree.searchBST(data: 1) == false)
        XCTAssert(tree.findMin(root: tree.root) == nil)
        XCTAssert(tree.findMax(root: tree.root) == nil)
        XCTAssert(tree.getTreeHeight() == 0)
        XCTAssert(tree.getNodeDepth(data: 10) == 0)
        XCTAssert(tree.getMaxDepth() == 0)
        XCTAssert(tree.getMinDepth() == 0)
        XCTAssert(tree.deleteNodeBST(data: 10) == false)
        XCTAssert(tree.isBST(root: tree.root, upperBound: Int.max, lowerBound: Int.min) == true)
        XCTAssert(tree.inorderSucessor(data: 10) == nil)
        XCTAssert(tree.inorderPrdecessor(data: 2) == nil)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.preOrder) == nil)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.preOrder) == nil)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.preOrder) == nil)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.levelOrder) == nil)
        XCTAssert(tree.isTreeBalanced() == true)
        XCTAssert(tree.transformTreeBalanced(treeToTransform: tree) === tree)
    }
    
    func createTree() {
        tree.addNode(data: 10)
        tree.addNode(data: 4)
        tree.addNode(data: 14)
        tree.addNode(data: 2)
        tree.addNode(data: 1)
        tree.addNode(data: 6)
        tree.addNode(data: 5)
        tree.addNode(data: 8)
        tree.addNode(data: 13)
        tree.addNode(data: 12)
        tree.addNode(data: 15)
        tree.addNode(data: 20)
        tree.addNode(data: 18)
        tree.addNode(data: 23)
    }
    
    func testFunctions() {
        createTree()
        XCTAssert(tree.root != nil)
        XCTAssert(tree.root!.data == 10)
        XCTAssert(tree.root!.leftChild != nil)
        XCTAssert(tree.root!.leftChild!.data == 4)
        XCTAssert(tree.root!.rightChild != nil)
        XCTAssert(tree.root!.rightChild!.data == 14)
        XCTAssert(tree.findMin(root: tree.root)!.data == 1)
        XCTAssert(tree.findMax(root: tree.root)!.data == 23)
        XCTAssert(tree.findMin(root: tree.root!.rightChild!.rightChild)!.data == 15)
        XCTAssert(tree.findMax(root: tree.root!.rightChild!.rightChild)!.data == 23)
        XCTAssert(tree.findMin(root:tree.root!.leftChild)!.data == 1)
        XCTAssert(tree.findMax(root:tree.root!.leftChild)!.data == 8)
        XCTAssert(tree.searchBST(data: 23) == true)
        XCTAssert(tree.searchBST(data: 6) == true)
        XCTAssert(tree.searchBST(data: 100) == false)
        XCTAssert(tree.getTreeHeight() == 4)
        XCTAssert(tree.isBST(root: tree.root, upperBound: Int.max, lowerBound: Int.min) == true)
        XCTAssert(tree.getNodeDepth(data: 18) == 4)
        XCTAssertEqual(tree.getNodeDepth(data: 12), tree.getNodeDepth(data: 8))
        XCTAssert(tree.inorderSucessor(data: 8)!.data == 10)
        XCTAssert(tree.inorderSucessor(data: 5)!.data == 6)
        XCTAssert(tree.inorderSucessor(data: 8)!.data == 10)
        XCTAssert(tree.inorderPrdecessor(data: 15)!.data == 14)
        XCTAssert(tree.inorderPrdecessor(data: 18)!.data == 15)
        XCTAssert(tree.inorderPrdecessor(data: 10)!.data == 8)
        let postOrderArry =  [1,2,5,8,6,4,12,13,18,23,20,15,14,10]
        let preOrderArry =   [10,4,2,1,6,5,8,14,13,12,15,20,18,23]
        let inOrderArry =    [1,2,4,5,6,8,10,12,13,14,15,18,20,23]
        let levelOrderArry = [10,4,14,2,6,13,15,1,5,8,12,20,18,23]
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.postOrder)! == postOrderArry)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.preOrder)! == preOrderArry)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.inOrder)! == inOrderArry)
        XCTAssert(tree.traverseBST(traversalType: BST.traversalOptions.levelOrder)! == levelOrderArry)
        XCTAssert(tree.isTreeBalanced() == true)
        XCTAssert(tree.deleteNodeBST(data: 5) == true)
        XCTAssert(tree.deleteNodeBST(data: 6) == true)
        XCTAssert(tree.deleteNodeBST(data: 8) == true)
        XCTAssert(tree.deleteNodeBST(data: 13) == true)
        XCTAssert(tree.deleteNodeBST(data: 12) == true)
        XCTAssert(tree.isTreeBalanced() == false)
        let balanced = tree.transformTreeBalanced(treeToTransform: tree)
        XCTAssert(balanced.root != nil )
        XCTAssert(balanced.root!.data == 14)
        XCTAssert(balanced.root!.leftChild!.data == 4)
        XCTAssert(balanced.root!.rightChild!.data == 20)
        tree = BST<Int>()
        createTree()
        XCTAssert(tree.deleteNodeBST(data: 5) == true)
        XCTAssert(tree.deleteNodeBST(data: 6) == true)
        XCTAssert(tree.deleteNodeBST(data: 8) == true)
        XCTAssert(tree.deleteNodeBST(data: 1) == true)
        XCTAssert(tree.deleteNodeBST(data: 2) == true)
        print(tree.getMinDepth())
        XCTAssert(tree.getMinDepth() == 2)
        XCTAssert(tree.getMaxDepth() == 5)
        XCTAssert(tree.deleteNodeBST(data: 14) == true)
        XCTAssert(tree.root!.rightChild!.data == 15)
        
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
BSTTests.defaultTestSuite.run()


