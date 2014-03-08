class BinaryHeap
	def initialize
		@heap_nodes = []
	end

	def swap(i1, i2)
		@heap_nodes[i1].index = i2
		@heap_nodes[i2].index = i1
		@heap_nodes[i1], @heap_nodes[i2] = @heap_nodes[i2], @heap_nodes[i1]
	end

	def heapify_up
		node = @heap_nodes.last
		while true
			if node.index == 0
				break
			else
				parent = (node.index -1) / 2
				if parent.priority >= node.priority
					break
				else
					swap(parent.index, node.index)
				end
			end
		end
	end




	def insert(datum, options)
		node = HeapNode.new(datum, options)
		@heap_nodes << node
		node.index = @heap_nodes.length - 1
		heapify_up
	end

	def delete
	end

	def extract
	end

	def priority_up(node, priority)
	end

	def priority_down(node, priority)

	end

	def change_priority(node, priority)
	end

	def heapify(array)
		array.each do |element|
			if elemement.is_a?(Array)
				insert(element[0], priority: element[1])
			else
				insert(element)
			end
		end
	end




end

class HeapNode
	attr_accessor :data, :priority
	def initialize(data, options)
		@data = data
		@priority = (options[:priority] ? options[:priority] : @data)
		@index = nil
	end
end