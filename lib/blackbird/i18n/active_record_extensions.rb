module Blackbird::I18n::ActiveRecordExtensions

  def defined_attribute_locales
    @defined_attribute_locales ||= begin
      if superclass.respond_to?(:defined_attribute_locales)
        attributes = superclass.defined_attribute_locales
        attributes.inject({}) do |memo, (name, locales)|
          memo[name] = locales.dup
          memo
        end
      else
        {}
      end
    end
  end

  def define_attribute_methods
    return if attribute_methods_generated?

    super

    columns_hash.keys.each do |full_name|
      next unless full_name =~ /^(.+)_t_([a-z]{2}(?:_[a-z]{2})?)$/

      attr_name, locale = $1, $2

      self.defined_attribute_locales[attr_name] ||= []
      self.defined_attribute_locales[attr_name] << locale

      attribute_method_matchers.each do |matcher|
        method_name = matcher.method_name(attr_name)

        unless instance_method_already_implemented?(method_name)
          generate_method = "define_method_#{matcher.prefix}i18n_attribute#{matcher.suffix}"

          if respond_to?(generate_method)
            send(generate_method, attr_name)

          else
            generated_attribute_methods.module_eval(%{
              if method_defined?(:#{method_name})
                undef :#{method_name}
              end
              def #{method_name}(*args)
                send(:#{matcher.method_missing_target}, '#{attr_name}', *args)
              end
            }, __FILE__, __LINE__ + 1)
          end
        end
      end

      method_name = "#{attr_name}_translations"
      unless instance_method_already_implemented?(method_name)
        generate_method = "define_method_all_i18n_attribute"
        send(generate_method, attr_name)
      end

      method_name = "#{attr_name}_translations="
      unless instance_method_already_implemented?(method_name)
        generate_method = "define_method_all_i18n_attribute="
        send(generate_method, attr_name)
      end
    end

  end

  def define_method_i18n_attribute_before_type_cast(name)
    generated_attribute_methods.module_eval(%{
      def #{name}_before_type_cast(fallback=false)
        locale    = I18n.locale.to_s.gsub('-', '_').downcase
        full_name = "#{name}_\#{(fallback ? 'f' : 't')}_\#{locale}"
        __send__("\#{full_name}_before_type_cast")
      end
    }, __FILE__, __LINE__)
  end

  def define_method_i18n_attribute(name)
    generated_attribute_methods.module_eval(%{
      def #{name}(fallback=true)
        locale    = I18n.locale.to_s.gsub('-', '_').downcase
        full_name = "#{name}_\#{(fallback ? 'f' : 't')}_\#{locale}"
        __send__(full_name)
      end
    }, __FILE__, __LINE__)
  end

  def define_method_i18n_attribute=(name)
    generated_attribute_methods.module_eval(%{
      def #{name}=(value)
        locale    = I18n.locale.to_s.gsub('-', '_').downcase
        full_name = "#{name}_t_\#{locale}="
        __send__(full_name, value)
      end
    }, __FILE__, __LINE__)
  end

  def define_method_i18n_attribute?(name)
    generated_attribute_methods.module_eval(%{
      def #{name}?(fallback=true)
        locale    = I18n.locale.to_s.gsub('-', '_').downcase
        full_name = "#{name}_\#{(fallback ? 'f' : 't')}_\#{locale}?"
        __send__(full_name)
      end
    }, __FILE__, __LINE__)
  end

  def define_method_all_i18n_attribute(name)
    generated_attribute_methods.module_eval(%{
      def #{name}_translations(fallback=true)
        fallback = (fallback ? 'f' : 't')
        I18n.available_locales.inject({}) do |memo, locale|
          l            = locale.to_s.gsub('-', '_').downcase
          full_name    = "#{name}_\#{fallback}_\#{l}"
          memo[locale] = __send__(full_name)
          memo
        end
      end
    }, __FILE__, __LINE__)
  end

  def define_method_all_i18n_attribute=(name)
    generated_attribute_methods.module_eval(%{
      def #{name}_translations=(hash)
        hash.each do |locale, value|
          l         = locale.to_s.gsub('-', '_').downcase
          full_name = "#{name}_t_\#{l}="
          __send__(full_name, value)
        end
        hash
      end
    }, __FILE__, __LINE__)
  end

end