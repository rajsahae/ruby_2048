#!/unr/bin/env ruby
# encoding: UTF-8

################################################################################
# All of the methods in this module take an array of arrays, and will return a
# "value" for that board. 
#
# Depending on the method, the better board may be higher or lower value.
################################################################################

require 'matrix'

module Ruby2048::ValuationFunctions
  # Higher score is better. It means more empty cells
  def empty_cell_valuation(board)
    board.flatten.keep_if(&:nil?).size
  end

  # Lower score means a 'smoother' board
  def smoothness_valuation(board)
    matrix = Matrix.build(board.size, board.first.size) do |row, col|
      board[row][col]
    end

    smoothness = 0

    matrix.row_size.times do |row|
      vector = matrix.row(row).collect{|n| n.nil? ? 0 : n}
      smoothness += vector_smoothness(vector)
    end

    matrix.column_size.times do |col|
      vector = matrix.column(col).collect{|n| n.nil? ? 0 : n}
      smoothness += vector_smoothness(vector)
    end

    smoothness
  end

  private
  def vector_smoothness(vector)
    left_operand = vector.to_a.slice(0...-1)
    right_operand = vector.to_a.slice(1..-1)
    
    left_operand.zip(right_operand).inject(0) do |memo, ary|
      memo += (ary.last - ary.first).abs
    end
  end

end

