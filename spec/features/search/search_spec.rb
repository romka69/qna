require 'sphinx_helper'

feature 'User can search data', %q{
  In order to search data in site
  As anyone user
  I'd like to give the search results
} do
  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }
  given!(:comment_question) { create :comment, commentable: question }
  given!(:comment_answer) { create :comment, commentable: answer }

  background do
    visit search_path
  end

  scenario 'User searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
    end
  end

  scenario 'User searches for the answer', sphinx: true, js: true do
  end

  scenario 'User searches for the comment', sphinx: true, js: true do
  end

  scenario 'User searches for the user', sphinx: true, js: true do
  end
end
