final public class LinkedList<Element> : CustomStringConvertible, Collection {
	public struct Iterator: IteratorProtocol {
		private var nextNode: Node?
		private var remainingNodes: Int // This is only meaningful for slices
		
		fileprivate init(startNode: Node?, length: Int = .max) {
			self.nextNode = startNode
			self.remainingNodes = length
		}
		
		public mutating func next() -> Element? {
			guard let current = self.nextNode, self.remainingNodes > 0 else { return nil }
			self.nextNode = current.next
			self.remainingNodes -= 1
			
			return current.value
		}
	}
	
	public struct SubSequence: Collection {
		public typealias SubSequence = Self
		
		public var startIndex: Int { bounds.startIndex }
		public var endIndex: Int { bounds.endIndex }
		private let bounds: Range<Int>
		private let startNode: Node
		private var length: Int { endIndex - startIndex }
		
		fileprivate init(bounds: Range<Int>, startNode: Node) {
			self.bounds = bounds
			self.startNode = startNode
		}
		
		public subscript(position: Int) -> Element {
			precondition(self.bounds.contains(position), "Index \(position) out of bounds: \(self.startIndex)..<\(self.endIndex)")
			
			return self.startNode.advanced(by: position - self.startIndex).value
		}
		
		public subscript(bounds: Range<Int>) -> SubSequence {
			SubSequence(bounds: bounds, startNode: self.startNode.advanced(by: bounds.startIndex - self.bounds.startIndex))
		}
		
		public func index(after i: Int) -> Int { i + 1 }
		
		public func makeIterator() -> Iterator {
			Iterator(startNode: startNode, length: self.length)
		}
	}
	
	fileprivate class Node: CustomStringConvertible {
		unowned var previous: Node?
		var next: Node?
		let value: Element
		
		var description: String {
			return "Node: \(value)"
		}
		
		init(_ value: Element) {
			self.value = value
		}
		
		func advanced(by n: Int) -> Node {
			var outNode = self
			for _ in 0..<n {
				outNode = outNode.next!
			}
			
			return outNode
		}
	}
	
	private var head: Node?
	private var tail: Node?
	
	public let startIndex: Int = 0
	public var endIndex: Int { count }
	
//	var isEmpty: Bool { count == 0 }
	
	private(set) public var count: Int = 0
	
	public var description: String {
		var outValue = "[\n"
		
		for value in self {
			outValue += "\t\(value)\n"
		}
		
		outValue += "]"
		
		return outValue
	}
	
	init() {}
	
	deinit {
		var currentNode = self.head
		
		while let node = currentNode {
			node.previous = nil
			let nextNode = node.next
			node.next = nil
			currentNode = nextNode
		}
	}
	
	public subscript(index: Int) -> Element {
		get {
			return self.node(at: index).value
		}
		set {
			self.remove(at: index)
			self.insert(newValue, at: index)
		}
	}
	
	public subscript(bounds: Range<Int>) -> SubSequence {
		SubSequence(bounds: bounds, startNode: self.node(at: bounds.startIndex))
	}
	
	public func makeIterator() -> Iterator {
		Iterator(startNode: self.head)
	}
	
	public func index(after i: Int) -> Int { i + 1 }
	
	public func insert(_ val: Element, at index: Int) {
		let newNode = Node(val)
		
		if index == self.count {
			if let oldLast = self.tail {
				oldLast.next = newNode
				self.tail = newNode
				newNode.previous = oldLast
			} else {
				self.head = newNode
				self.tail = newNode
			}
		} else {
			if index == 0 {
				newNode.next = self.head!
				self.head!.previous = newNode
				self.head = newNode
			} else {
				let oldAtIndex = node(at: index)
				
				oldAtIndex.previous?.next = newNode
				newNode.previous = oldAtIndex.previous
				oldAtIndex.previous = newNode
				newNode.next = oldAtIndex
			}
		}
		
		self.count += 1
	}
	
	@discardableResult
	public func remove(at index: Int) -> Element {
		let concernedNode = node(at: index)
		concernedNode.previous?.next = concernedNode.next
		concernedNode.next?.previous = concernedNode.previous
		
		if index == 0 {
			self.head = concernedNode.next
		}
		
		if index == self.count - 1 {
			self.tail = concernedNode.previous
		}
		
		self.count -= 1
		
		return concernedNode.value
	}
	
	private func node(at index: Int) -> Node {
		precondition(index < count, "Index \(index) out of bounds: \(self.startIndex)..<\(self.endIndex)")
		var currentNode: Node
		
		if index > count/2 {
			currentNode = self.tail!
			
			for _ in 0..<(self.count-1-index) {
				currentNode = currentNode.previous!
			}
		} else {
			currentNode = self.head!.advanced(by: index)
		}
		
		return currentNode
	}
}

extension LinkedList: ExpressibleByArrayLiteral {
	convenience public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}
}

extension LinkedList {
	convenience public init<S: Sequence>(_ elements: S) where S.Element == Element {
		self.init()
		
		for element in elements {
			self.append(element)
		}
	}
	
	convenience public init(single: Element) {
		self.init()
		
		self.append(single)
	}
	
	public func popFirst() -> Element? {
		guard !self.isEmpty else { return nil }
		return self.remove(at: 0)
	}
	
	public func popLast() -> Element? {
		guard !self.isEmpty else { return nil }
		return self.remove(at: count-1)
	}
	
	public func append(_ val: Element) {
		self.insert(val, at: self.count)
	}
	
	public func append<S: Sequence>(contentsOf seq: S) where S.Element == Element {
		for v in seq {
			self.append(v)
		}
	}
}

#if DEBUG
import Foundation

extension LinkedList {
	struct Err: LocalizedError {
		let message: String
		
		var localizedDescription: String { message }
		
		init(_ message: String) { self.message = message }
	}
	
	internal func verifyLinkages() throws {
		var previousNode: Node?
		var currentNode = self.head
		
		repeat {
			guard currentNode?.previous === previousNode else { throw Err("Current node's previous node not right") }
			
			previousNode = currentNode
			currentNode = currentNode?.next
		} while (currentNode != nil)
		
		var nextNode: Node?
		currentNode = self.tail
		
		repeat {
			guard currentNode?.next === nextNode else { throw Err("Current node's next node not right") }
			
			nextNode = currentNode
			currentNode = currentNode?.previous
		} while (currentNode != nil)
	}
}
#endif
