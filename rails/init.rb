
# # Register the processor
Blackbird.options[:processors].use 'Blackbird::I18n::Processor'

# Extend Active Record
ActiveRecord::Base.extend Blackbird::I18n::ActiveRecordExtensions

# Extend I18n
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
