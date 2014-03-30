require_relative 'entry'
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