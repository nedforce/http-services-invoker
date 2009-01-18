module ServiceInvoker

  # an http message
  class AbstractMessage
    attr_reader :raw_data
    attr_reader :headers
  
    def initialize
      raise "Cannot instantiate #{self.class.name} directly"
    end
    
    def initialize_package _raw_data, _headers
      @raw_data = _raw_data
      @headers = _headers
    end
  end
end