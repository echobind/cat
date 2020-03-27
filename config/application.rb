require_relative 'boot'

require 'rails/all'
require 'flipper/middleware/memoizer'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTemplate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    
    # https://gist.github.com/maxivak/381f1e964923f1d469c8d39da8e2522f
    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    if Rails.env == 'production'
      config.middleware.use Flipper::Middleware::Memoizer, preload_all: true
    end
  end
end
