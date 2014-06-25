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
  public
  def empty_cell_valuation(board)
    board.flatten.keep_if(&:nil?).size
  end

  # Lower score means a 'smoother' board. Lower is better.
  public
  def smoothness_valuation(board)
    matrix = board_to_matrix(board)
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

  # calculate smoothness of a vector
  private
  def vector_smoothness(vector)
    vector_pairs(vector).inject(0) do |memo, ary|
      memo += (ary.last - ary.first).abs
    end
  end

  # Lower score is better. Lower score means more sorted.
  public
  def monotonicity_valuation(board)
    matrix = board_to_matrix(board)
    monotonicity = 0

    matrix.row_size.times do |row|
      vector = matrix.row(row).collect{|n| n.nil? ? 0 : n}
      monotonicity += vector_monotonicity(vector)
    end

    matrix.column_size.times do |col|
      vector = matrix.column(col).collect{|n| n.nil? ? 0 : n}
      monotonicity += vector_monotonicity(vector)
    end

    monotonicity
  end

  # Convert array of arrays to matrix
  private
  def board_to_matrix(board)
    Matrix.build(board.size, board.first.size) do |row, col|
      board[row][col]
    end
  end

  # calculate monotonicity of a vector
  private
  def vector_monotonicity(vector)
    comp_state = nil
    vector_pairs(vector).inject(0) do |memo, pair|

      comp = pair.first <=> pair.last

      if comp_state.nil? && comp == 0
        next memo
      elsif comp_state.nil? && comp != 0
        comp_state = pair.first <=> pair.last
      else
        if comp == comp_state || comp == 0
          next memo
        else
          comp_state = comp
          memo += 1
        end
      end
      memo
    end
  end

  # calculate pairs of elements of a vector
  private
  def vector_pairs(vector)
    left_operand = vector.to_a.slice(0...-1)
    right_operand = vector.to_a.slice(1..-1)
    
    left_operand.zip(right_operand)
  end

end

