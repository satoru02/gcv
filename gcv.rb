require 'URI'
require 'net/http'
require 'Base64'
require 'json'
require 'dotenv'
Dotenv.load

URL = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV.fetch('GOOGLE_VISION_API_KEY')}"
uri = URI.parse(URL)
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true

req = Net::HTTP::Post.new(uri.request_uri)
req["Content-Type"] = "application/json"
param = {
  "requests" => [
    {
      "image" => {
        "content" => Base64.strict_encode64(open("./tmp/image.jpg").read)
      },
      "features" => [
        {
          "type" => "LABEL_DETECTION"
        },
        {
          "type" => "FACE_DETECTION"
        },
        {
          "type" => "IMAGE_PROPERTIES"
        },
        {
          "type" => "LOGO_DETECTION"
        }
      ]
    }
  ]
}

req.body = param.to_json
res = https.request(req)
File.write("res.json",res.body)