=begin
Behold this incomplete class for constructing boxed banners.

Complete this class so that the test cases shown below work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

You may assume that the input will always fit in your terminal window.

Test Cases

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+

banner = Banner.new('')
puts banner
+--+
|  |
|  |
|  |
+--+
=end

class Banner
  MAX_LINE_WIDTH = 80

  def initialize(message, width=nil)
    @message = message

    @width = get_width(width)
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  attr_reader :message, :width

  def get_width(width)
    if width
      [width, MAX_LINE_WIDTH].min
    elsif message.size > MAX_LINE_WIDTH - 6
      MAX_LINE_WIDTH
    else
      message.size + 6
    end
  end

  def horizontal_rule
    '+' + '-' * (width - 2) + '+'
  end

  def empty_line
    '|' + ' ' * (width - 2) + '|'
  end

  def message_line
    if message.size > width - 6
      words = message.split

      line = ''
      multiline = []

      words.each do |word|
        if line.length + word.length + 1 > width - 6
          multiline << line.strip
          line = word + ' '
        else
          line << word + ' '
        end
      end
      multiline << line.strip
    else
      multiline = [message]
    end

    multiline.each_with_object([]) do |line, out|
      out << "|" + line.center(width - 2) + "|"
    end
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner

banner = Banner.new('howdy there', 14)
puts banner

str = 'Complete this class so that the test cases shown below work as intended. ' \
      'You are free to add any methods or instance variables you need. ' \
      'However, do not make the implementation details public.'

banner = Banner.new(str, 40)
puts banner

banner = Banner.new(str)
puts banner
