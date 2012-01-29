require "spec_helper"

describe Gemsmith::CLI do
  before :each do
    @cli = Gemsmith::CLI.new
  end
  
  describe "#create" do
    it "loads default settings" do
      author_name = Gemsmith::Kit.git_config_value("user.name") || "TODO: Add full name here."
      author_url = "https://www.unknown.com"

      options = @cli.send :build_template_options, "test"
      options[:gem_name].should be == "test"
      options[:gem_class].should be == "Test"
      options[:gem_platform].should be == "Gem::Platform::RUBY"
      options[:author_name].should be == author_name
      options[:author_email].should be == (Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address here.")
      options[:author_url].should be == author_url
      options[:gem_url].should be == "https://www.unknown.com"
      options[:company_name].should be == author_name
      options[:company_url].should be == author_url
      options[:github_user].should be == (Gemsmith::Kit.git_config_value("github.user") || "unknown")
      options[:year].should be == Time.now.year
      options[:ruby_version].should be == "1.9.0"
      options[:rails_version].should be == "3.2.0"
      options[:post_install_message].should be == nil
      options[:bin].should be_false
      options[:rails].should be_false
      options[:rspec].should be_true
      options[:travis].should be_true
    end
    
    it "loads custom settings" do
      custom_settings = @cli.send :load_yaml, File.join(File.dirname(__FILE__), "support", "settings.yml")

      options = @cli.send :build_template_options, "test", custom_settings
      options[:gem_name].should be == "test"
      options[:gem_class].should be == "Test"
      options[:gem_platform].should be == "Gem::Platform::CURRENT"
      options[:author_name].should be == "Testy Tester"
      options[:author_email].should be == "test@test.com"
      options[:author_url].should be == "https://www.test.com"
      options[:gem_url].should be == "https://www.gem.com"
      options[:company_name].should be == "ACME"
      options[:company_url].should be == "https://www.acme.com"
      options[:github_user].should be == "tester"
      options[:year].should be == 1920
      options[:ruby_version].should be == "1.8.0"
      options[:rails_version].should be == "2.3.0"
      options[:post_install_message].should be == "Follow @tester on Twitter for more info."
      options[:bin].should be_false
      options[:rails].should be_false
      options[:rspec].should be_true
      options[:travis].should be_true
    end
  end
end
