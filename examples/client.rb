#!/usr/bin/env ruby
#
# A simple example of how to use the API.

require 'rubygems'
require 'sift'
require 'multi_json'

TIMEOUT = 5

if ARGV.length.zero?
  puts "Please specify an Plugin key"
  puts "usage:"
  puts " ruby client.rb <Plugin KEY>"
  puts
  exit
end
plugin_key = ARGV[0];

class MyLogger
  def warn(e)
    puts "[WARN]  " + e.to_s
  end

  def error(e)
    puts "[ERROR] " + e.to_s
  end

  def fatal(e)
    puts "[FATAL] " + e.to_s
  end

  def info(e)
    puts "[INFO]  " + e.to_s
  end
end

def handle_response(response)
  if response.nil?
    puts 'Error: there was an HTTP error calling through the API'
  else
    puts 'Successfully sent request; was ok? : ' + response.ok?.to_s
    puts 'API error message                  : ' + response.api_error_message.to_s
    puts 'API status code                    : ' + response.api_status.to_s
    puts 'HTTP status code                   : ' + response.http_status_code.to_s
    puts 'original request                   : ' + response.original_request.to_s
    puts 'json                               : ' + response.json.to_s
  end
end

Sift.logger = MyLogger.new

client = Sift::Client.new(plugin_key, "#{Sift::Client::SIGNUP_ENDPOINT + Sift.current_client_signup_api_path}")
properties = {

  # These fields are required and need to be
  # unique per client
  "$shopify_url"      => "acme.myshopify.com",
  "$shopify_id"       => "12345",
  "$email"            => "bugsy@bunny.com",

  # These are optional
  "$name"             => "Bugs Bunny Club",
  "$domain"           => "acmeclubs.com",
  "$shop_owner"       => "Bugs Bunny",
  "$address1"         => "123 Rabbit Rd",
  "$city"             => "Carrotsville",
  "$province"         => "New Mexico",
  "$province_code"    => "NM",
  "$country"          => "United States",
  "$zip"              => "87002",
  "$plan_name"        => "enterprise",
  "$timezone"         => "PDT"
}

handle_response client.signup(plugin_key, properties, TIMEOUT)