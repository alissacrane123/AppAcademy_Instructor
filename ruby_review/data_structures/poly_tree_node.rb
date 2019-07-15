module Searchable

  def dfs(target_value = nil, &prc)
    raise "need proc or target" if [target_value, prc].none?
    prc ||= Proc.new { |node| node.value == target_value }
    
    # first check value at this node
    # return value if node's value matches target
    return self if prc.call(self)

    # if not, iterate through children and repeat
    children.each do |child|
      result = child.dfs(target_value, prc)
      return result unless result.nil?
    end

    nil
  end

  def bfs(target_value = nil, &prc)
    raise "need proc or target" if [target_value, prc].none?
    prc ||= Proc.new { |node| node.value == target_value }

    queue = [self]

    until queue.empty?
      current_node = queue.shift 
      return self if prc.call(current_node)
      queue.concat(current_node.children)
    end

    nil
  end
end


class PolyTreeNode
  attr_accessor :value, :children
  attr_reader :parent

  def initialize(value = nil)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(new_parent)
    return if self.parent == new_parent 

    # first detach node from current parent
    if self.parent 
      self.parent._children.delete(self)
    end

    # make new_parent this node's parent
    @parent = new_parent 

    # add self to new parent's children unless the parent is nil
    self.parent._children << self unless self.parent.nil?

    self 
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    if child_node && !self._children.include?(child_node)
      raise "tried to remove node that isn't child"
    end

    child_node.parent = nil
  end

  protected 

  # protected method gives an instance of class access to 
  # instance methods, but makes unavailable outside of class
  # ( gives node direct access to another node's children )

  def _children 
    @children 
  end
end