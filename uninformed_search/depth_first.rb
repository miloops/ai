require 'basic_search'

class DepthFirst < BasicSearch

  # 5. Expand _n_, generating all of its successors.
  # Put there successors (in no particular order) on top of OPEN and provide
  # for each a pointer back to _n_.
  def expand_n_and_generate_successors
    @open.unshift(@n.children).flatten!
  end
end
