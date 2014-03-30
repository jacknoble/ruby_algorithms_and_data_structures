require_relative 'singly_linked_list'
require_relative 'double_entry'
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
		old_head = @head
		super
		@last = old_head
	end
end