
import Foundation
import XCTest

class NodeStack<T> {
    var data: T
    var next: NodeStack<T>?
    init(data: T, next: NodeStack<T>? = nil) {
        self.data = data
        self.next = next
    }
}


class Stack<T> {
    
    var top: NodeStack<T>?
    
    var isEmpty: Bool { return top == nil }
    
    var length = 0
    
    func stackIsEmpty() -> Bool {
        guard !isEmpty else { return true }
        return false
    }
    
    func peek() -> NodeStack<T>? {
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
        let newNode = NodeStack(data: value)
        length = length+1
        guard let topNode = top else { top = newNode; return true }
        newNode.next = topNode
        top = newNode
        return true
    }
}

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
    
    func morrisInorderTravesal(root: Node<T>?) -> Array<T>? {
        guard let rootNode = root else { print("Tree is epmty."); return nil }
        var resultArray = Array<T>()
        var nodeOnHand: Node<T>? = rootNode
        while (nodeOnHand != nil) {
            if (nodeOnHand!.leftChild == nil) {
                resultArray.append(nodeOnHand!.data)
                nodeOnHand = nodeOnHand!.rightChild
            } else {
                var predecessor = nodeOnHand!.leftChild
                while (predecessor!.rightChild !== nodeOnHand || predecessor!.rightChild != nil) {
                    predecessor = predecessor!.rightChild
                }
                if (predecessor!.rightChild == nil) {
                    predecessor!.rightChild = nodeOnHand
                    nodeOnHand = nodeOnHand!.leftChild
                } else {
                    predecessor!.rightChild = nil
                    resultArray.append(nodeOnHand!.data)
                    nodeOnHand = nodeOnHand!.rightChild
                }
            }
        }
        return resultArray
    }
    
    func largestBST (root: Node<T>?) -> (Bool, Int, Int , Int) {
        guard  let rootNode = root else { print("Tree is empty."); return (true, 0, 0, 0) }
        if (rootNode.leftChild == nil && rootNode.rightChild == nil) {
            return (true, 1, rootNode.data as! Int, rootNode.data as! Int)
        }
        let lrgLeft = largestBST(root: rootNode.leftChild)
        let lrgRight = largestBST(root: rootNode.rightChild)
        
        if (lrgLeft.0 && lrgRight.0 && (rootNode.data as! Int)>lrgLeft.3  && (rootNode.data as! Int)<lrgRight.2) {
            return (true, (lrgLeft.1+lrgRight.1)+1 , lrgLeft.2, lrgRight.3)
        } else {
            return (false, max(lrgLeft.1, lrgRight.1), 0, 0)
        }
    }
    
    func postOrderTravesalOneStack() -> Void {
        guard let rootNode = root else { print("Tree is empty."); return }
        let stackHolder = Stack<Node<T>>()
        var nodeOnhand: Node<T>? = rootNode
        while (nodeOnhand != nil || !stackHolder.isEmpty) {
            if nodeOnhand != nil {
                stackHolder.push(value: nodeOnhand!)
                nodeOnhand = nodeOnhand!.leftChild
            } else {
                if let tempNode = stackHolder.top?.data.rightChild {
                   nodeOnhand = tempNode
                } else {
                    var tempNode = stackHolder.top!.data
                    print(tempNode.data)
                    stackHolder.pop()
                    while (!stackHolder.isEmpty && tempNode === stackHolder.top?.data.rightChild ) {
                        tempNode = stackHolder.top!.data
                        print(tempNode.data)
                        stackHolder.pop()
                    }
                }
            }
        }
    }
    
    func lowestCommonAncestor(root: Node<T>?, node1: Node<T>, node2: Node<T>) -> Node<T>? {
        guard let rootNode = root else { return nil }
        
        if ((rootNode === node1) || (rootNode === node2)) {
            return rootNode
        }
        
        let leftTree = lowestCommonAncestor(root: rootNode.leftChild, node1: node1, node2: node2)
        if (leftTree != nil && leftTree !== node1 && leftTree !== node2) {
            return leftTree
        } else {
            let righttTree = lowestCommonAncestor(root: rootNode.rightChild, node1: node1, node2: node2)
            if(leftTree != nil && righttTree != nil) {
                return rootNode
            }
            return leftTree != nil ? leftTree : righttTree
        }
    }
    
    func lowestCommonAnscestorBST(root: Node<T>?, node1: Node<T>, node2: Node<T>) -> Node<T>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        if(min(node1.data,node2.data) > rootNode.data) {
            return lowestCommonAnscestorBST(root: rootNode.rightChild, node1: node1, node2: node2)
        }
        if (max(node1.data,node2.data) < rootNode.data) {
             return lowestCommonAnscestorBST(root: rootNode.leftChild, node1: node1, node2: node2)
        }
        return root
    }
    
    func spiralTraversal() -> Array<T>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        let stackOne = Stack<Node<T>>()
        let stackTwo = Stack<Node<T>>()
        var returnArray = Array<T>()
        stackOne.push(value: rootNode)
        
        while(stackTwo.isEmpty && stackOne.isEmpty) {
            while !stackOne.isEmpty {
                if let topNode = stackOne.top {
                    if topNode.data.leftChild != nil {
                        stackTwo.push(value: topNode.data.leftChild!)
                    }
                    if topNode.data.rightChild != nil {
                        stackTwo.push(value: topNode.data.rightChild!)
                    }
                    stackOne.pop()
                    returnArray.append(topNode.data.data)
                }
            }
            
            while !stackTwo.isEmpty {
                if let secondTopNode = stackTwo.top {
                    if secondTopNode.data.rightChild != nil {
                        stackOne.push(value: secondTopNode.data.rightChild!)
                    }
                    if secondTopNode.data.leftChild != nil {
                        stackOne.push(value: secondTopNode.data.leftChild!)
                    }
                    stackTwo.pop()
                    returnArray.append(secondTopNode.data.data)
                }
            }
            
        }
        return returnArray
    }
//    wrong implementation
//    func  reverseLevelOderTraversal() -> Array<T>? {
//        guard var traversedArray = traverseBST(traversalType: BST.traversalOptions.levelOrder) else { print("Tree is empty"); return nil }
//        let stackHolder = Stack<T>()
//        for counter in 0 ..< traversedArray.count {
//            stackHolder.push(value: traversedArray[counter])
//        }
//        guard traversedArray.count == stackHolder.length else { print("Error: Stack transformation not succesful."); return nil }
//        for counter in 1 ... stackHolder.length {
//            guard let topData = stackHolder.top else { print("Error: Unexpectedly found stack empty."); return nil }
//            traversedArray[counter] = topData.data
//            stackHolder.pop()
//        }
//        return traversedArray
//    }
//    
    
    
    func treeCompare(firstTreeRoot: Node<T>?, secondTreeRoot: Node<T>?) -> Bool {
        if (firstTreeRoot == nil && secondTreeRoot == nil) {
            return true
        }
        if (firstTreeRoot == nil || secondTreeRoot == nil) {
            return false
        }
        return ((firstTreeRoot!.data == secondTreeRoot!.data) && treeCompare(firstTreeRoot: firstTreeRoot!.leftChild, secondTreeRoot: secondTreeRoot!.leftChild) && treeCompare(firstTreeRoot: firstTreeRoot!.rightChild, secondTreeRoot: secondTreeRoot!.rightChild))
        
    }
    
    func iterativePostOder(root: Node<T>?) -> Stack<Node<T>>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        let stackOne = Stack<Node<T>>()
        let stackTwo = Stack<Node<T>>()
        stackOne.push(value: rootNode)
        while (!stackOne.stackIsEmpty()) {
            let current = stackOne.top!.data
            stackOne.pop()
            if (current.leftChild != nil) {
                stackOne.push(value: current.leftChild!)
            }
            if (current.rightChild != nil) {
                stackOne.push(value: current.rightChild!)
            }
            stackTwo.push(value: current)
        }
       return stackTwo
    }
    
    func iterativeInOder(root: Node<T>?) -> Array<T>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        var returnArray = Array<T>()
        let stack = Stack<Node<T>>()
        var node: Node<T>? = rootNode
        while (true) {
            if (node != nil) {
                stack.push(value: node!)
                node = node!.leftChild
            } else {
                if stack.isEmpty {
                    break
                } else {
                    node = stack.top!.data
                    stack.pop()
                    returnArray.append(node!.data)
                    node = node!.rightChild
                }
            }
        }
        return returnArray
    }
    
    func iterativePreOrder(root: Node<T>?) -> Array<T>? {
        guard let rootNode = root else { print("Tree is empty."); return nil }
        var returnArray = Array<T>()
        let stack = Stack<Node<T>>()
        stack.push(value: rootNode)
        while (!stack.isEmpty) {
            let current = stack.top!.data
            stack.pop()
            returnArray.append(current.data)
            if (current.rightChild != nil) {
                stack.push(value: current.rightChild!)
            }
            if (current.leftChild != nil) {
                stack.push(value: current.leftChild!)
            }
        }
        return returnArray
    }
    
    func rootToLeafSum(data: T, root: Node<T>?, pathArray: inout Array<T>) -> Bool {
        guard let rootNode = root else { return false }
        if (rootNode.leftChild == nil && rootNode.rightChild == nil) {
            if (data == rootNode.data) {
                pathArray.append(rootNode.data)
                return true
            } else {
                return false
            }
        }
        let val = (data as! Int) - (rootNode.data as! Int)
        
        if(rootToLeafSum(data: val as! T, root: rootNode.leftChild, pathArray: &pathArray)) {
            pathArray.append(rootNode.data)
            return true
        }
        if(rootToLeafSum(data: val as! T, root: rootNode.rightChild, pathArray: &pathArray)) {
            pathArray.append(rootNode.data)
            return true
        }
        return false
    }
    
    func sizeBST(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        let leftSize = sizeBST(root: rootNode.leftChild)
        let rightSize = sizeBST(root: rootNode.rightChild)
        return leftSize+rightSize+1
        
    }
    
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
        inOrderTraversal(root: rootNode, traversedArray: &sortedArray) { (data, collectionArray) in
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
            guard let _ = rootNode.leftChild else { nodeFound = false; return rootNode }
            rootNode.leftChild = deleteNode(data: data, root: rootNode.leftChild, nodeFound: &nodeFound)
            return rootNode
        } else if (data > rootNode.data) {
            guard let _ = rootNode.rightChild else { nodeFound = false; return rootNode }
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
        
        if (rootNode.data > upperBound || rootNode.data < lowerBound) {
            return false
        }
        
        return (isBST(root: rootNode.leftChild, upperBound: rootNode.data, lowerBound: lowerBound) && isBST(root: rootNode.rightChild, upperBound: upperBound, lowerBound: rootNode.data))
    }
    
    
    
    private func minDepth(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        var returnVal = 0
        if (rootNode.leftChild == nil && rootNode.rightChild == nil) {
            return 0
        }
        if(rootNode.leftChild == nil && rootNode.rightChild != nil) {
             return minDepth(root: rootNode.rightChild) + 1
        }
        if (rootNode.leftChild != nil && rootNode.rightChild == nil) {
            return minDepth(root: rootNode.leftChild) + 1
        }
        
        return min(minDepth(root: rootNode.leftChild), minDepth(root: rootNode.rightChild))+1
    }
//    wrapper function for min depth
    func getMinDepth() -> Int {
        guard let rootNode = root else { print("tree is empty"); return 0 }
        return minDepth(root: rootNode)
    }
    
    private func maxDepth(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        if (rootNode.leftChild == nil && rootNode.rightChild == nil) {
            return 0
        }
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
    
    private func getHeight(root: Node<T>?) -> Int {
        guard let rootNode = root else { return 0 }
        if rootNode.leftChild == nil && rootNode.rightChild == nil {
            return 0
        } else {
            return max(getHeight(root: rootNode.leftChild),getHeight(root: rootNode.rightChild)) + 1
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
    
    func insertNodeIteravtive(data: T, root: Node<T>?) -> Node<T> {
        let newNode = Node(data: data)
        guard let rootNode = root else { return newNode }
        var current: Node<T>? = rootNode
        var parent: Node<T>?
        while (current != nil) {
            if (data <= current!.data) {
                parent = current
                current = current!.leftChild
            } else {
                parent = current
                current = current!.rightChild
            }
        }
        if (data <= parent!.data) {
            parent!.leftChild = newNode
        }else {
            parent!.rightChild = newNode
        }
        return rootNode
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
//BSTTests.defaultTestSuite.run()


