# Rails\portfolio\config\initializers\cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # Cambia "http://localhost:3001" por la URL de tu frontend
      origins 'http://localhost:3001'
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
  