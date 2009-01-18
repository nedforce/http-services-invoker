module XMLProcessing
  def unmarshal_xml
    @unmarshalled_xml ||= Hash.from_xml(raw_data)
  end
end