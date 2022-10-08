
class Hangman
    def initialize
        puts "HANGMAN\n\n"
        @keyword = get_random_word
        @template = Array.new(@keyword.length, ' _ ')
        @used_letters_incorrect = Array.new
        @used_letters_correct = Array.new
        @man = 0
    end

    def get_random_word
        dictionary = File.open('google-10000-english-no-swears.txt', 'r')
        word = ''
        until word.length >= 5 && word.length <= 12
          word = File.readlines(dictionary).sample.upcase.chomp
        end
        word
    end

    def valid_input?(char)
        unless @used_letters_incorrect.include?(char) || @used_letters_correct.include?(char) || char.length != 1
            return true
        end
    end

    def guess_check(guess)
        @keyword.each_char.with_index do |char, index|
            if @keyword.split('').include?(guess)
                if char == guess
                  @template[index] = " #{char} "
                end
                @used_letters_correct << guess
            elsif !@used_letters_incorrect.include?(guess)
              @man += 1
              @used_letters_incorrect << guess
            end
        end
    end

    def user_turn
        puts "\n\nYou've made #{@man}/5 mistakes! Be careful!\n\n"
        puts @template.join('')
        puts "Mistakes: #{@used_letters_incorrect}\n\n"
        puts "Enter your letter!"
        user_input = gets.chomp.upcase
        if !valid_input?(user_input)
            puts "Invalid input! You can't use a letter you've already used, and the input must be one letter."
            return
        else
            guess_check(user_input)
        end
    end

    def game_loop
        until @man >= 5 || !@template.include?(' _ ')
            user_turn
        end
        if @template.include?(' _ ')
          puts "You lose! The word was #{@keyword}! Better luck next time!"
        else
          puts @template.join
          puts 'You win! Good job!'
        end
    end
        
end

hangman = Hangman.new
hangman.game_loop
