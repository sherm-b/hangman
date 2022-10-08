
class Hangman
    def initialize
        puts 'HANGMAN\n\n'
        @keyword = get_random_word
        @template = Array.new(@keyword.length, ' _ ')
        @used_letters_incorrect = Array.new
        @man = 0
    end

    def get_random_word
        dictionary = File.open('google-10000-english-no-swears.txt', 'r')
        File.readlines(dictionary).sample.upcase
    end

    def valid_input?(char)
        unless @used_letters_incorrect.include?(char) && @template.include?(" #{char} ") && char.length != 1
            return true
        end
    end

    def guess_check(guess)
        @keyword.each_char.with_index do |char, index|
            if guess == char
                @template[index] = " #{char} "
            else
                @man += 1
                @used_letters_incorrect << guess
            end
        end
    end

    def user_turn
        puts "\n\nYou've made #{@man}/5 mistakes! Be careful!\n\n"
        puts @template
        puts "Mistakes: #{@used_letters_incorrect}\n\n"
        puts "Enter your letter!"
        user_input = gets.chomp.upcase
        if !valid_input?(user_input)
            puts "Invalid input! You can't use a letter you've already used or more than one letter!"
            return
        else
            guess_check(user_input)
        end
    end
        
end

hangman = Hangman.new
hangman.user_turn
