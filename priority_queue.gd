extends Reference
class_name PriorityQueue

const VALUE_FIELD = 0
const PRIORITY_FIELD = 1

# Array representation of a heap. The heap consists of "nodes".
# A node can have a parent, and 0-2 children.
# If a node has 1 child, that child will always be the "left" child.
var heap = []

# Returns true if an index exists in the heap, false otherwise.
func index_exists(index):
	if index >= heap.size() or index < 0:
		return false
	return true

# Takes a node's index, returns the index of its left child.
# Does not check if the child actually exists.
func get_left_child_index(node_index):
	return (2*node_index)+1

# Takes a node's index, returns the index of its right child.
# Does not check if the child actually exists.
func get_right_child_index(node_index):
	return (2*node_index)+2

# Takes a node's index, returns the index of its parent.
# Does not check if the parent actually exists.
func get_parent_index(node_index):
	return (node_index-1)/2

# Compares A to B. Modifying this will change how the queue prioritizes items.
func compare(a_index, b_index):
	return heap[a_index][PRIORITY_FIELD] < heap[b_index][PRIORITY_FIELD]

# Returns true if the node has at least one child.
func has_children(node_index):
	return index_exists(get_left_child_index(node_index))

# Returns true if this node has a parent.
# Currently unused, but here for completeness
func has_parent(node_index):
	index_exists(get_parent_index(node_index))

# Gets the index of a node's lower-priority child.
# Assumes that the node has at least one child.
func get_minimum_child_index(node_index):
	var left_child = get_left_child_index(node_index)
	var right_child = get_right_child_index(node_index)
	if not index_exists(right_child):
		return left_child
	if compare(left_child,right_child):
		return left_child
	return right_child

# Swaps A and B within the heap.
func swap(a_index, b_index):
	var temp = heap[a_index]
	heap[a_index] =  heap[b_index]
	heap[b_index] = temp

# Percolates a node up in the heap until it's in the correct place.
func perc_up(node_index):
	while true:
		var parent_index = get_parent_index(node_index)
		if index_exists(parent_index) and compare(node_index,parent_index):
			swap(node_index, parent_index)
			node_index = parent_index
		else:
			return

# Percolates a node down in the heap until it's in the correct place.
func perc_down(node_index):
	while true:
		if not has_children(node_index):
			return
		var child_index = get_minimum_child_index(node_index)
		if compare(child_index,node_index):
			swap(node_index,child_index)
			node_index = child_index
		else:
			return

# Adds an item to the queue, with a given priority, then makes sure it's in the right place.
func enqueue(item, priority):
	heap.append([item, priority])
	perc_up(heap.size()-1)

# Removes the item at the top of the heap, which will be the most-prioritized item.
# Then reorganizes the heap to move the next highest-priority item to the top.
func dequeue():
	swap(0,heap.size()-1)
	var return_value = heap.pop_back()
	perc_down(0)
	return return_value[VALUE_FIELD]

# Returns true if the queue is empty, false otherwise.
func empty():
	return heap.empty()
