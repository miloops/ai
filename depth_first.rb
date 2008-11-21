require 'node'

class DepthFirst
  DEPTH_BOUND = 10
  # Stacks & Nodes
  attr_accessor :open, :closed, :nodes

  def initialize()
    @nodes  = []
    @open   = []
    @closed = []
  end
  
  def run!
    # 1. Put the start node on OPEN
    @open << start_node
    debug_stacks
    puts "The GOAL is node: #{seek_solution.name}"
  end
  
  def seek_solution
    # 2. If OPEN is empty, exit with failure; otherwise continue
    raise "OPEN is empty, no way out!!!" if @open.empty?
    
    # 3. Remove the topmost node from OPEN and put it on CLOSED. Call this node _n_.
    @closed << (n = @open.shift)
    
    # 4. If the depth of _n_ is equal to the depth bound, clean up CLOSED and go to
    # step 2; otherwise continue.
    if n.depth == DEPTH_BOUND
      clean_up_closed
      seek_solution
    end
    
    # 5. Expand n, generating all of its successors.
    # Put there successors (in no particular order) onn top of OPEN and provide
    # for each a pointer back to _n_.
    @open += n.children(@nodes)
    
    
    # 6. If any of these successors is a goal node, exit with the solution obtained by
    # tracing back through its pointers; otherwise continue.
    if goal = @open.select { |x| x.goal }.first
      debug_stacks
      return goal
    end
    
    # 7. If any of these successors is a dead end, remove it from OPEN and clean up CLOSED
    @open.delete_if { |x| x.dead_end }

    @open = @open.sort_by{|x|x.name}
    debug_stacks

    # 8. Go to step 2.
    seek_solution
  end
  
  def start_node
    @nodes.select { |x| x.start_node }.first
  end
  
  def clean_up_closed
#    @closed.delete_if { |x| x.childen(@nodes) }
  end
  
  def debug_stacks
    p "OPEN: #{@open.map { |x| x.name}.join(' - ')}"
    p "CLOSED: #{@closed.map { |x| x.name}.join(' - ')}"
    p ""  
  end
end

# Create some nodes
@a = Node.new(:name => "A", :start_node => true)
%w(b f j k).each { |letter| eval("@#{letter}=Node.new(:name => '#{letter.upcase}', :parent => @a)") }
@c = Node.new(:name => "C", :parent => @b, :dead_end => true)
@d = Node.new(:name => "D", :parent => @b)
@e = Node.new(:name => "E", :parent => @d, :dead_end => true)
@g = Node.new(:name => "G", :parent => @f)
@h = Node.new(:name => "H", :parent => @g)
@i = Node.new(:name => "I", :parent => @h, :dead_end => true, :goal => true)

# Let's start the search
@depth_first = DepthFirst.new

# Add nodes to search
('a'..'i').each { |var| @depth_first.nodes << instance_variable_get("@#{var}") }

# Run the search and seek a solution
@depth_first.run!