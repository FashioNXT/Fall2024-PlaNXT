# frozen_string_literal: true

# selenium_test.rb
require 'bundler/setup'
require 'selenium-webdriver'
require 'webdrivers' # require the gem

driver = Selenium::WebDriver.for :chrome # no need to specify driver_path
driver.navigate.to 'http://google.com'
puts driver.title
driver.quit
