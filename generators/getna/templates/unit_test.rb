require File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../test_helper'
class <%= object_name[:class] %>Test < ActiveSupport::TestCase
  # Substitua isto por seus testes
  def test_truth
    assert true
  end
end
