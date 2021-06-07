require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a[rand(26)]
    end
    @letters
  end

  def score
    @score = 0
    @word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    @letters = params[:letters].chars
    valid_and_unique = @word.chars.all? { |letter| @word.upcase.chars.count(letter) <= @letters.count(letter) }
    if !valid_and_unique
      @result = "Sorry but #{@word} cannot be built out of #{@letters.join(", ")}"
    elsif !user["found"]
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations #{@word} is a valid English word!"
      @score += @word.length
      session[:score].nil? ? session[:score] = @score : session[:score] += @score
    end
  end
end
