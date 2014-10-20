#!/usr/bin/env ruby

require "webrick"

=begin
    WEBrick is a Ruby library that makes it easy to build an HTTP server with Ruby. 
    It comes with most installations of Ruby by default (itâ€™s part of the standard library), 
    so you can usually create a basic web/HTTP server with only several lines of code.
    
    The following code creates a generic WEBrick server on the local machine on port 1234, 
    shuts the server down if the process is interrupted (often done with Ctrl+C).

    This example lets you call the URL's: "add" and "subtract" and pass through arguments to them

    Example usage: 
        http://localhost:1234/run [POST with an input=<json> param]
=end

class MyNormalClass
    def self.add (a, b)
        a.to_i + b.to_i
    end
    
    def self.subtract (a, b)
        a.to_i - b.to_i
    end
end

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET (request, response)
	response.status = 500
	response.content_type = "text/plain"
	response.body = "get lost\n"
    end

    def do_POST (request, response)
	output=""
	case request.path
		when "/run"
			json = request.query["input"]
			output+="========= success ==========\n"
			output+=json
			output+="\n============================\n"
			response.status = 200
		else
			output+="failure"
			response.status = 404
	end
	response.content_type = "text/plain"
	response.body = output+ "\n"
    end
end

server = WEBrick::HTTPServer.new(:Port => 1234)

server.mount "/", MyServlet

trap("INT") {
    server.shutdown
}

server.start
