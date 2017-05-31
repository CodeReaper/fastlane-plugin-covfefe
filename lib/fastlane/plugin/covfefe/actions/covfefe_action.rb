module Fastlane
  module Actions
    class CovfefeAction < Action
      def self.run(params)
        require 'mustache'

        name = params[:name]
        input_path = File.expand_path params[:input_path]
        output_path = File.expand_path params[:output_path]
        breadcrumbs = params[:output_path]

        options = Hash.new
        options[:name] = name

        FileUtils.mkdir_p(output_path)

        self.handle(options, input_path, output_path, breadcrumbs)

        UI.message("Allright 🙌  it is all done.")
      end

      def self.handle(options, input_path, output_path, breadcrumbs)
        Dir.entries(input_path).select { |f|
          next if f == '.' or f == '..'
          mustached = Mustache.render(f, name: options[:name])
          input = "#{input_path}/#{f}"
          output = "#{output_path}/#{mustached}"
          if File.directory? input
            breadcrumbs = "#{breadcrumbs}/#{mustached}"
            UI.message "Creating: #{breadcrumbs}"
            FileUtils.mkdir_p(output)
            self.handle(options, input, output, breadcrumbs)
          else
            UI.message "Creating: #{breadcrumbs}/#{mustached}"
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
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "FL_PI_MUSTACHE_NAME",
                                       description: "common name of the file structures",
                                       optional: false,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
