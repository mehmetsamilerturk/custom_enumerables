module Enumerable
  def my_each
    for i in self
      yield(self[self.index(i)])
    end
  end
end

def compare_each
  puts 'my_each vs. each'
  numbers = [1, 2, 3, 4, 5]
  a = numbers.my_each { |item| p item }
  puts
  b = numbers.each { |item| p item }

  p "my_each: #{a}"
  p "each: #{b}"
end

#compare_each