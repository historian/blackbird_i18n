class Blackbird::I18n::Railtie < Rails::Engine

  config.blackbird.processors.use 'Blackbird::I18n::Processor'

end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, Blackbird::I18n::ActiveRecordExtensions)
end

ActiveSupport.on_load(:i18n) do
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
end