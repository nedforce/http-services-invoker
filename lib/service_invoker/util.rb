require 'net/http'

module ServiceInvoker
  
  # methods to work with Net::HTTP
  # and errors
  module Util

    # replaces underscores, adds default accept header
    def self.make_headers(user_headers)
    	final = {}
    	user_headers.keys.each do |key|
    		final[key.to_s.gsub(/_/, '-').capitalize] = user_headers[key]
    	end
    	final
    end		

    # http class for a method
    def self.net_http_class(method)
    	Object.module_eval "Net::HTTP::#{method.to_s.capitalize}"
    end

    # adds protocol, creates URI object
    def self.parse_url(url)
    	url = "http://#{url}" unless url.match(/^http/)
    	URI.parse(url)
    end

    # transmits a request
    def self.transmit(uri, req, payload)
    	Net::HTTP.start(uri.host, uri.port) do |http|
    		process_result http.request(req, payload || "")
    	end
    end

    # sends approprate error messages based on a HTTP response
    # or returns the response if everything is OK
    def self.process_result(res)
    	if %w(200 201 202).include? res.code
    		res
    	elsif %w(301 302 303).include? res.code
    		raise Redirect, res.header['Location']
    	elsif res.code == "401"
    		raise Unauthorized
    	else
    		raise RequestFailed, error_message(res)
    	end
    end

    # good error message
    def self.error_message(res)
    	"HTTP code #{res.code}: #{res.body}"
    end
    
    # extends base_url with relative_url
  	def extended_url base_url, relative_url
      while base_url =~ /\/$/
        base_url = base_url[0..-2]
      end
      while relative_url =~ /^\//
        relative_url = relative_url[1..-1]
      end
      base_url + '/' + relative_url
    end
    
    def self.make_url_params(p)
			p.keys.map { |k| "#{k}=#{URI.escape(p[k].to_s)}" }.join("&")
		end
		
		def self.get_decent_headers(http_response)
		  headerhash = http_response.to_hash
      headerhash.each{|o| headerhash[o[0].downcase] = o[1].to_s}
      headerhash
    end		
  end
  
  # A redirect was encountered; caught by execute to retry with the new url.
  class Redirect < RuntimeError; end

  # Request failed with an unhandled http error code.
  class RequestFailed < RuntimeError; end

  # Authorization is required to access the resource specified.
  class Unauthorized < RuntimeError; end
  
  # used in other places, helps with testing
  class GeneralError < RuntimeError; end
  
end