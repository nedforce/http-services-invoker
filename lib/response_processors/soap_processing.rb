module SOAPProcessing
  def unmarshal_soap
    @unmarshalled_soap ||= SOAP::Marshal.unmarshal(raw_data)
  end
end