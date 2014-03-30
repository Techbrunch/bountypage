#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

bugcrowd_list = {}

page = Nokogiri::HTML(open('https://bugcrowd.com/list-of-bug-bounty-programs'))
bounties = page.css('ul.the-list li')
bugcrowd_list['websites'] = []

bounties.each do |bounty|
  link = bounty.css('a')

  begin
    host = URI(link[0]['href']).host
  rescue
    puts 'Bad url'
  end

  name = link.text
  img  = name.downcase.gsub(/[^0-9a-z ]/i, '')

  css  = link[0].parent.attr('class').to_s.strip.split(' ')

  puts name + ':' + css.to_s

  reward = 'No'
  swag   = 'No'
  fame   = 'No'

  css.each do |item|
    case item
    when 'reward'
      reward = 'Yes'
    when 'swag'
      swag   = 'Yes'
    when'fame'
      fame   = 'Yes'
    end
  end

  File.open("img/bounties/#{img}.png", 'wb') do |fo|
    fo.write open("http://www.google.com/s2/favicons?domain=#{host}").read
  end

  bugcrowd_list['websites'].push(
    'name'   => link.text,
    'img'    => "#{img}.png",
    'url'    => link[0]['href'],
    'bounty' => 'Yes',
    'reward' => reward,
    'hof'    => fame,
    'swag'   => swag
  )
end

File.open('_data/bounties.yml', 'w') { |f| f.write bugcrowd_list.to_yaml }
