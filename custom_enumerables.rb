# Remove '#'s at the bottom to run the comparison scripts.

module Enumerable
  def my_each
    if block_given?
      for i in self
        yield(self[index(i)])
      end
    else
      return self.to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      for i in self
        yield(self[index(i)], index(i))
      end
    else
      return self.to_enum(:my_each_with_index)
    end
  end

  def my_select
    arr = []
    if block_given?
      for i in self
        arr.push(self[index(i)]) if yield(self[index(i)])
      end
      arr
    else
      return self.to_enum(:my_select)
    end
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

  def my_map(block = nil)
    result = []
    if block.nil?
      if block_given?
        puts 'in block'
        my_each do |item|
          result << yield(self[index(item)])
        end
        result
      else
        to_enum(:my_map)
      end
    else
      puts 'in proc'
      my_each do |item|
        result << block.call(self[index(item)])
      end
      result
    end
  end

  def my_inject(*args)
    unshift(args[0]) unless args.empty? || args[0].is_a?(Symbol)
    if block_given?
      sum = yield(self[0], self[1])
      my_each do |item|
        delete_at(1)
        if self[1].nil?
          return sum
        else
          sum = yield(sum, self[1])
        end
      end
    else
      meth = args.select {|item| item.is_a?(Symbol)}[0]
      sum = self[0]
      delete_at(0)
      my_each do |item|
        sum = sum.method(meth).(item)
      end
    end
    sum
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

def compare_map
  puts 'my_count vs. count'
  puts '___________________'
  numbers = [1, 2, 3, 4, 5]
  puts "#map > #{numbers.map {|num| num * 2 }} \n#my_map > #{numbers.my_map {|num| num * 2 }}"

  puts "#{numbers} unchanged"

  my_proc = proc { |num| num * 3 }
  puts 'With only proc'
  p numbers.my_map(my_proc)
  puts 'Proc and block chained'
  p numbers.my_map(my_proc) {|num| num * 2}
end

def compare_inject
  puts 'my_inject vs. inject'
  numbers = [1, 2, 3, 4, 5]

  basic_inject = numbers.inject {|a, b| a + b}
  basic_my_inject = numbers.my_inject {|a, b| a + b}
  puts "#my_inject > #{basic_my_inject}\n#inject > #{basic_inject}"
  puts "#my_inject > #{[3, 6, 10, 13].inject(0, :+)}\n#inject > #{[3, 6, 10, 13].inject(0, :+)}"
  puts '#my_inject filtering and creating a new array'
  a = [10, 20, 30, 5, 7, 9, 3].my_inject([]) do |result, element| 
    result << element.to_s if element > 9
    result
  end
  p a
end

def multiply_els(arr)
  arr.my_inject(:*)
end

#compare_each
#compare_each_with_index
#compare_select
#compare_all?
#compare_any?
#compare_none?
#compare_count
#compare_map
#compare_inject
#p multiply_els([2, 4, 5])
