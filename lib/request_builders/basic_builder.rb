# Adds endpoint url and default get params configuration options, and
# post params, url params and url path build options
class BasicBuilder < ServiceInvoker::AbstractBuilder
  attr_accessor :endpoint_url
  attr_accessor :default_get_params
  
  def initialize(options = {})
    raise GeneralError, "endpoint url required" unless options.include?(:endpoint_url)
    @endpoint_url = options[:endpoint_url]
    @default_get_params = options[:default_get_params]
  end
  
  def build(options = {})
    options.assert_valid_keys *((ServiceInvoker::Request::VALID_KEYS - [:url]) + [:url_path, :post_params])
    if options.include?(:raw_data) && options.include?(:post_params)
      raise ArgumentError, "use either :raw_data or :post_params"
    end
    options[:raw_data] = ServiceInvoker::Util.make_url_params(options[:post_params]) if options.include?(:post_params)
    options[:url] = @endpoint_url + (options[:url_path] || '')
    options[:url_params] = @default_get_params.merge(options[:url_params]) if @default_get_params && (options[:method] == :get || !options[:method])
    options.delete(:url_path)
    options.delete(:post_params)
    
    ServiceInvoker::Request.new(options)
  end
end