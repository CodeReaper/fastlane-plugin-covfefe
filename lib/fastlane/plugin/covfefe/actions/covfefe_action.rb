module Fastlane
  module Actions
    class CovfefeAction < Action
      def self.run(params)
        require 'mustache'
        require 'tmpdir'

        Dir.mktmpdir("repo_clone") do |tmp_path|

          name = params[:options][:name]
          input_path = File.expand_path params[:input_path]
          output_path = params[:output_path]
          output_path = File.join(output_path, params[:options][:in]) unless params[:options][:in].to_s.length == 0
          output_path = File.expand_path output_path
          breadcrumbs = params[:output_path]

          options = Hash.new
          options[:name] = name
          options = options.merge(params[:extra_options])

          if params[:repo].to_s.length > 0
            repo = params[:repo]
            repo_name = repo.split("/").last
            repo_path = File.join(tmp_path, repo_name)

            UI.message "Cloning remote git repo..."
            clone_command = "GIT_TERMINAL_PROMPT=0 git clone '#{repo}' '#{repo_path}' --depth 1"
            Actions.sh(clone_command)

            input_path = File.join(repo_path, params[:input_path])
          end

          FileUtils.mkdir_p(output_path)
          self.handle(options, input_path, output_path, breadcrumbs)
        end

        UI.message("Allright 🙌  it is all done.")
      end

      def self.handle(options, input_path, output_path, breadcrumbs)
        Dir.entries(input_path).select { |f|
          next if f == '.' or f == '..' or f == '.git'
          mustached = Mustache.render(f, name: options[:name])
          input = File.join(input_path, f)
          output = File.join(output_path, mustached)
          if File.directory? input
            breadcrumbs = File.join(breadcrumbs, mustached)
            UI.message "Creating: #{breadcrumbs}"
            FileUtils.mkdir_p(output)
            self.handle(options, input, output, breadcrumbs)
          else
            UI.message "Creating: #{File.join(breadcrumbs, mustached)}"
            string = File.read(input)
            string = Mustache.render(string, name: options[:name])
            File.write(output, string)
          end
        }
      end

      def self.description
        "A templating engine for generating common file structures."
      end

      def self.authors
        ["Jakob Jensen"]
      end

      def self.return_value
      end

      def self.details
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :input_path,
                                       env_name: "FL_PI_MUSTACHE_INPUT_PATH",
                                       description: "path to directory with a template",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :output_path,
                                       env_name: "FL_PI_MUSTACHE_OUTPUT_PATH",
                                       description: "path to create templated output",
                                       default_value: FastlaneCore::FastlaneFolder.path + "../",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :options,
                                       env_name: "FL_PI_MUSTACHE_OPTIONS",
                                       description: "name:common name of the file structures; in:optional path prefix the common name with;",
                                       default_value: Hash.new,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :extra_options,
                                       env_name: "FL_PI_MUSTACHE_EXTRA_OPTIONS",
                                       description: "extra values that that mustache can replace",
                                       default_value: Hash.new,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :repo,
                                       env_name: "FL_PI_MUSTACHE_REPO",
                                       description: "the repo the input path is in",
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
