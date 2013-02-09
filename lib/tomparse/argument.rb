module TomParse

  # Encapsulate a method argument.
  #
  class Argument

    attr_accessor :name

    attr_accessor :description

    attr_accessor :options

    # Create new Argument object.
    #
    # name        - name of argument
    # description - argument description
    #
    def initialize(name, description = '')
      @name = name.to_s.intern
      parse(description)
    end

    # Is this an optional argument?
    #
    # Returns Boolean.
    def optional?
      @description.downcase.include? 'optional'
    end

    # Parse arguments section. Arguments occur subsequent to
    # the description.
    #
    # section - String containing argument definitions.
    #
    # Returns nothing.
    def parse(description)
      desc = []
      opts = []

      lines = description.lines.to_a

      until lines.empty? or /^\s+\:(\w+)\s+-\s+(.*?)$/ =~ lines.first
        desc << lines.shift.chomp.squeeze(" ")
      end

      opts = []
      last_indent = nil

      lines.each do |line|
        next if line.strip.empty?
        indent = line.scan(/^\s*/)[0].to_s.size

        if last_indent && indent > last_indent
          opts.last.description << line.squeeze(" ")
        else
          param, d = line.split(" - ")
          opts << Option.new(param.strip, d.strip) if param && d
        end

        last_indent = indent
      end

      @description = desc.join
      @options     = opts
    end

  end

end