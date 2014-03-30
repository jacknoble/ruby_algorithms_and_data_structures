class Entry
	attr_accessor :next, :data, :prev

	def initialize(data)
		@next = nil
		@prev = nil
		@data = data
	end

	def link(entry)
		self.next = entry
		entry.prev = self
	end

	def to_s
		"-#{self.data}-"
	end
end

class LinkedList
	attr_accessor :name, :head, :last, :length

	def initialize()
		@length = 0
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
		if self.head
			entry.link(self.head)
			self.head = entry
		else
			@head, @last = entry, entry
		end
		self.length += 1
		self
	end

		#remove from top
	def pop
		released = @head
		@head = @head.next
		@length -= 1
		released
	end

	#put on bottom of queue
	def queue(entry)
		if  !@head
			@head, @last = entry, entry
		else
			self.last.link(entry)
			self.last = entry
		end

		self.length += 1
		self
	end

	#remove from bottom
	def dequeue
		released = @last
		self.last = @last.prev
		@last.next = nil
		@length -= 1
		released
	end

	def to_s
		string = "{"
		entry = self.head
		until entry.nil?
			string.concat(entry.data.to_s)
			string.concat('-') if entry.next
			entry = entry.next
		end

		string.concat('}')
	end

	def concat(list)
		self.last.link(list.head)
		self.last = list.last
	end

	def dup
		dup_list = LinkedList.new
		self.each do |entry|
			dup_list.queue_data(entry.data)
		end

		dup_list
	end

	def each(entry = @head, &prc)
		next_entry = entry.next
		prc.call(entry)
		unless next_entry.nil?
			each(next_entry, &prc)
		end

		self
	end

	def [](index)
		get_entry_at(index).data
	end

	def []=(index, val)
		get_entry_at(index).data = val
		self
	end

	def delete_at(index)
		entry = get_entry_at(index)
		prev_entry, next_entry = entry.prev, entry.next
		prev_entry.next, next_entry.prev = next_entry, prev_entry
		entry
	end

	def insert_at(index, data)
		new_entry = Entry.new(data)
		next_entry = get_entry_at(index)
		previous_entry = next_entry.prev
		previous_entry.link(new_entry)
		new_entry.link(next_entry)
	end

	def get_entry_at(index)
		if index < 0
			index = self.length + index
		end
		entry = @head
		until entry.nil?
			return entry if index == 0
			entry = entry.next
			index -= 1
		end
	end

	def reverse
		reversed_list = LinkedList.new
		self.each do |entry|
			reversed_list.push_data(entry.data)
		end

		reversed_list
	end

	def reverse!
		reverse_entries(@head)
		@head, @last = @last, @head
		self
	end


	def queue_data(data)
		self.queue(Entry.new(data))
	end

	def push_data(data)
		self.push(Entry.new(data))
	end

	private

		def reverse_entries(entry)
			next_entry = entry.next
			entry.next, entry.prev = entry.prev, entry.next
			reverse_entries(next_entry) unless next_entry.nil?
		end
end