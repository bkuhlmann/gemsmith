require "spec_helper"

describe "Settings" do
  before :each do
    # Default settings.
    class Gemsmith::CLI
      private
      def settings_file
        nil
      end
    end
    @cli_default = Gemsmith::CLI.new

    # Custom settings.
    class Gemsmith::CLI
      private
      def settings_file
        File.join File.dirname(__FILE__), "support", "settings.yml"
      end
    end
    @cli_custom = Gemsmith::CLI.new
  end
  
  context "Load" do
    it "should be empty" do
      @cli_default.send(:settings).should be_empty
    end
    
    it "should build defaults" do
      author_name = `git config user.name`.chomp || "TODO: Add full name here."
      author_url = "https://www.unknown.com"
      options = @cli_default.send :build_template_options, "test"
      options[:gem_name].should be == "test"
      options[:gem_class].should be == "Test"
      options[:gem_platform].should be == "Gem::Platform::RUBY"
      options[:author_name].should be == author_name
      options[:author_email].should be == (`git config user.email`.chomp || "TODO: Add email address here.")
      options[:author_url].should be == author_url
      options[:gem_url].should be == "https://www.unknown.com"
      options[:organization_name].should be == author_name
      options[:organization_url].should be == author_url
      options[:year].should be == Time.now.year
      options[:bin].should be_false
      options[:rails].should be_false
      options[:rspec].should be_true
      options[:ruby_version].should be == "1.9.2"
      options[:rails_version].should be == "3.1.1"
    end
    
    it "should be custom" do
      options = @cli_custom.send :build_template_options, "test"
      options[:gem_name].should be == "test"
      options[:gem_class].should be == "Test"
      options[:gem_platform].should be == "Gem::Platform::CURRENT"
      options[:author_name].should be == "Testy Tester"
      options[:author_email].should be == "test@test.com"
      options[:author_url].should be == "https://www.test.com"
      options[:gem_url].should be == "https://www.gem.com"
      options[:organization_name].should be == "ACME"
      options[:organization_url].should be == "https://www.acme.com"
      options[:year].should be == 1920
      options[:bin].should be_false
      options[:rails].should be_false
      options[:rspec].should be_true
      options[:ruby_version].should be == "1.9.0"
      options[:rails_version].should be == "3.0.0"
    end
  end
end
