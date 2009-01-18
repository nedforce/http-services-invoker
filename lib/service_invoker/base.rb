module ServiceInvoker  
  
  # ServiceInvoker can be extended, similar to ActiveRecord, to represent a service. 
  # In a class that extends ServiceInvoker you can define and configure your request builder with
  # request_builder, and also specify response modules with response_module.
  # An instance of ServiceInvoker represents a single request-response pair. It must have a request. 
  # It may have a response, depending on whether do_request has been called on it.
  class Base
    include ActiveSupport::Callbacks
    define_callbacks :before_request, :after_request
    
    # define the request builder class that should be used to build requests.
    # takes a request builder class and a set of args, like:
    #   request_builder BasicBuilder, 
    #     :endpoint_url => "http://www.google.com/uds/GwebSearch",
    # args are passed to the builder initialize method
    def self.request_builder(mod, *args)
      
      @request_builder_class = mod
      @request_builder_args = args
    end    
    
    # Define a response module that will be included in the response object.
    # Takes a module, like:
    #   	response_module JSONProcessing
    def self.response_processor(mod)

      @response_modules ||= []
      @response_modules << mod
    end
    
    # this class is fake (does no requests)
    def self.fake
      self.class_eval do
        def do_request
          run_callbacks(:before_request)
          @response = self.class.get_response_class.new("foo", {"bar" => "henk"})
          run_callbacks(:after_request)
          @response
        end
      end
    end
    
    # gets request builder instance
    def self.get_request_builder
      if defined?(@request_builder_class)
        @request_builder_class.new(*@request_builder_args)
      else
        AbstractBuilder.new
      end
    end

    # shortcut for get_request_builder.build(args)
    def self.build_request(*args)
      self.get_request_builder.build(*args)
    end
     
    # get a response class with all response modules
    def self.get_response_class
      result = Class.new(Response)
      
      # add response modules
      @response_modules.each do |mod|
        result.send :include, mod
      end if defined?(@response_modules)
      
      @response_class = result
    end
    
    # shortcut for build_request and instantiate and do_request, returns instance
    # containing request and response
    def self.instance(*args)
      request = self.build_request(*args)
      instance = self.new(request)
      instance.do_request()
      instance
    end
    
    # invoke, same as request but returns only response
    def self.invoke(*args)
      self.instance(*args).response
    end
    
    # returns rails default logger
    def self.logger
      RAILS_DEFAULT_LOGGER
    end

    # the response returned do_request
    attr_reader :response
    # this is the request that will be used on do_request    
    attr_reader :request
    
    def request= req      
      raise(ArgumentError, "request must be of type ServiceInvoker::Request but was #{req.class.name}") unless req.is_a? Request
      @request = req
    end
    
    def initialize(request)
      self.request = request
    end

    # does a request and returns an object containing all processors
    # from all response_module statements
    # handles before and after execute filters
    # handles basic auth, redirects, some error handling    
    def do_request
      run_callbacks(:before_request)
  		http_response = execute_inner
  		@response = self.class.get_response_class.new(http_response.body, Util.get_decent_headers(http_response))
      run_callbacks(:after_request)
  		@response
    end
  	
  	private
  	
  	def execute_inner
  	  execute_no_redirect
	  rescue Redirect => e
  		@request.url = e.message
  		execute_inner
	  end
  	
  	def execute_no_redirect
  		uri = Util.parse_url(@request.url)
  		req = Util.net_http_class(@request.method).new(uri.request_uri, Util.make_headers(@request.headers))

      # adds basic authorization to a request
  		req.basic_auth(@request.user, @request.password) if @request.user
		
  		Util.transmit(uri, req, @request.raw_data)
  	end
  end
end