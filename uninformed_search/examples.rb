require 'depth_first'
require 'breadth_first'

# Create some nodes
@a = Node.new(:name => "A", :start_node => true)

# A children
@b = Node.new(:name => "B", :parent => @a)
@f = Node.new(:name => "F", :parent => @a)
@j = Node.new(:name => "J", :parent => @a, :dead_end => true)
@k = Node.new(:name => "K", :parent => @a, :dead_end => true)

@a.children = [@b, @f, @j, @k]

# B children
@c = Node.new(:name => "C", :parent => @b, :dead_end => true)
@d = Node.new(:name => "D", :parent => @b)

@b.children = [@c, @d]

# D children
@e = Node.new(:name => "E", :parent => @d, :dead_end => true)
@d.children = [@e]

# F child
@g = Node.new(:name => "G", :parent => @f)
@f.children = [@g]

# G child
@h = Node.new(:name => "H", :parent => @g)
@g.children = [@h]

# H childs
@i = Node.new(:name => "I", :parent => @h, :dead_end => true, :goal => true)
@h.children = [@i]

# Let's start the search
@depth_first = DepthFirst.new(@a)

# Run the search and seek a solution
@depth_first.run!

# Let's start the search
@breadth_first = BreadthFirst.new(@a)

# Run the search and seek a solution
@breadth_first.run!
