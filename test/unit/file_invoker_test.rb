require File.dirname(__FILE__) + '/../test_helper'

class FileTestClass < ServiceInvoker::Base
  request_builder BasicBuilder, :endpoint_url => 'mocked'
  response_processor FileProcessing
end

class FileInvokerTest < Test::Unit::TestCase
  def setup
  end
  
  def test_should_invoke
    assert_nothing_raised do
      instance = FileTestClass.instance(:url_path => '/mocked')
      assert_equal 'mocked/mocked', instance.request.url
      assert_equal "foo", instance.response.raw_data
      assert_kind_of FileProcessing, instance.response
      assert_kind_of Tempfile, instance.response.tempfile
    end    
  end  
end
