require 'httparty'
require 'link_thumbnailer'
require 'uri'

# rails import:image_from_webpage
namespace :import do
  desc "Import image And save it."
  task image_from_webpage: :environment do 
    url = 'http://content.guardianapis.com/search?q=obama&api-key=test'
    response = HTTParty.get(url)
    data = response.parsed_response

    #Get all the webpage url to be parsed
    data["response"]["results"].each do |item|
       web_page_url = item["webUrl"]
       object = LinkThumbnailer.generate(web_page_url)

       #Get all the images from the webpage
       object.images.each do |imagefound|
         imageData = imagefound.src.to_s
         
         #Get file name 
         uri = URI.parse(imageData)
         image_name = File.basename(uri.path)
         puts "\n"
         puts "For This WebPage \n #{item["webUrl"]}"

         #Download image to tmp folder
         File.open(Rails.root.join('app', "assets/images/#{image_name}"), "wb") do |f| 
           f.write HTTParty.get(imageData).body
         end
         puts "Image Name is #{image_name}"
         puts "Image Found on The Page is  \n #{imageData}"
       end
      puts "\n"
      puts "\n"
    end 
  end
end