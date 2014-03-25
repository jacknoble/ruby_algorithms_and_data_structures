class Entry
	attr_accessor :next, :data

	def initialize(data)
		@next = nil
		@back = nil
		@data = data
	end
end

class LinkedList
	attr_accessor :name, :head, :last

	def initialize()
		@head = nil
		@last = nil
	end

	def self.build_from_datum(datum)
		list = LinkedList.new
		list.queue(Entry.new(datum))
	end

	def self.from_array(array)
		list = LinkedList.new
		array.each do |el|
			list.queue_data(el)
		end
		
		list
	end
	#put on top of queue
	def push(entry)
		if @head
			entry.next = @head
			entry.next.back = entry
		else
			@head = entry
		end
	end

		#remove from top
	def pop
		released = @head
		@head = @head.next
		released
	end

	#put on bottom of queue
	def queue(entry)
		@head = entry unless @head
		last_entry = self.last
		last_entry.next = entry
		entry.back = last_entry
	end

	def show(entry = @head)
		print entry.data
		show(entry.next) if entry.next
	end

	def concat(list)
		list.push(@last)
	end

	def map(entry = @head, &prc)
		next_entry = entry.next
		prc.call(entry)
		unless next_entry.nil?
			map(next_entry, &prc)
		end
	end

	def queue_data(data)
		self.queue(Entry.new(data))
	end

	def push_data(data)
		self.push(Entry.new(data))
	end

	def reverse!(entry = @head)

	end

end





 # select, reverse