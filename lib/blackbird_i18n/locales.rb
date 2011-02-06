class Blackbird::I18n::Locales

  include Enumerable

  def initialize
    @default = 'en'
    @map = {}
    @locales = Set.new(['en'])
  end

  attr_accessor :default

  def [](locale)
    locale = locale.to_s
    if @map.key?(locale)
      [locale, @map[locale], @default].flatten.uniq
    elsif locale =~ /([a-z]+)[-_]([A-Z]+)/
      [locale, $1, @default].compact.uniq
    else
      [locale, @default].compact.uniq
    end
  end

  def []=(locale, fallbacks)
    @map[locale.to_s] = [fallbacks].flatten.collect { |l| l.to_s }.uniq.compact
  end

  def <<(locale)
    @locales << locale.to_s unless locale.nil?
  end

  def concat(locales)
    locales.each { |l| self << l }
    self
  end

  def size
    @locales.size
  end

  def delete(locale)
    locale = locale.to_s
    @map.delete(locale)
    @locales.delete(locale)
  end

  def include?(locale)
    @locales.include?(locale.to_s)
  end

  def default=(locale)
    @default = (locale ? locale.to_s : nil)
  end

  def each
    @locales.each do |locale|
      yield(locale)
    end
  end

end