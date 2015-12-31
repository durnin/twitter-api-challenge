# Feature: Search tweets
#   As a user
#   I want to search for tweets of different handles
feature 'Search tweets' do

  # Scenario: User cannot search for tweets if he's not logged in
  #   Given I'm a user that is not signed in
  #   When I visit the search tweets page
  #   Then I see that I should sign in
  scenario 'user cannot search for tweets if not signed in' do
    visit tweets_index_path
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

  # Scenario: Signed in user sees all the filter fields and search button
  #   Given I'm a signed in user
  #   When I visit the search tweets page
  #   Then I see all the filter fields and the search button
  scenario 'signed in user sees all the filter fields and search button' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit tweets_index_path
    expect(page).to have_field('Twitter Handle')
    expect(page).to have_field('Include re-tweets?')
    expect(page).to have_field('Max number of tweets')
    expect(page).to have_button('Search Tweets')
  end

  # Scenario: Signed in user searches for tweets for a certain handle
  #   Given I'm a signed in user
  #   When I visit the search tweets page and filter by 5 tweets and handle gem
  #   Then I see 5 tweets/retweets of user gem
  scenario 'signed in user searches for 5 tweets (any) for handle gem and sees the tweets' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit tweets_index_path
    fill_in 'Twitter Handle', with: 'gem'
    select 'Yes', from: 'Include re-tweets?', :match => :first
    select '5', from: 'Max number of tweets', :match => :first
    click_button 'Search Tweets'
    txts = ['Tweets for gem']
    txts.each { |txt| expect(page).to have_content(txt) }
    expect(page).to have_css("blockquote[class='twitter-tweet']", :count => 5)
  end

  # Scenario: Signed in user searches for tweets for empty handle
  #   Given I'm a signed in user
  #   When I visit the search tweets page and filter by 5 tweets and handle empty
  #   Then I see error that no handle was given
  scenario 'signed in user searches for 5 tweets (any) for empty handle and sees error' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit tweets_index_path
    select 'Yes', from: 'Include re-tweets?', :match => :first
    select '5', from: 'Max number of tweets', :match => :first
    click_button 'Search Tweets'
    expect(page).to have_content I18n.t 'twitter.errors.screen_name_invalid'
  end

  # Scenario: Signed in user searches for tweets not including retweets for a certain handle
  #   Given I'm a signed in user
  #   When I visit the search tweets page and filter by 5 tweets and handle gem
  #   Then I see maximum 5 tweets of user gem
  scenario 'signed in user searches for 5 tweets with no retweets for handle gem and sees only gem tweets (max 5)' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit tweets_index_path
    fill_in 'Twitter Handle', with: 'gem'
    select 'No', from: 'Include re-tweets?', :match => :first
    select '5', from: 'Max number of tweets', :match => :first
    click_button 'Search Tweets'
    expect(page).to have_content('Tweets for gem')
    expect(page).to ((have_content('The Ruby Gem (@gem)', :count=> 5).and have_css("blockquote[class='twitter-tweet']", :count => 5)).or ((have_content('The Ruby Gem (@gem)', :count=> 4).and have_css("blockquote[class='twitter-tweet']", :count => 4)).or ((have_content('The Ruby Gem (@gem)', :count=> 3).and have_css("blockquote[class='twitter-tweet']", :count => 3)).or ((have_content('The Ruby Gem (@gem)', :count=> 2).and have_css("blockquote[class='twitter-tweet']", :count => 2)).or (have_content('The Ruby Gem (@gem)', :count=> 1).and have_css("blockquote[class='twitter-tweet']", :count => 1))))))
  end

  # Scenario: Signed in user searches for tweets for an non existing handle
  #   Given I'm a signed in user
  #   When I visit the search tweets page and filter by 5 tweets and handle peperulo888891
  #   Then I see error that handle does not exist
  scenario 'signed in user searches for 5 tweets with for not existing handle and sees error' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    visit tweets_index_path
    fill_in 'Twitter Handle', with: 'peperulo888891'
    select 'Yes', from: 'Include re-tweets?', :match => :first
    select '5', from: 'Max number of tweets', :match => :first
    click_button 'Search Tweets'
    expect(page).to have_content 'Error while trying to fetch tweets for screen_name peperulo888891: Sorry, that page does not exist.'
  end

end
