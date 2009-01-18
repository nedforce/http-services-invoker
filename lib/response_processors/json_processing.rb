module JSONProcessing
  def unmarshal_json
    @unmarshalled_json ||= ActiveSupport::JSON.decode(raw_data)
  end
end