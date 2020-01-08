#!/usr/bin/env ruby

gem_text = "source 'https://rubygems.org'
gem 'sinatra'
gem 'rspec'
gem 'pry'
gem 'capybara'
gem 'sinatra-contrib'
gem 'pg'"

def make_router_app_text
  app_text = "require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
"
  ['get','post','patch','delete'].each do |route|
    app_text = "#{app_text}#{route}('/') do
end
"
  end
  app_text
end

def make_views_text(name) "<!DOCTYPE html>
<html>
  <head>
    <title>#{name.capitalize}</title>
    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
    <link rel='stylesheet' href='/styles.css'>
  </head>
  <body>
    <div class='container'>
      <%= yield %>
    </div>
  </body>
</html>"
end

def make_class(class_name)
  "class #{class_name.capitalize}
  def initialize
  end
end"
end

def make_spec(spec_name)
  "require('rspec')
require('#{spec_name}')
require('pg')
#{(spec_name == 'integration') ? "require('capybara')" : ''}
describe('##{spec_name.capitalize}') do
  before(:each) do
  end
  describe('#') do
    it('') do
      expect().to(eq())
    end
  end
end"
end

def make_readme(name)
  "# _#{name.capitalize}_
#### _Web application {INFORMATION}, {DATE} 2020_
#### By _**Liam Kenna**_
## Description
_This site is {INFO}_
* _{DETAILS}_
_For example:_
| Input:  | Output:   |
|---|---|
|||
|||
_{DETAILS}_
## Setup/Installation Requirements
* _Clone to local machine and open index.html in the browser_
* _This site can be viewed in it's current form at https://LiamPKenna.github.io/{PROJECT}_
_To explore the source code, feel free to browse on github or clone to your local machine_
## Known Bugs
_No known bugs at this time._
## Support and contact details
_Any issues or concerns, please email liam@liamkenna.com_
## Technologies Used
_HTML, CSS, Bootstrap, Ruby, Sinatra_
### License
*This software is available under the MIT License*
Copyright (c) 2020 **_Liam Kenna_**"
end

config_text = "require('./app')
run Sinatra::Application"

slash = Gem.win_platform? ? '\\' : '/'

def clear_screen
  (Gem.win_platform?) ? (system "cls") : (system "clear")
end
clear_screen()

puts "
   ___,             , __          _
  /   |            /|/  \\      o | |   |
 |    |   _   _     | __/        | | __|  _   ,_
 |    | |/ \\|/ \\_   |   \\|   | | |/ /  | |/  /  |
  \\__/\\_/__/|__/    |(__/ \\_/|_/_/__|_/|_/__/   |_/
       /|  /|
       \\|  \\|
 "
puts 'Name your project:'
name = gets.chomp.downcase
clear_screen()
system("mkdir #{name}")
Dir.chdir("./#{name}")
directory_list = ['lib', 'spec', 'views', 'public', "public#{slash}img"]
directory_list.each { |dir| system("mkdir #{dir}")}
File.write("./app.rb", make_router_app_text)
File.write("./config.ru", config_text)
File.write("./Gemfile", gem_text)
File.write("./README.md", make_readme(name))
File.write("./public/styles.css", ' ')
File.write("./views/layout.erb", make_views_text(name))
puts 'Enter names for the classes you will use seperated by a space:'
classes = gets.chomp.downcase.split(' ')
clear_screen()
classes.each do |c|
  File.write("./lib/#{c}.rb", make_class(c))
  spec_text = make_spec(c)
  File.write("./spec/#{c}_spec.rb", spec_text)
end
integration_text = make_spec('integration')
File.write("./spec/#{name}_integration_spec.rb", integration_text)
system('bundle install')
system('git init')
system('atom .')
