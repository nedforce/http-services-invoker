require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < Test::Unit::TestCase

  def test_constructor
    assert_raise(ArgumentError) {ServiceInvoker::Request.new(:method => :foo)}
    assert_raise(ArgumentError) {ServiceInvoker::Base.build_request(:method => :foo)}
    assert_raise(ArgumentError) {ServiceInvoker::Request.new(:foo => :bar)}
    assert_raise(ArgumentError) {ServiceInvoker::Base.build_request(:foo => :bar)}    
    assert_nothing_raised do
      request = ServiceInvoker::Request.new(:url => 'mocked', :method => :get, :headers => {'foo' => 'bar'}, :raw_data => 'foo', :user => 'baz', :password => 'foo', :url_params => {'foo' => 'bar'})
      assert_equal 'mocked?foo=bar', request.url
      assert_equal({'foo' => 'bar'}, request.headers)
    end
  end
end
