Rswag::Ui.configure do |c|

  # List the Swagger endpoints that you want to be documented through the
  # swagger-ui. The first parameter is the path (absolute or relative to the UI
  # host) to the corresponding endpoint and the second is a title that will be
  # displayed in the document selector.
  # NOTE: If you're using rspec-api to expose Swagger files
  # (under openapi_root) as JSON or YAML endpoints, then the list below should
  # correspond to the relative paths for those endpoints.

  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'

  # Add this to force HTTPS in production
  c.config_object[:url] = if Rails.env.production?
    # Use your actual deployed domain
    "https://event-booking-x21f.onrender.com/api-docs/v1/swagger.yaml"
  else
    "/api-docs/v1/swagger.yaml"
  end

  # Force HTTPS for all schemes in production
  c.config_object[:schemes] = if Rails.env.production?
    ['https']
  else
    ['http']
  end
end
