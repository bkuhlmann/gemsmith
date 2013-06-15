module Gemsmith
  module CLIOptions
    module_function

    # Builds template options with default and/or custom settings (where the custom
    # settings trump default settings).
    # ==== Parameters
    # * +name+ - Required. The gem name.
    # * +settings+ - Optional. The custom settings. Default: {}.
    # * +options+ - Optional. Additional command line options. Default: {}.
    def build_template_options name, settings = {}, options = {}
      gem_name name
      gem_class name
      author_name = settings[:author_name] || Gemsmith::Kit.git_config_value("user.name") || "TODO: Add full name here."
      author_email = settings[:author_email] || Gemsmith::Kit.git_config_value("user.email") || "TODO: Add email address here."
      author_url = settings[:author_url] || "https://www.unknown.com"

      @template_options = {
        gem_name: gem_name,
        gem_class: gem_class,
        gem_platform: (settings[:gem_platform] || "Gem::Platform::RUBY"),
        author_name: author_name,
        author_email: author_email,
        author_url: (author_url || "http://www.unknown.com"),
        gem_url: (settings[:gem_url] || author_url),
        company_name: (settings[:company_name] || author_name),
        company_url: (settings[:company_url] || author_url),
        github_user: (settings[:github_user] || Gemsmith::Kit.git_config_value("github.user") || "unknown"),
        year: (settings[:year] || Time.now.year),
        ruby_version: (settings[:ruby_version] || "2.0.0"),
        ruby_patch: (settings[:ruby_patch] || "p0"),
        rails_version: (settings[:rails_version] || "3.0"),
        post_install_message: settings[:post_install_message],
        bin: (options[:bin] || false),
        rails: (options[:rails] || false),
        pry: (options[:pry] || true),
        guard: (options[:guard] || true),
        rspec: (options[:rspec] || true),
        travis: (options[:travis] || true),
        code_climate: (options[:code_climate] || true)
      }
    end
  end
end
