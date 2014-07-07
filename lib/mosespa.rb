require_relative 'm.rb'
require_relative 'search.rb'

# monkey patch table_print
module TablePrint
  module RowRecursion
    def horizontal_separator
      ""
    end
  end

  #taken from https://github.com/arches/table_print/pull/45
  class FixedWidthFormatter

    def strip_escape(value)
      value.gsub(%r{\e[^m]*m}, '')
    end

    def format(value)
      padding = width - strip_escape(value.to_s).each_char.collect{|c| c.bytesize == 1 ? 1 : 2}.inject(0, &:+)
      truncate(value) + (padding < 0 ? '' : " " * padding)
    end

    def truncate(value)
      return "" unless value
      value = value.to_s
      return value unless strip_escape(value).length > width
      "#{value[0..width-4]}..."
    end
  end
end
