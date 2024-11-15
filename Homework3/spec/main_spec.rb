require 'selenium-webdriver'
require 'capybara/rspec'
require 'capybara/dsl'

Capybara.default_driver = :selenium_chrome
Capybara.app_host = 'https://www.saucedemo.com'

RSpec.describe 'SauceDemo Tests' do
  include Capybara::DSL

  def login(username, password)
    visit '/'
    fill_in 'user-name', with: username
    sleep(1)
    fill_in 'password', with: password
    sleep(1)
    click_button 'login-button'
    sleep(2)

    if !page.has_css?('.shopping_cart_link')
      raise "Login failed with \nLogin: \"#{username}\"\nPassword: \"#{password}\""
    end
  end

  def logout
    find('#react-burger-menu-btn').click
    sleep(2)
    if has_css?('#logout_sidebar_link', wait: 5)
      find('#logout_sidebar_link').click
      sleep(2)
    else
      raise "Logout button not found"
    end
  end

  def add_item_to_cart(index)
    items = all('.inventory_item')
    if index < items.size
      items[index].find('.btn_inventory').click
      sleep(2)
    else
      raise "Item with index #{index} not found"
    end
  end

  def cart_item_count
    has_css?('.shopping_cart_badge', wait: 5) ? find('.shopping_cart_badge').text.to_i : 0
  end

  def empty_cart
    find('.shopping_cart_link').click
    sleep(2)
    cart_items = all('.cart_item')

    cart_items.each do |item|
      item.find('.cart_button').click
      sleep(2)
    end

    item_count = cart_item_count
    if item_count != 0
      raise "After clear the cart, #{item_count} items remain"
    end
  end

  it 'adds three items to cart' do
    login('standard_user', 'secret_sauce')

    add_item_to_cart(0)
    add_item_to_cart(1)
    add_item_to_cart(4)

    item_count = cart_item_count

    empty_cart
    logout
  end

  it 'handles blocked login attempts' do
    valid_users = ['standard_user', 'problem_user', 'performance_glitch_user', 'error_user', 'visual_user']
    valid_users.each do |user|
      login(user, 'secret_sauce')
      logout
    end

    expect {
      login('incorrect_login', 'secret_sauce')
    }.to raise_error(RuntimeError, /Login failed/)
  end
end
