module Last
module Endpoints

class Endpoint
  HTTP_STATUS_CODE_FOR_EXCEPTION = 500

  def call(env)
    @env      = env
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    response["Content-Type"] = "application/json"

    begin
      response.write(command)
    rescue => exception
      rescue_exception(exception)
    end

    response.finish
  end

private

  attr_reader :env
  attr_reader :request
  attr_reader :response

  def command
    raise NoMethodError
  end

  def rescue_exception(exception)
    if exception.respond_to?(:http_status)
      status  = exception.respond_to?(:http_status) ? exception.http_status : HTTP_STATUS_CODE_FOR_EXCEPTION
      message = exception.message

      response.status = status
      response.write %Q{{"error": "#{message}"}}
    else
      raise exception
    end
  end
end

end
end
