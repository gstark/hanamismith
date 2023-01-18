# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Slices::Main do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds action" do
      expect(temp_dir.join("test/slices/main/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Main
          # The main action.
          class Action < Test::Action
          end
        end
      CONTENT
    end

    it "adds repository" do
      expect(temp_dir.join("test/slices/main/repo.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Main
          # The main repository.
          class Repo < Test::Repo
          end
        end
      CONTENT
    end

    it "adds view" do
      expect(temp_dir.join("test/slices/main/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Main
          # The main view.
          class View < Test::View
            config.paths = [Pathname(__dir__).join("templates").expand_path]
          end
        end
      CONTENT
    end

    it "adds layout template" do
      path = "test/slices/main/templates/layouts/app.html.erb"

      expect(temp_dir.join(path).read).to eq(<<~CONTENT)
        <!DOCTYPE html>
        <html>
          <head>
            <title>Test</title>
            <meta name="viewport" content="width=device-width,initial-scale=1">

            <style type="text/css">
              :root {
                --site-font-family: Verdana;
                --site-color-black: hsl(0, 0%, 0%);
                --site-color-white: hsl(0, 0%, 100%);
              }

              body {
                align-items: center;
                display: flex;
                flex-direction: column;
                font-family: var(--site-font-family);
                margin: 1rem 5rem;
              }
            </style>

            <script src="https://unpkg.com/htmx.org@1.8.4/dist/htmx.min.js"
                    crossorigin="anonymous"
                    integrity="sha384-wg5Y/JwF7VxGk4zLsJEcAojRtlVp1FKKdGy1qN+OMtdq72WRvX/EdRdqg/LOhYeV">
            </script>
          </head>

          <body>
            <%= yield %>
          </body>
        </html>
      CONTENT
    end

    it "adds show template" do
      path = "test/slices/main/templates/home/show.html.erb"

      expect(temp_dir.join(path).read).to eq(<<~CONTENT)
        <h1>Home</h1>

        <p>Welcome!</p>
      CONTENT
    end

    it "adds show view" do
      expect(temp_dir.join("test/slices/main/views/home/show.rb").read).to eq(<<~CONTENT)
        module Main
          module Views
            module Home
              # Renders show view.
              class Show < Main::View
              end
            end
          end
        end
      CONTENT
    end

    it "adds show action" do
      expect(temp_dir.join("test/slices/main/actions/home/show.rb").read).to eq(<<~CONTENT)
        module Main
          module Actions
            module Home
              # Processes show action.
              class Show < Main::Action
                def handle(*, response) = response.render view
              end
            end
          end
        end
      CONTENT
    end
  end
end