module ServiceInvoker
  # can be extended using subclasses
  class Response < AbstractMessage
    def initialize _raw_data, _headers = {}
      initialize_package _raw_data, _headers
    end
  end
end