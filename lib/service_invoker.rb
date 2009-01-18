current_dir = File.dirname(__FILE__)

%w(
  abstract_message
  abstract_builder
  request
  response
  util
  base
).each do |file|  
  require "#{current_dir}/service_invoker/#{file}.rb"
end