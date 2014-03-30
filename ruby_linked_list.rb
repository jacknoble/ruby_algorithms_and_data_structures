class Entry
	attr_accessor :next, :data

	def initialize(data)
		@next = nil
		@data = data
	end

	def to_s
		"-#{self.data}-"
	end

	def link(entry)
		self.next = entry
	end

end

class DoubleEntry < Entry
	attr_accessor :prev

	def initialize(data)
		super
		@prev = nil
	end

	def link(entry)
		super
		entry.prev = self
	end
end 

class SinglyLinkedList
	attr_accessor :head

	ENTRY_TYPE =  "Entry"

	def initialize
		@head = nil
	end

	def has_head?
		!!@head
	endexi

	def self.from_array(array)
		list = self.new
		last_index = array.length - 1
		last_index.downto(0) do |index|
			list.push_data(array[index])
		end

		list
	end

	def push(entry)
		entry.link(@head) if self.has_head?
		self.head = entry
	end

	def pop
		released = @head
		@head = @head.next
		released
	end

	def get_first_where(&prc)
		entry = @head
		target = nil
		until entry.nil?
			target = entry if prc.call(entry)
			entry = entry.next
		end

		target
	end

	def last
		self.get_first_where { |entry| entry.next.nil? }
	end

	def enqueue(entry)
		if self.has_head?
			self.last.link(entry)
		else
			self.head = entry
		end

		self
	end

	def dequeue
		second_to_last = self.get_first_where do |entry|
			entry.next.next.nil?
		end

		released = second_to_last.next
		second_to_last.next = nil
		released
	end

	def push_data(data)
		self.push(new_entry(data))
	end

	def enqueue_data(data)
		self.enqueue(new_entry(data))
	end

	def new_entry(data)
		Object.const_get(ENTRY_TYPE).new(data)
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

	def each(&prc)
		entry = @head
		until entry.nil?
			prc.call(entry)
			entry = entry.next
		end

		self
	end

	def concat(list)
		self.last.link(list.head)
	end

	def dup
		dup_list = self.class.new
		dup_list.push_data(self.head.data)
		most_recent_add = dup_list.head
		self.each do |entry|
			next if entry == self.head
			most_recent_add.link(new_entry(entry.data))
			most_recent_add = most_recent_add.next
		end

		dup_list
	end


	def [](index)
		get_entry_at(index).data
	end

	def []=(index, val)
		get_entry_at(index).data = val
		self
	end


	def delete_at(index)
		prev_entry = get_entry_at(index - 1)
		entry = prev_entry.next
		next_entry = entry.next
		prev_entry.link(next_entry)
		entry
	end


	def get_entry_at(index)
		entry = @head
		until entry.nil?
			return entry if index == 0
			entry = entry.next
			index -= 1
		end
	end

	def insert_at(index, data)
		new_node = new_entry(data)
		previous_entry = get_entry_at(index - 1)
		next_entry = previous_entry.next
		previous_entry.link(new_node)
		new_node.link(next_entry)
		self
	end

	def reverse
		reversed_list = self.class.new
		self.each do |entry|
			reversed_list.push_data(entry.data)
		end

		reversed_list
	end

	def reverse!
		first_entry = @head
		second_entry = @head.next
		@head.next =  nil
		until second_entry.nil?
			third_entry = second_entry.next
			second_entry.next = first_entry
			first_entry = second_entry
			@head = first_entry if third_entry.nil?
			second_entry = third_entry
		end

		self
	end

end

class DoublyLinkedList < SinglyLinkedList
	attr_accessor :name, :last, :length

	ENTRY_TYPE =  "DoubleEntry"

	def initialize
		super
		@last = nil
	end

	def push(entry)
		super
		self.last = entry if @last.nil?
	end

	def enqueue(entry)
		super
		self.last = entry if @last.nil?
	end


	def reverse!
		reverse_entries(@head)
		@head, @last = @last, @head
		self
	end

	private

		def reverse_entries(entry)
			next_entry = entry.next
			entry.next, entry.prev = entry.prev, entry.next
			reverse_entries(next_entry) unless next_entry.nil?
		end
end