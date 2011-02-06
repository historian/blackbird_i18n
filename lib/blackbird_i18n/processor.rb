class Blackbird::I18n::Processor

  def visit_table(table)
    @current_table = table
  end

  def visit_column(column)
    options = column.options

    if options.delete(:localized)
      @current_table.remove_column(column.name)

      I18n.locales.each do |locale|
        name = "#{column.name}_t_#{locale.gsub('-', '_').downcase}"
        @current_table.add_column(name, column.type, options)
      end
    end

  end

end