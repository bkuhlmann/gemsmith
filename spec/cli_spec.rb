require "spec_helper"

describe Gemsmith::CLI do
  let (:cli) { Gemsmith::CLI.new }

  describe "#create" do
    it "loads default settings" do
      url = "https://www.unknown.com"
      allow(cli).to receive(:author_url).and_return(url)
      allow(cli).to receive(:gem_url).and_return(url)

      name = "Testy Tester"
      allow(cli).to receive(:author_name).and_return(name)
      allow(cli).to receive(:company_name).and_return(name)

      options = cli.send :initialize_template_options, "test"

      expect(options[:gem_name]).to eq("test")
      expect(options[:gem_class]).to eq("Test")
      expect(options[:gem_platform]).to eq("Gem::Platform::RUBY")
      expect(options[:gem_url]).to eq(url)
      expect(options[:gem_private_key]).to eq("~/.ssh/gem-private.pem")
      expect(options[:gem_public_key]).to eq("~/.ssh/gem-public.pem")
      expect(options[:author_name]).to eq(name)
      expect(options[:author_email]).to eq((Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address here."))
      expect(options[:author_url]).to eq(url)
      expect(options[:company_name]).to eq(name)
      expect(options[:company_url]).to eq(url)
      expect(options[:github_user]).to eq((Gemsmith::Kit.git_config_value("github.user") || "unknown"))
      expect(options[:year]).to eq(Time.now.year)
      expect(options[:ruby_version]).to eq("2.2.0")
      expect(options[:rails_version]).to eq("4.2")
      expect(options[:post_install_message]).to eq(nil)
      expect(options[:bin]).to eq(false)
      expect(options[:rails]).to eq(false)
      expect(options[:security]).to eq(true)
      expect(options[:pry]).to eq(true)
      expect(options[:guard]).to eq(true)
      expect(options[:rspec]).to eq(true)
      expect(options[:code_climate]).to eq(true)
      expect(options[:gemnasium]).to eq(true)
      expect(options[:travis]).to eq(true)
    end

    it "loads custom settings" do
      custom_settings = cli.send :load_yaml, File.join(File.dirname(__FILE__), "support", "settings.yml")

      options = cli.send :initialize_template_options, "test", custom_settings
      expect(options[:gem_name]).to eq("test")
      expect(options[:gem_class]).to eq("Test")
      expect(options[:gem_platform]).to eq("Gem::Platform::CURRENT")
      expect(options[:gem_private_key]).to eq("/test/private.pem")
      expect(options[:gem_public_key]).to eq("/test/public.pem")
      expect(options[:author_name]).to eq("Testy Tester")
      expect(options[:author_email]).to eq("test@test.com")
      expect(options[:author_url]).to eq("https://www.test.com")
      expect(options[:gem_url]).to eq("https://www.gem.com")
      expect(options[:company_name]).to eq("ACME")
      expect(options[:company_url]).to eq("https://www.acme.com")
      expect(options[:github_user]).to eq("tester")
      expect(options[:year]).to eq(1920)
      expect(options[:ruby_version]).to eq("1.8.0")
      expect(options[:rails_version]).to eq("2.3.0")
      expect(options[:post_install_message]).to eq("Follow @tester on Twitter for more info.")
      expect(options[:bin]).to eq(false)
      expect(options[:rails]).to eq(false)
      expect(options[:security]).to eq(true)
      expect(options[:pry]).to eq(true)
      expect(options[:guard]).to eq(true)
      expect(options[:rspec]).to eq(true)
      expect(options[:code_climate]).to eq(true)
      expect(options[:gemnasium]).to eq(true)
      expect(options[:travis]).to eq(true)
    end
  end
end
