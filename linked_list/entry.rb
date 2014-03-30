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