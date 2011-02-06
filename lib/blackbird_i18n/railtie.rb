class Blackbird::I18n::Railtie < Rails::Engine

  config.blackbird.processors.use 'Blackbird::I18n::Processor'

  config.blackbird_i18n = ActiveSupport::OrderedOptions.new
  config.blackbird_i18n.locales = Blackbird::I18n::Locales.new

  initializer "blackbird_i18n.setup_configuration" do |app|
    ::I18n.locales = app.config.blackbird_i18n.locales
  end

end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, Blackbird::I18n::ActiveRecordExtensions)
end

ActiveSupport.on_load(:i18n) do
  I18n.send(:include, Blackbird::I18n::I18nExtensions)
end