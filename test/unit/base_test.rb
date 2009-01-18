require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase

  def test_invoke
    assert_nothing_raised do
      request = ServiceInvoker::Request.new(:url => "mocked")      
      consumer = ServiceInvoker::Base.new(request)
      response = consumer.do_request()
      assert_equal "foo", response.raw_data
    end
  end
  
  def test_should_build
    request = ServiceInvoker::Base.build_request(:url => "mocked")
  end
  
  def test_should_instantiate
    instance = ServiceInvoker::Base.instance(:url => 'mocked', :method => :get)
    assert_equal "foo", instance.response.raw_data
  end
end
