module ServiceInvoker

  # Abstract class for builder classes
  class AbstractBuilder
    
    # Arguments are passed from ServiceInvoker::Base.request_builder
    def initialize options = {}; end
    
    def build options = {}
      ServiceInvoker::Request.new(options)
    end
  end
end