require 'test/unit'

# rails stuff used (sequence is important)
require 'rubygems'
require 'active_support'
# require 'active_support/core_ext/array/extract_options'
# class Array; include ActiveSupport::CoreExtensions::Array::ExtractOptions; end
# require "active_support/core_ext/hash/keys"
# class Hash; include ActiveSupport::CoreExtensions::Hash::Keys; end
# require 'active_support/core_ext/class/attribute_accessors'

# load plugin
require "#{File.dirname(__FILE__)}/../init"

# mock transmit method to avoid actual http requests
module ServiceInvoker; module Util
  def self.transmit(uri, req, payload);	process_result HTTPResponseMock.new; end
end; end

class HTTPResponseMock
  attr_accessor :to_hash, :body, :code
  def initialize(to_hash = {"some_header" => ["something"]}, body = "foo", code = "200")
    @to_hash = to_hash; @body = body; @code = code
  end
end
    
# puts ServiceInvoker::Util.transmit(nil, nil, nil).code