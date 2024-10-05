# Ruby Intro

This 3-part homework gives some basic practice in Ruby as well as
getting you accustomed to making testing a regular part of your workflow.

**NOTE: do not fork this repo. Click the ["Use this template"](https://github.com/tamu-edu-students/hw-ruby-intro/generate) button then clone the repo that it generates**

## Learning Goals

After completing this assignment, you will be able to:

* Write simple code that uses basic constructs in the Ruby language, including methods and arguments, conditionals, string and array manipulation, regular expressions, and basic object-oriented programming mechanisms
* Describe the Ruby project conventions for where code files and test files are located in a project's directory hierarchy
* Run individual tests or suites of tests using the RSpec unit testing tool
* Describe the basic syntax of RSpec unit tests
 
## Overview

**You may find the [Ruby documentation at ruby-doc.org](https://ruby-doc.org) helpful to have on hand.**

The repo for this assigment follows a fairly standard Ruby convention for codebases: the code files are stored in `lib/` and the test files are stored in `spec/`. (We will use the RSpec unit-testing framework; if we were using Ruby's default framework, known as `Test::Unit`, the test files would be under
`test/`.)

**We've placed "starter code" in `lib/ruby_intro.rb`.**

### Ruby Install and Setup Instructions

0. Be in home directory: `cd ~`
1. Install rbenv with ruby-build: `curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash`
2. Reload profile: `source ~/.bashrc`
3. Install ruby 3.2.2: `rbenv install 3.2.2`
   * Be patient, this can take several minutes
5. Be in the directory for this assignment, e.g. `cd /path/to/hw-ruby-intro` 
6. Set ruby 3.2.2 as the local default version: `rbenv local 3.2.2`
7. Install bundler: `gem install bundler`
   * If it says that a new release of RubyGems is available, follw the instructions on screen to update, e.g. run `gem update --system 3.4.18`
8. Install dependencies: `bundle install`

#### Troubleshooting

##### Missing OpenSSL Library

Install the OpenSSL library `sudo apt install libssl-dev`

##### Ruby version in Gemfile doesn't match

Make sure the ruby version at the top of `Gemfile` matches your local ruby version (e.g. if you have ruby 3.1.4, your `Gemfile` should have `ruby "3.1.4` at the top.  Then, run `bundle install`.

##### Can't find libyaml

0. Be in home directory: `cd ~`
1. Install autoconf: `sudo apt install autoconf libtool`
2. Install libyaml:
   * Clone libyaml repo: `git clone https://github.com/yaml/libyaml.git`
   * Be in libyaml directory: `cd libyaml`
   * Bootstrap: `./bootstrap`
   * Configure: `./configure`
   * Build: `make`
   * Install: `sudo make install`

### Running RSpec

When the above completes successfully you'll have RSpec installed and can run `rspec` from the command line to test your code.

Run `rspec` now.  You should see `34 examples, 20 failures` in red.

Runing `rspec` with no arguments will execute the tests in all the files `spec/*_spec.rb`. However, you can test each of the 3 parts separately.  The files `spec/part[123]_spec.rb` contain RSpec tests for each of the three parts.  For example, to test your answers to Part 1, run `rspec spec/part1_spec.rb`.  

Run `rspec spec/part1_spec.rb`. You should see `12 examples, 9 failures` in red.

The line numbers in the RSpec error report will give you guidance as to which tests failed.  (You can check the [RSpec documentation](http://rspec.info) to see how the `.rspec` file can be used to customize the output format.)

## 1. Arrays, Hashes, and Enumerables

Check the [Ruby 3.x documentation](http://ruby-doc.org) on `Array`, `Hash` and `Enumerable` as they could help tremendously with these exercises. Various Ruby cheatsheets are also helpful as a quick reference! Although Ruby supports looping constructs like 'for' and 'while', consider using block syntax with each for a more idiomatic use of Ruby. :-) 

### `sum`
The method `sum(arr)` should return the sum of the values in `arr`.

0. Run the tests:  `rspec -fd -e '#sum ' spec/part1_spec.rb`. You should see `3 examples, 2 failures` in red.
   * Problem? Make sure you are in the correct directory: `cd assignment` and RSpec is installed.
1. Read the RSpec report.
2. Pick one of the failures to correct. (In fact, we could "fix" both at the same time)
   * Suppose we pick `expect(sum([1, 2, 3, 4, 5])).to be_a_kind_of Integer`.
3. Add just enough code to the method `sum(array)` in `lib/ruby_intro.rb` to pass the selected test.
   * The simplest code we can add is to return a constant.  Let's `return 0`.  Because Ruby is neat, we can do this by simply putting `0` in the function body:
   ```ruby
   def sum(arr)
     0
   end
   ```
4. Re-run the tests: `rspec -fd -e '#sum ' spec/part1_spec.rb`. You should see `3 examples, 1 failure` in red.
5. Add and commit changes: `git add . && git commit -m "improved correctness of sum"`
6. Read the RSpec report.
7. Pick one of the failures to correct. (Pick the *only* failure...)
8. Add just enough code to pass the test.
9. Re-run the tests. You should see `3 examples, 0 failures` in green.
   * Yay?
     * Yay!
     * Add and commit changes: `git add . && git commit -m "sum is passing all tests"`
     * Push changes: `git push`
   * Nay?
     * Go back to step 6 and Try Harder.

### `max_2_sum`
The method `max_2_sum(arr)` should return the sum of its two largest elements in `arr`.

0. Run the tests: `rspec -fd -e '#max_2_sum' spec/part1_spec.rb`. You should see `5 examples, 4 failures` in red.
1. Read the RSpec report.
2. Pick one of the failures to correct.
3. Add just enough code to pass the selected test.
4. Add and commit changes: `git add . && git commit -m "<comment>"`
5. Until all tests are passing (0 failures), go back to step 0.
6. Push changes: `git push`

### `sum_to_n?`
The method `sum_to_n?(arr, n)` takes an array of integers `arr` and an additional integer, `n`, as arguments and returns true if any two elements in `arr` sum to `n`. 

0. Run the tests:  `rspec -fd -e '#sum_to_n?' spec/part1_spec.rb`.
1. Read the RSpec report.
2. Pick one of the failures to correct.
3. Add just enough code to pass the selected test.
4. Add and commit changes.
5. Until all tests are passing (0 failures), go back to step 0.
6. Push changes.

### Finally
Check your progress on all Part 1 methods: `rspec -fd spec/part1_spec.rb`.  All tests should be green.

Now is a good time (and the right time) to go back and consider how you can improve your code?  Might there be a better way (a more rubyistic / efficient / readable / etc.) to implement the methods?  Try at least 1 alternative solution (with a focus on making the solution use more of Ruby's language features) for each method.  Settle on the one you like the best.


## 2. Strings and Regular Expressions

Check the documentation on `String` and `Regexp` as they could help tremendously with these exercises. For future reference as well, check out [Rubular](https://rubular.com/) for regex related queries.

0. Define a method `hello(name)` that takes a string representing a name and returns the string "Hello, " concatenated with the name. Run associated tests via:  `rspec -e '#hello' spec/part2_spec.rb`.
   * Everytime a new test passes, add and commit changes:  `git add . && git commit -m "<comment>"`
   * Once all tests are passing, push changes: `git push`

0. Define a method `starts_with_consonant?(s)` that takes a string and returns true if it starts with a consonant and false otherwise. (For our purposes, a consonant is any English letter other than A, E, I, O, U.) Make sure it works for both upper and lower case and for non-letters. Run associated tests via:  `rspec -e '#starts_with_consonant?' spec/part2_spec.rb`.
   * Everytime a new test passes, add and commit changes:  `git add . && git commit -m "<comment>"`
   * Once all tests are passing, push changes: `git push`

0. Define a method `binary_multiple_of_4?(s)` that takes a string and returns true if the string represents a binary number that is a multiple of 4, such as '1000'. Make sure it returns false if the string is not a valid binary number. Run associated tests via:  `rspec -e '#binary_multiple_of_4?' spec/part2_spec.rb`.
   * Everytime a new test passes, add and commit changes:  `git add . && git commit -m "<comment>"`
   * Once all tests are passing, push changes: `git push`

You can check your progress on all of the above by running `rspec -fd spec/part2_spec.rb`. All tests should be green.

Consider ways to improve your code.

## 3. Object Oriented Basics

Remember:

* Everytime a new test passes, add and commit changes:  `git add . && git commit -m "<comment>"`
* Once all tests are passing, push changes: `git push`

0. Implement the constructor for class `BookInStock` which represents a book with an ISBN number, `isbn`, and price of the book, `price`.  The constructor should accept the ISBN number (a string, since in real life ISBN numbers can begin with zero and can include hyphens) as the first argument and price (a floating point number) as the second argument. Also implement the getter and setter methods for `isbn` and `price`. Run associated tests via:  `rspec -e 'getters and setters' spec/part3_spec.rb`

0. The constructor should raise `ArgumentError` (one of Ruby's built-in exception types) if the ISBN number is the empty string or if the price is less than or equal to zero. Run associated tests via:  `rspec -e 'constructor' spec/part3_spec.rb`

0. Implement the method `BookInStock#price_as_string` that returns the price of the book formatted with a leading dollar sign and two decimal places, that is, a price of 20 should format as `$20.00` and a price of 33.8 should format as `$33.80`. Check out formatted string methods in Ruby. Run associated tests via:  `rspec -e '#price_as_string' spec/part3_spec.rb`

You can check your progress on all of the above by running `rspec -fd spec/part3_spec.rb`.

## Finally

Generate a test log file using `rspec -fd -o <LastName>_<FirstName>_PA1.txt spec/`, where `<LastName>` and `<FirstName>` are your last and first names, respectively. This will put the entire RSpec report into one file.

Don't forget to add, commit, and push!

## More Challenges

* I **strongly** recommend that you try conforming to a Ruby style guide: `gem install rubocop`, then run `rubocop [list of filenames to check]`.

* Try getting setup with an automated test framework such as [guard](http://code.tutsplus.com/tutorials/testing-your-ruby-code-with-guard-rspec-pry--cms-19974) or [autotest](https://rubygems.org/gems/minitest-autotest).  Guard or AutoTest can be set up so that they will run all the tests in `spec/`, but every time you edit and save your code file, the tests are automatically re-run, so you don't have to run them manually.  As you should have seen in this assignment, this is the "watch the test fail" part of the TDD or test-driven process of development: write the tests before you write the code, watch the test fail, fill in the code and save the code file, then watch the test pass!
