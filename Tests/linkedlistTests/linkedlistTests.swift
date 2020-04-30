import XCTest
@testable import LinkedList

final class LinkedListTests: XCTestCase {
	static var allTests = [
		("testBasicInit", testBasicInit),
		("testSequenceInit", testSequenceInit),
		("testGetHead", testGetHead),
		("testGetMiddle", testGetMiddle),
		("testGetTail", testGetTail),
		("testRemoveHead", testRemoveHead),
		("testRemoveMiddle", testRemoveMiddle),
		("testRemoveTail", testRemoveTail),
		("testInsertHead", testInsertHead),
		("testInsertMiddle", testInsertMiddle),
		("testInsertTail", testInsertTail),
		("testPopFirst", testPopFirst),
		("testPopLast", testPopLast),
		("testPopFirstEmpty", testPopFirstEmpty),
		("testPopLastEmpty", testPopLastEmpty),
		("testHeadSlice", testHeadSlice),
		("testMiddleSlice", testMiddleSlice),
		("testTailSlice", testTailSlice),
		("testSliceSubscript", testSliceSubscript),
		("testSliceSlice", testSliceSlice)
	]
	
	var ll: LinkedList<Int>!
	
	override func setUp() {
		self.ll = [1, 2, 3, 4]
	}
	
	func testBasicInit() {
		XCTAssertEqual(Array(ll), Array(1...4))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testSequenceInit() {
		let src: Set = ["a", "b", "c", "d"]
		
		let ll = LinkedList(src)
		XCTAssertEqual(Set(ll), src)
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testGetHead() {
		XCTAssertEqual(ll[0], 1)
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testGetMiddle() {
		XCTAssertEqual(ll[2], 3)
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testGetTail() {
		XCTAssertEqual(ll[3], 4)
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testRemoveHead() {
		ll.remove(at: 0)
		
		XCTAssertEqual(Array(ll), Array(2...4))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testRemoveMiddle() {
		ll.remove(at: 1)
		
		XCTAssertEqual(Array(ll), [1, 3, 4])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testRemoveTail() {
		// Need to make it Bidirectional to do this (or a smarter version)
		//		ll.remove(at: ll.index(ll.endIndex, offsetBy: -1))
		ll.remove(at: 3)
		
		XCTAssertEqual(Array(ll), Array(1...3))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testInsertHead() {
		ll.insert(0, at: 0)
		
		XCTAssertEqual(Array(ll), Array(0...4))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testInsertMiddle() {
		ll.insert(999, at: 2)
		
		XCTAssertEqual(Array(ll), [1, 2, 999, 3, 4])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testInsertTail() {
		ll.append(5)
		
		XCTAssertEqual(Array(ll), Array(1...5))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testPopFirst() {
		let removed = ll.popFirst()
		
		XCTAssertEqual(removed, 1)
		XCTAssertEqual(Array(ll), Array(2...4))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testPopLast() {
		let removed = ll.popLast()
		
		XCTAssertEqual(removed, 4)
		XCTAssertEqual(Array(ll), Array(1...3))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testPopFirstEmpty() {
		let ll = LinkedList<Int>()
		let removed = ll.popFirst()
		
		XCTAssertEqual(removed, nil)
		XCTAssertEqual(Array(ll), [])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testPopLastEmpty() {
		let ll = LinkedList<Int>()
		let removed = ll.popLast()
		
		XCTAssertEqual(removed, nil)
		XCTAssertEqual(Array(ll), [])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testHeadSlice() {
		let ss = ll[0..<2]
		
		XCTAssertEqual(Array(ss), [1, 2])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testMiddleSlice() {
		let ss = ll[1..<3]
		
		XCTAssertEqual(Array(ss), [2, 3])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testTailSlice() {
		let ss = ll[2..<ll.endIndex]
		
		XCTAssertEqual(Array(ss), [3, 4])
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testSliceSubscript() {
		let ss = ll[1..<3]
		
		XCTAssertEqual(ss[2], 3)
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
	
	func testSliceSlice() {
		let ll = LinkedList(1...10)
		let ss1 = ll[2...8]
		let ss2 = ss1[4...5]
		
		XCTAssertEqual(Array(ss1), Array(3...9))
		XCTAssertEqual(Array(ss2), Array(5...6))
		XCTAssertNoThrow(try ll.verifyLinkages())
	}
}
