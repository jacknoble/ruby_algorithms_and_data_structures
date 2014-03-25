class GraphVertex
	attr_reader :incoming, :outgoing, :data
	def initialize(data)
		@data = data
		@incoming = Set.new
		@outgoing = Set.new
	end

	def edge_to(other_vertex)
		self.outgoing << other_vertex
		other_vertex.incoming << self
	end

end

class Graph
	attr_reader :edges, :head_vertices, :vertices
	def initialize(options)
		@head_vertices = Set.new
		@vertices = {}
		@directed = options[:directed]
		@weighted = options[:weighted]
	end

	def get_or_create(vertex_name)
		unless @vertices.has_key?(vertex_name)
			@vertices[vertex_name] = GraphVertex.new(vertex_name)
		end

		@vertices[vertex_name]
	end

	def tsort
		list = []
		new_head_vertices = Set.new
		until @head_vertices.empty?
			@head_vertices.each do |vertex_n|
				list << vertex_n.data
				@head_vertices.delete(vertex_n)
				vertex_n.outgoing.each do |vertex_m|
					vertex_m.incoming.delete(vertex_n)
					new_head_vertices << vertex_m if vertex_m.incoming.empty?
				end
			end
			@head_vertices.merge(new_head_vertices)
			new_head_vertices.clear
		end
		if @vertices.values.any?{|vertex| !vertex.incoming.empty? && !vertex.outgoing.empty?}
			return "Graph is cyclical!"
		else
			list
		end
	end

	def add_directed_pair(datum1, datum2)
		vertex1 = get_or_create(datum1)
		vertex2 = get_or_create(datum2)
		vertex1.edge_to(vertex2)
	end

	def add_undirected_pair(datum1, datum2)
		vertex1 = get_or_create(datum1)
		vertex2 = get_or_create(datum2)
		vertex1.edge_to(vertex2)
		vertex2.edge_to(vertex1)
	end

	def build_head_vertices
		@vertices.each do |name, vertex|
			@head_vertices << vertex if vertex.incoming.empty?
		end
	end

end