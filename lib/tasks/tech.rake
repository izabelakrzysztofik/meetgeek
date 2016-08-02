namespace :tech do
  
  desc "Fetch IT events" 
  task :fetch_tech => :environment do  

    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(open('http://eventhunt.io/events-listing/london'))
 
      doc.css('.view-content > *').each do |link|        
        
        name = link.css('.col-md-8 > span.field-content:first').text 
        time = link.css('.col-md-8 > span.field-content:nth-child(2)').text 
        people = link.css('.field-content.event-attendees').text 
        host = link.css('.col-md-8 > span.field-content:nth-child(3)').text
        price = link.css('.field-price').text 
        uids = link.css('.col-md-8 > span.field-content a').map { |link| link['href'].gsub(/[^0-9]/, '').to_i }.compact
      
        
        uids.each do |uid| 
          Event.find_or_initialize_by(uid: uid) do |event|
            event.name = name 
            event.time = time 
            event.host = host 
            event.people = people
            event.price = price 
          end.save 
       end
        
    end  #  end doc loop 
  end   #   end fetch_tech task 
  
  desc "Update participants" 
  task :update_people => :environment do  
    
  require 'nokogiri'
  require 'open-uri'

  doc = Nokogiri::HTML(open('http://eventhunt.io/events-listing/london'))
  doc.css('.view-content > *').each do |link|   
        
     people = link.css('.field-content.event-attendees').text 
        
     Event.changed?(people: people) do |event|
       event.people = people
     end.save 

  end  
    
 end # end update_people 
  
end # end namespace

namespace :tech do

  desc "Fetch IT events"
  task :fetch_tech => :environment do

    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(open('http://eventhunt.io/events-listing/london'))

    doc.css('.view-content > *:not(h3)').each do |row|
      if row.css('.title-pop').present?
        uid = row.css('.title-pop').first['href'].gsub(/[^0-9]/, '').to_i
        
        Event.find_or_initialize_by(uid: uid) do |event|

          modal         = Nokogiri::HTML(open("http://eventhunt.io/event/#{uid}"))
          event.name    = row.css('.title-pop').text
          event.time    = row.css('.date-display-single').text
          event.host    = row.css('.col-md-8 > span.field-content:nth-child(3)').text
          event.people  = row.css('.event-attendees').text
          event.price   = row.css('.field-price').text
          event.start_date    = modal.css('.event-info .date-display-single').text
          event.event_url     = modal.css('.event-links > a').first['href']
          event.adr     = modal.css('.views-field-title > .field-content').text
          event.desc    = modal.css('.field-name-field-event-description').text
          event.free    = (event.price.blank? or event.price == "0.00 GBP")
        end.save
      end
    end 
  end  


  desc "Delete all events"
  task :del => :environment do
    Event.destroy_all
  end # end of delete task  

end  

