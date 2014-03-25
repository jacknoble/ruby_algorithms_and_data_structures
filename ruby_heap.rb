#todo: finish priority_proc implementation

class BinaryHeap
	attr_accessor :heap_nodes, :priority_proc, :hash
	def initialize(options={})
		@hash = (options[:hash] == true || options[:hash] == nil) ? {} : false
		@min = options[:min]
		@heap_nodes = []
		if block_given?
			@priority_proc = Proc.new { yield }
		end
	end

	def self.build_heap(array, options = {})
		heap = BinaryHeap.new(options)
		array.each_with_index do |el, i|
			if el.is_a?(Array)
				node = HeapNode.new(el[0], priority: el[1])
			else
				node = HeapNode.new(el)
			end
			node.index = i
			heap.heap_nodes << node
		end
		(array.length/2).downto(0) do |index|
			node = heap.heap_nodes[index]
			heap.heapify_down(node)
		end

		heap
	end

	def prioritize()

	def get(datum)
		hash[datum]
	end

	def swap(i1, i2)
		@heap_nodes[i1].index = i2
		@heap_nodes[i2].index = i1
		@heap_nodes[i1], @heap_nodes[i2] = @heap_nodes[i2], @heap_nodes[i1]
	end

	def heapify_up(node = @heap_nodes.last)
		while true
			break if node.index == 0
			parent_index =  ((node.index) -1 ) / 2
			parent = @heap_nodes[parent_index]
			break if parent.priority >= node.priority
			swap(parent.index, node.index)
		end
	end

	def heapify_down(node = @heap_nodes.first)
		while true
			i = node.index
			break if (i*2) + 1 >= @heap_nodes.length
			children = [heap_nodes[(i*2) + 1], heap_nodes[(i*2) + 2]]
			p node, children
			if children.any?{|child| !child.nil? && child.priority > node.priority}
				swap(node.index, children.max{|c1, c2| c1.priority <=> c2.priority}.index)
			else
				break
			end
		end
	end


	def insert(datum, options = {})
		node = HeapNode.new(datum, options)
		hash[datum] = node if hash
		@heap_nodes << node
		node.index = @heap_nodes.length - 1
		heapify_up
	end

	def extract
		extracted_node = @heap_nodes[0]
		@heap_nodes[0] = @heap_nodes.pop
		@heap_nodes[0].index = 0
		heapify_down
		extracted_node
	end

	def increase_priority(node, priority)
		node = get(node)
		node.priority = priority
		heapify_up(node)
	end

	def priority_down(node, priority)
		node = get(node)
		priority = priority * -1 if min
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
	attr_accessor :data, :priority, :index
	def initialize(data, options = {})
		@data = data
		order = (options[:priority] ? options[:priority] : @data)
		@priority = options[:min] ? order * -1 : order
		@index = nil
	end
end