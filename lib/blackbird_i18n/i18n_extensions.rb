module Blackbird::I18n::I18nExtensions

  extend ActiveSupport::Concern

  module ClassMethods

    attr_accessor :locales

    def locales
      @locales ||= Blackbird::I18n::Locales.new
    end

  end

end