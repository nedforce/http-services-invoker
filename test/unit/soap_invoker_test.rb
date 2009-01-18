require File.dirname(__FILE__) + '/../test_helper'

class SoapTestClass < ServiceInvoker::Base
  request_builder SOAPBuilder, :endpoint_url => 'bla'
  response_processor SOAPProcessing
end

class SOAPInvokerTest < Test::Unit::TestCase
  def setup
  end
  
  def test_should_invoke
    assert_nothing_raised do
      instance = SoapTestClass.instance(:object => 'jow', :url_path => '/jow')
      assert_equal 'bla/jow', instance.request.url
      assert_equal "foo", instance.response.raw_data
      assert_kind_of SOAPProcessing, instance.response
    end    
  end  
end
