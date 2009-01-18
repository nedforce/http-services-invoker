module XMLRPCProcessing
  def self.included(mod)
    unless mod.kind_of? XMLProcessing
      mod.send(:include, XMLProcessing)
    end
  end
  
  def unmarshal_xmlrpc
    @unmarshalled_xmlrpc ||= XMLRPC::Marshal.load_response(raw_data)
  end
end