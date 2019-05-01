require 'google/api_client'

class GaApi

    KEY_FILE = "#{Rails.root}/certificate/propane-folio-239209-a78653cfaada.p12"
    ACCOUNT_EMAIL = "analytics-ad-acount@propane-folio-239209.iam.gserviceaccount.com"
    KEY_SECRET = "notasecret"
    VIEW_ID = "194376867"
    VERSION = "v3"
    CACHED_API_FILE = "#{Rails.root}/certificate/analytics-#{VERSION}.cache"

    def initialize
      @client = Google::APIClient.new(
          application_name: 'ad_system',
          application_name: '1.0'
      )
    end

    # Cache api file to avoide round-trip
    def api
        analytics = nil
        if File.exists? CACHED_API_FILE
            File.open(CACHED_API_FILE) do |file|
                analytics = Marshal.load(file)
            end
        else
            analytics = @client.discovered_api('analytics', VERSION)
            File.open(CACHED_API_FILE, 'w') do |file|
                Marshal.dump(analytics, file)
            end
        end
        analytics
    end

    def signing_key
        return if @signing_key
        @signing_key = Google::APIClient::KeyUtils.load_from_pkcs12(KEY_FILE, KEY_SECRET)
    end

    def authorize!
        @client.authorization = Signet::OAuth2::Client.new(
                  token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                  audience: 'https://accounts.google.com/o/oauth2/token',
                  scope: 'https://www.googleapis.com/auth/analytics.readonly',
                  issuer: ACCOUNT_EMAIL,
                  signing_key: signing_key
        )
        @client.authorization.fetch_access_token!
    end

    def get_data(options = {})
      @client.execute(
        api_method: api.data.ga.get,
        parameters: {
          "ids" => "ga:#{VIEW_ID}",
          # "start-date" => options[:start_date].to_s,
          # "end-date" => options[:end_date].to_s,
          # "metrics" => options[:metrics],
          "start-date" => "2019-04-29",
          "end-date" => "2019-04-30",
          "metrics" => "ga:hits",
          "dimensions" => "ga:date"
        }
      )
    end

end
