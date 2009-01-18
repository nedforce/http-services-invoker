# constructs and XMLRPC request and wraps it in an HTTP Post request. Uses XMLRPC from ruby stdlib.
class XMLRPCBuilder < BasicBuilder
  
  # build a request, valid options:
  # 
  # * <tt>:name</tt>: the name of the xml-rpc method to call
  # * <tt>:args</tt>: an array of arguments
  def build(options = {})
    name = options.delete(:name)
    args = options.delete(:args)
    super(options.merge!({:raw_data => XMLRPC::Marshal.dump_call(name, *args), :method => :post}))
  end
end