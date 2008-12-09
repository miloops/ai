require 'node'
require File.dirname(__FILE__) + '/../ai_helper'

class BasicSearch
  DEPTH_BOUND = 10

  def initialize(start_node = nil)
    raise ArgumentError, "A start node is required!" unless start_node
    @open, @closed, @full_path = [], [], []
    @n = nil
    @start_node = start_node
  end

  def run!
    puts "Starting #{self.class.name} Search..."
    # 1. Put the start node on OPEN.
    @open << @start_node
    debug_stacks
    # 8. Go to step 2.
    while true
      exit_if_open_node_empty
      remove_topmost_node
      next if clean_up_closed_if_depth_bound_reached
      expand_n_and_generate_successors
      debug_stacks
      if @goal = return_solution_found
        debug_stacks
        break
      end
      remove_dead_ends
    end
    puts "Goal node: #{@goal.name}."
    puts "Solution path: #{@closed.map(&:name).join(' - ')} - #{@goal.name}."
    puts "Complete search path: #{@full_path.map(&:name).join(' - ')} - #{@goal.name}."
  end

  # 2. If OPEN is empty, exit with failure; otherwise continue.
  def exit_if_open_node_empty
    raise "OPEN is empty, no way out!!!" if @open.empty?
  end

  # 3. Remove the topmost node from OPEN and put it on CLOSED. Call this node _n_.
  def remove_topmost_node
    (@n = @open.shift)
    @closed << @n
    @full_path << @n
  end

  # 4. If the depth of _n_ is equal to the depth bound, clean up CLOSED and go to
  # step 2; otherwise continue.
  def clean_up_closed_if_depth_bound_reached
    if @n.depth == DEPTH_BOUND
      clean_up_closed(@n)
      true
    end
    false
  end

  # 6. If any of these successors is a goal node, exit with the solution obtained by
  # tracing back through its pointers; otherwise continue.
  def return_solution_found
    @open.select(&:goal).first
  end

  # 7. If any of these successors is a dead end, remove it from OPEN and clean up CLOSED.
  def remove_dead_ends
    size = @open.size
    for child in @n.children
      if child.dead_end
        @open.delete(child).name
      end
    end
    clean_up_closed(@n) if size != @open.size
  end

  def clean_up_closed(node)
    while !node.parent.nil?
      @closed.delete(node) unless @open.any? {|x| node.children.include? x }
      node = node.parent
    end
  end

  def debug_stacks
    p "OPEN: #{@open.map(&:name).join(' - ')}"
    p "CLOSED: #{@closed.map(&:name).join(' - ')}"
    p "------------------------------------------"
  end
end
