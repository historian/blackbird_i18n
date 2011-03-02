class Blackbird::I18n::Processor

  def visit_table(table)
    @current_table = table
  end

  def visit_column(column)
    options = column.options

    if options.delete(:localized)
      @current_table.remove_column(column.name)

      I18n.available_locales.each do |locale|
        locale = locale.to_s.gsub('-', '_').downcase
        t_name = "#{column.name}_t_#{locale}"
        f_name = "#{column.name}_f_#{locale}"
        @current_table.add_column(t_name, column.type, options)
        @current_table.add_column(f_name, column.type, options)
      end
    end

  end

end