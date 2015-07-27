num_testcases = gets.to_i
num_testcases.times do
  numbers = gets.split.map{|s| s.to_i}
  a = numbers[0]
  b = numbers[1]
  puts "#{a+b} #{a-b}"
end
