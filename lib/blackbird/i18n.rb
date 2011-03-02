require 'blackbird'

# I18n Options of interest:
#  * I18n.locale
#  * I18n.default_locale
#  * I18n.available_locales
#  * I18n.fallbacks
module Blackbird::I18n

  require 'blackbird/i18n/version'
  require 'blackbird/i18n/active_record_extensions'
  require 'blackbird/i18n/processor'

  if defined? ::Rails::Railtie
    require 'blackbird/i18n/railtie'
  end

end