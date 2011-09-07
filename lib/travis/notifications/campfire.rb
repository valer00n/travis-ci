module Travis
  module Notifications
    class Campfire < Webhook
      module ConfigurationBuilder
        def self.build_url(data)
          "https://#{data[:subdomain]}.campfirenow.com/room/#{data[:room]}/speak.json"
        end

        def self.extract_data(scheme)
          scheme =~ /(\w+):(\w+)@(\w+)/
          {
            :subdomain => $1,
            :token => $2,
            :room => $3
          }
        end
      end

       def notify(event, build, *args)
        send_notifications(build) if build.send_webhook_notifications?
      end


      protected
      def send_notifications(build)
        build.campfire.each do |campfire|
          data = ConfigurationBuilder.extract_data(campfire)
          url = ConfigurationBuilder.build_url(data)

          prepare_notification(url) do |req|
            req.body = { :message => { :body => build_message(build) }}
            req.headers['Authorization'] = data[:token]
          end
        end
      end

      def build_message(build)
        commit = build.commit

        ["[travis-ci] #{build.repository.slug}##{build.number} (#{commit.branch} - #{commit.commit[0, 7]} : #{commit.author_name}): the build has #{build.passed? ? 'passed' : 'failed' }",
        "[travis-ci] Change view : #{commit.compare_url}",
        "[travis-ci] Build details : #{build_url}"].join("\n")
      end
    end
  end
end
