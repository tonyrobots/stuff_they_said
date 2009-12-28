require 'test_helper'

class WhoisTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Whois.new.valid?
  end
end
