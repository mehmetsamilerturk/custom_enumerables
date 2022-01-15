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

  def my_none?
    result = true
    if block_given?
      my_each do |item|
        if yield(self[index(item)])
          return result = false
        else
          result = true
        end
      end
    else
      my_each do |item|
        return result = false if item
      end
    end
    result
  end

  def my_count
    result = []
    if block_given?
      my_each do |item|
        result << item if yield(self[index(item)])
      end
      return result.size
    else
      return self.size
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

def compare_all?
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

def compare_any?
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

def compare_none?
  puts 'my_none? vs. none?'
  numbers = [1, 2, 3, 4, 5]
  arr = [nil, nil, false]
  a = numbers.my_none? { |num| num > 5}
  b = numbers.none? { |num| num > 5}

  puts 'Block given'
  p "my_none?: #{a}"
  p "none?: #{b}"

  puts 'Without a block'
  p arr
  p arr.my_none?
  p arr.none?
end

def compare_count
  puts 'my_count vs. count'
  puts '___________________'
  numbers = [1, 2, 3, 4, 5]
  puts "#count > #{numbers.count} \n#my_count > #{numbers.my_count}"
  puts
  a = numbers.count {|num| num > 3}
  b = numbers.my_count {|num| num > 3}
  puts "#count > #{a} \n#my_count > #{b}"
end

#compare_each
#compare_each_with_index
#compare_select
#compare_all?
#compare_any?
#compare_none?
#compare_count