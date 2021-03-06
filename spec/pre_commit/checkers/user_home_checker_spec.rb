require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/user_home_checker.rb"

RSpec.describe UserHomeChecker do
  let(:checker_class) { UserHomeChecker }

  context "code with nothing suspicious" do
    subject(:checker) { test_class_with_change(checker_class, "Hello", user: 'bob') }
    it_should_behave_like "it finds no error"
  end

  context "code with a home/ but not for that user" do
    subject(:checker) { test_class_with_change(checker_class, "cd /home/fred", user: "bob") }
    it_should_behave_like "it finds no error"
  end

  context "code with a /home/(user)" do
    subject(:checker) { test_class_with_change(checker_class, "cd /home/bob/.emacs.d", user: "bob") }
    it_should_behave_like "it finds an error"
  end

  context "code with a /Users/(user)" do
    subject(:checker) { test_class_with_change(checker_class, "cd /Users/bob", user: "bob") }
    it_should_behave_like "it finds an error"
  end


  context "code with a /export/home/(user)" do
    subject(:checker) { test_class_with_change(checker_class, "cd /export/home/bob", user: "bob") }
    it_should_behave_like "it finds two errors"
  end

  context "code with two copies of the same error" do
    subject(:checker) { test_class_with_change(checker_class, "/home/bob there\n and here's /Users/bob", user: "bob") }
    it_should_behave_like "it finds two errors"
  end
end
