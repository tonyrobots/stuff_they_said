require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Statement.new.valid?
  end
end
