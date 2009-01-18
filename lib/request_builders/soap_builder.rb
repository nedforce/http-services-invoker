# experimental
class SOAPBuilder < BasicBuilder
  
  def build(options = {})
    object = options.delete(:object)
    mapping = options.delete(:mapping)
    super(options.merge!({:raw_data => SOAP::Marshal.marshal(object, mapping), :method => :post}))
  end
end
