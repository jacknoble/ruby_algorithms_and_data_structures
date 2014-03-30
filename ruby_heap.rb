#todo: finish priority_proc implementation
require 'debugger'
class BinaryHeap
	attr_accessor :heap_nodes, :hash
	def initialize(options={})
		@hash = {}
		@min = options[:min]
		@heap_nodes = []
	end

	def self.build(array, options = {})
		heap = BinaryHeap.new(options)
		array.each_with_index do |el, i|
			if el.is_a?(Array)
				node = HeapNode.new(el[0], priority: el[1], min: options[:min])
			else
				node = HeapNode.new(el, min: options[:min])
			end
			node.index = i
			heap.hash[node.data] = node
			heap.heap_nodes << node
		end
		(array.length/2).downto(0) do |index|
			node = heap.heap_nodes[index]
			heap.heapify_down(node)
		end

		heap
	end

	def get(datum)
		hash[datum]
	end

	def swap_at(i1, i2)
		@heap_nodes[i1].index = i2
		@heap_nodes[i2].index = i1
		@heap_nodes[i1], @heap_nodes[i2] = @heap_nodes[i2], @heap_nodes[i1]
	end

	def swap_nodes(node1, node2)
		swap_at(node1.index, node2.index)
	end

	def parent(node)
		parent_index = (node.index - 1 ) / 2
		parent = @heap_nodes[parent_index]
	end

	def children(node)
		i = node.index
		child_nodes = [heap_nodes[(i*2) + 1], heap_nodes[(i*2) + 2]]
	end

	def as_sorted_array
		array = []
		until @heap_nodes.count == 0
			node = self.extract
			array << node.data
		end

		array
	end

	def heapify_up(node = @heap_nodes.last)
		while true
			break if node.index == 0
			parent_node = parent(node)
			break if parent.priority >= node.priority
			swap_at(parent.index, node.index)
		end
	end

	def heapify_down(node = @heap_nodes.first)
		while true
			break if (node.index * 2) + 1 >= @heap_nodes.length
			child_nodes = children(node)
			if child_nodes.any?{|child| !child.nil? && child.priority > node.priority}
				if child_nodes.all? { |node| !node.nil? }
					larger_node = child_nodes.max { |c1, c2|  c1.priority <=> c2.priority }
				else
					larger_node = child_nodes[0] || child_nodes[1]
				end
				swap_nodes(node, larger_node)
			else
				break
			end
		end
	end


	def insert(datum, options = {})
		node = HeapNode.new(datum, options)
		hash[datum] = node
		@heap_nodes << node
		node.index = @heap_nodes.length - 1
		heapify_up
	end

	def extract
		if @heap_nodes.count > 1
			extracted_node = @heap_nodes[0]
			@heap_nodes[0] = @heap_nodes.pop
			@heap_nodes[0].index = 0
			heapify_down
		else
			extracted_node = @heap_nodes.pop
		end
		self.hash[extracted_node.data] = nil
		extracted_node
	end

	def delete(datum)
		replacement_node = @heap_nodes.last
		deleted_node = get(datum)
		swap_nodes(deleted_node, replacement_node)
		deleted_node = @heap_nodes.pop
		if parent(replacement_node).priority > replacement_node.priority
			heapify_down
		else
			heapify_up
		end
	end

	def increase_priority(node, priority)
		node = get(node)
		node.priority = priority
		heapify_up(node)
	end

	def priority_down(node, priority)
		node = get(node)
		node.priority = priority
		heapify_down(node)
	end

	def change_priority(node, priority)
		node = get(node)
		old_priority = node.priority
		node.priority = priority
		if old_priority > priority
			heapify_down(node)
		elsif node.priority < priority
			heapify_up(node)
		end
	end

end

class HeapNode
	attr_accessor :data, :index
	def initialize(data, options = {})
		@min = options[:min]
		@data = data
		@order = (options[:priority] ? options[:priority] : @data)
		@index = nil
	end

	def priority
		if @min
			@order * -1
		else
			@order
		end
	end

	def priority=(num)
		@order = num
	end
end