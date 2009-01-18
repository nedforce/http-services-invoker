require File.dirname(__FILE__) + '/../test_helper'

class XmlrpcTestClass < ServiceInvoker::Base
  request_builder XMLRPCBuilder, :endpoint_url => 'bla'
  response_processor XMLRPCProcessing
end

class XMLRPCInvokerTest < Test::Unit::TestCase
  def setup
  end
  
  def test_should_invoke
    assert_nothing_raised do
      instance = XmlrpcTestClass.instance(:name => 'jow', :args => ['bla'], :url_path => '/jow')
      assert_equal 'bla/jow', instance.request.url
      assert_equal "foo", instance.response.raw_data
      assert_kind_of XMLRPCProcessing, instance.response
    end    
  end  
end
