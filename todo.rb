class Todo
	def initialize
		# When using a lot of variables can be beneficial to line equals so it's easier to see what you have declared. Just a suggestion
		@arr          = Array.new
		@sorted_array = @arr
		@sort         = 'recent'
		@add_sort     = false
		puts "We've started a new To-Do List."
		add_item
	end

	def add_item
		puts "What would you like to add?"
		item = gets.chomp
		puts
		@arr.push item
		@sorted_array = @arr
		# Suggest looking into case statements, something like the follow is neater then multiple if statements and perfect for what you are doing
		case @sort
			when 'recent'
			  sort_recent
			when 'old'
			  sort_oldest
			when 'alpha', 'rev alpha'
			  @add_sort = true
			  sort_alpha
		end
	end

	def remove_item
		# Had a quick read and a Kernal#loop is an alternative to while true from what I could see. I can't find anything to say you shouldn't use while true, however when you are in more complex code it can be hard to work out the break cases then just looking at the escape condition
		loop do 
		  puts "What item would you like to remove?"
			item = gets.chomp
			puts
			if @arr.include?(item)
				item_index = @arr.index(item)
				@arr.delete_at(item_index)
				break
			else
				puts "'#{item}' not found"
			end
		end

		if empty?
			puts "Your To-Do list is now empty"
			add_item
		else
			@sorted_array = @arr
			if @sort == 'recent'
				sort_recent
			elsif @sort == 'old'
				sort_oldest
			elsif (@sort == 'alpha') || (@sort == 'rev alplha')
				@add_sort = true
				sort_alpha
			end
		end
	end

	def sort_alpha
		temp_arr    = @arr.clone
		sorted      = []
		first_index = 0
		# Suggested escape condition
		while temp_arr.length > 0
			first      = temp_arr[first_index]
			last       = temp_arr.last
			if first_index == (temp_arr.length - 1)
				sorted.push temp_arr.pop
				first_index = 0
			# Not sure logic is correct with the &&. You are saying if first == last and if first is less then last
			elsif (first.downcase < last.downcase) || ((first.downcase == last.downcase) && (first < last))
				temp_arr.push first
				temp_arr.delete_at(first_index)
				first_index = 0
			else
				first_index = first_index + 1
			end
		end

		@sorted_array = sorted

		# Think you are over complicating with the @add_sort. Remove this handling and keep the sort based upon the @sort
		if @add_sort == true
			if @sort == 'rev alpha'
				@sorted_array = @sorted_array.reverse
			end
		else
			if @sort == 'alpha'
				@sorted_array = @sorted_array.reverse
				@sort = 'rev alpha'
			else
				@sort = 'alpha'
			end
		end
		@add_sort = false
		list_items
	end

	def sort_recent
		@sort = 'recent'
		@sorted_array = @arr.reverse
		list_items
	end

	def sort_oldest
		@sort = 'old'
		@sorted_array = @arr
		list_items
	end

	# Irrelevant method. Only called once, and wraps a single line call. Just use @arr.empty? where required
	private
	def empty?
		@arr.empty?
	end

	def list_items
		puts "Your To-Do List:"
		num = 1
		@sorted_array.each do |items|
			puts "#{num}.  #{items}"
			num = num + 1
		end
		puts
	end
end

to_do_list = Todo.new
# this is the sort of thing I was talking about with the while true conditions. You have embedded multiple whiles and it is starting to harder to read the code
while true
	puts "What would you like to do? (add, remove, sort)"
	input = gets.chomp
	puts
	if input.downcase == 'add'
		to_do_list.add_item
	elsif input.downcase == 'remove'
		to_do_list.remove_item
	elsif input.downcase == 'sort'
		while true
			puts "How would you like to sort your list? (recent, oldest, alpha)"
			sort_input = gets.chomp
			puts
			if sort_input.downcase == 'recent'
				to_do_list.sort_recent
				break
			elsif sort_input.downcase == 'oldest'
				to_do_list.sort_oldest
				break
			elsif sort_input.downcase == 'alpha'
				to_do_list.sort_alpha
				break
			else
				puts "#{sort_input} is not a valid sort command."
			end
		end
	elsif input == ''
		break
	else
		puts "#{input} is not a valid command"
	end
end
