require 'json'

class Hangman
  def initialize
    puts "HANGMAN\n\n"
    @keyword = random_word
    @template = Array.new(@keyword.length, ' _ ')
    @used_letters_incorrect = []
    @used_letters_correct = []
    @man = 0
    load?
    game_loop
  end

  def random_word
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    word = ''
    word = File.readlines(dictionary).sample.upcase.chomp until word.length >= 5 && word.length <= 12
    word
  end

  def load?
    puts 'Do you wish to load from a previous save? [y/n]'
    input = gets.chomp.upcase
    load_game if input == 'Y'
  end

  def valid_input?(char)
    true unless @used_letters_incorrect.include?(char) || @used_letters_correct.include?(char) || char.length != 1
  end

  def guess_check(guess)
    @keyword.each_char.with_index do |char, index|
      if @keyword.split('').include?(guess)
        @template[index] = " #{char} " if char == guess
        @used_letters_correct << guess
      elsif !@used_letters_incorrect.include?(guess)
        @man += 1
        @used_letters_incorrect << guess
      end
    end
  end

  def user_turn
    puts "\n\nYou've made #{@man}/5 mistakes! Be careful!\n\n"
    puts @template.join
    puts "Mistakes: #{@used_letters_incorrect}\n\n"
    puts 'Enter your letter, or enter "save" to save and exit the game.'
    user_input = gets.chomp.upcase
    if user_input == 'SAVE'
      save_game
    elsif !valid_input?(user_input)
      puts "Invalid input! You can't use a letter you've already used, and the input must be one letter."
      nil
    else
      guess_check(user_input)
    end
  end

  def game_loop
    user_turn until @man >= 5 || !@template.include?(' _ ')
    if @template.include?(' _ ')
      puts "You lose! The word was #{@keyword}! Better luck next time!"
    else
      puts @template.join
      puts 'You win! Good job!'
    end
  end

  def gamestate_to_json
    JSON.dump({
                keyword: @keyword,
                template: @template,
                used_letters_correct: @used_letters_correct,
                used_letters_incorrect: @used_letters_incorrect,
                man: @man
              })
  end

  def gamestate_from_json(filename)
    File.open(filename, 'r') do |json|
      gamestate = JSON.load json
      @keyword = gamestate['keyword']
      @template = gamestate['template']
      @used_letters_incorrect = gamestate['used_letters_incorrect']
      @used_letters_correct = gamestate['used_letters_correct']
      @man = gamestate['man']
    end
  end

  def save_game
    Dir.mkdir('saved-games') unless Dir.exist?('saved-games')
    save_name = "saved-games/#{Time.now.strftime("#{@template.join}|%-m-%-d-%Y|%l:%M.json")}".gsub(' ', '')
    File.open(save_name, 'w') do |file|
      file.write(gamestate_to_json)
      file.close
    end
    abort("\n\n Game saved. Exiting program.")
  end

  def load_game
    if Dir.exist?('saved-games') && !Dir.empty?('saved-games')
      puts "\nSelect a game to load by inputting the number next to the filename."
      Dir.entries('saved-games').each_with_index do |entry, index|
        puts "|#{index + 1}| #{entry}" unless ['.', '..'].include?(entry)
      end
      selection = gets.chomp.to_i
      gamestate_from_json("saved-games/#{Dir.entries('saved-games')[selection - 1]}")
    else
      puts 'There are no saved games to select from'
    end
  end
end
Hangman.new
