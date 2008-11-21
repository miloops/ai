class Node
  attr_accessor :name, :start_node, :dead_end, :parent, :goal, :children

  def initialize(args = {})
    @name         = args[:name]
    @parent       = args[:parent]
    @start_node   = args[:start_node] || false
    @dead_end     = args[:dead_end]   || false
    @goal         = args[:goal]       || false
  end
  
  def depth
    count = 0
    node = self
    while !node.parent.nil?
      count += 1
      node = node.parent
    end
    count
  end
end