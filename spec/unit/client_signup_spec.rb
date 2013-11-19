require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Sift::Client do

  def valid_signup_properties
    {
      :$plugin_key => "abcdef123",
      :$shopify_url => "http://test-shop.myshopify.com",
      :$shopify_id => 12345,
      :$email => "bugs@bunny.com"
    }
  end

  def fully_qualified_client_signup_endpoint
    Sift::Client::API_ENDPOINT + Sift.current_client_signup_api_path
  end

  it "Successfuly handles a signup with the v203 API and returns OK" do

    response_json = {
      :status => 0,
      :error_message => "OK",

      :production => {
        :name => "store.myshopify.com",
        :api_key => "123456abcdef",
        :js_key => "98765gfd"
      },
      :sandbox => {
        :name => "store.myshopify.com/sandbox",
        :api_key => "456789abcdef",
        :js_key => "987654asdf"
      }
    }

    plugin_key = "abcdef123"

    FakeWeb.register_uri(:post, fully_qualified_client_signup_endpoint,
                         :body => MultiJson.dump(response_json),
                         :status => [Net::HTTPOK, "OK"],
                         :content_type => "text/json")

    api_key = "foobar"
    properties = valid_signup_properties

    response = Sift::Client.new(api_key, Sift.current_client_signup_api_path).signup(plugin_key, properties)
    response.ok?.should eq(true)
    response.api_status.should eq(0)
    response.api_error_message.should eq("OK")
  end

end