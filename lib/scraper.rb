require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css("div.roster-cards-container").each do |profile|
      profile.css(".student-card a").each do |student|
        profile_url = "#{student.attr('href')}"
        location = student.css('.student-location').text
        name = student.css('.student-name').text
        students << {name: name, location: location, profile_url: profile_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}

    profile = page.css(".social-icon-container").children.css("a").map do |link|
      link.attribute('href').value
    end

    profile.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    if page.css(".profile-quote")
      student[:profile_quote] = page.css(".profile-quote").text
    end
    if page.css("div.bio-content.content-holder div.description-holder p")
      student[:bio] = page.css("div.bio-content.content-holder div.description-holder p").text
    end
    student
  end
end

