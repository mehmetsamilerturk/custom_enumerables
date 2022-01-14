module Enumerable
  def my_each
    for i in self
      yield(self[index(i)])
    end
  end

  def my_each_with_index
    for i in self
      yield(self[index(i)], index(i))
    end
  end

  def my_select
    arr = []
    for i in self
      arr.push(self[index(i)]) if yield(self[index(i)])
    end
    arr
  end

  def my_all?
    result = false
    if block_given?
      my_each do |item|
        if yield(self[index(item)])
          result = true 
        else
          return result = false
        end
      end
    else
      my_each do |item|
        item ? result = true : result = false
      end
    end
    result
  end

  def my_any?
    result = false
    if block_given?
      my_each do |item|
        if yield(self[index(item)])
          return result = true 
        else
          result = false
        end
      end
    else
      my_each do |item|
        return result = true if item
      end
    end
    result
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

def compare_each_with_index
  puts 'my_each_with_index vs. each_with_index'
  numbers = [1, 2, 3, 4, 5]
  a = numbers.my_each_with_index { |item, index| p "#{index} > #{item}" }
  puts
  b = numbers.each_with_index { |item, index| p "#{index} > #{item}" }

  p "my_each_with_index: #{a}"
  p "each_with_index: #{b}"
end

def compare_select
  puts 'my_select vs. select'
  numbers = [1, 2, 3, 4, 5]
  a = numbers.my_select {|item| item > 3}
  b = numbers.select {|item| item > 3}

  p "my_select: #{a}"
  p "select: #{b}"
end

def compare_my_all?
  puts 'my_all? vs. all?'
  numbers = [1, 2, 3, 4, 5, nil]

  a = numbers.my_all? {|num| num > 3}
  b = numbers.all? {|num| num > 3}

  puts 'Block given'
  p "my_all?: #{a}"
  p "all?: #{b}"

  puts 'Without a block'
  p numbers.my_all?
  p numbers.all?
end

def compare_my_any?
  puts 'my_any? vs. any?'
  numbers = [1, 2, 3, 4, 5, nil, false, false]

  a = numbers.my_any? {|num| num > 4}
  b = numbers.any? {|num| num > 4}

  puts 'Block given'
  p "my_any?: #{a}"
  p "any?: #{b}"

  puts 'Without a block'
  p numbers.my_any?
  p numbers.any?
end

#compare_each
#compare_each_with_index
#compare_select
#compare_my_all?
#compare_my_any?