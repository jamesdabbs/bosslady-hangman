require "bosslady/hangman/version"

module Bosslady
  class Hangman
    Words = File.read("/usr/share/dict/words").
      split("\n").map(&:strip).select do |w|
        w.length > 2 && w.length < 8 && w == w.downcase
      end

    def self.play
      new.start!
    end

    attr_reader :word, :guesses, :guesses_left

    def initialize opts={}
      @word         = opts[:word]         || Words.sample
      @guesses      = opts[:guesses]      || []
      @guesses_left = opts[:guesses_left] || 6
    end

    def start!
      until over?
        puts "#{board} | Guessed #{guesses.join ','} | #{guesses_left} left"
        print "What is your guess? "
        guess = gets.chomp
        check_guess guess
        puts
      end

      if won?
        puts "You won!"
      else
        puts "You lost! The word was #{word}"
      end
    end

    def over?
      won? || lost?
    end

    def won?
      word.chars.all? { |c| guesses.include? c }
    end

    def lost?
      guesses_left <= 0
    end

    def check_guess letter
      @guesses.push letter
      unless word.include? letter
        @guesses_left -= 1
      end
    end

    def board
      word.chars.map do |c|
        if guesses.include? c
          c
        else
          "_"
        end
      end.join ""
    end
  end
end
