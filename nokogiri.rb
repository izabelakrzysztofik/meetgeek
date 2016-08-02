require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
# doc = Nokogiri::HTML(open('http://eventhunt.io/events-listing/london'))

# doc.css('.view-content > *').each do |link|
        
#   # dziala    
#   title = link.css('.col-md-8 > span.field-content:first').text #tytul 
#   time = link.css('.col-md-8 > span.field-content:nth-child(2)').text # godzina
#   who = link.css('.field-content.event-attendees').text #ile ludzi idzie 
#   host = link.css('.col-md-8 > span.field-content:nth-child(3)').text
#   price = link.css('.field-price').text # kasa 

#   url = link.css('.col-md-8 > span.field-content a').map { |link| link['href'].gsub(/[^0-9]/, '').to_i}

 
  
# #   puts "#{url}"
  
# end

# doc.css('* > #event-container').each do |lnk| 

#   p_date = lnk.css('.field-name-field-event-date > *')
  
#   puts "#{p_date}"
  
# end



# doc.css('#modal').each do |link| 
#  desc = link.css('.col-sm-8 > .event-description > field-type-text-long > .field-items > .field-item > p').text
#  puts "#{desc}"
# end
   

#  desc = link.css('.modal-dialog > .modal-content > .modal-body > .node > .content > .event-container > .col-sm-8 > .event-description > field-type-text-long > .field-items > .field-item > p').text
# doc.css('title').each do |link|
#     puts link.content
# end

# doc.css('.title-pop, .date-display-single, .field-content~ .field-content+ .field-content').each do |link|
#     puts link.content
# end

# .field-content - kto organizuje 
# .date-display-single - godzina 

      doc = Nokogiri::HTML(open('http://eventhunt.io/events-listing/london'))

      doc.css('.view-content > *').each do |link|

        uids = link.css('.col-md-8 > span.field-content a').map { |link| link['href'].gsub(/[^0-9]/, '').to_i }.compact
        
        # def       
        adr = nil 
        url = nil 
        date = nil 
        
        uids.each do |uid|
          Event.find_or_initialize_by(uid: uid) do |event|
            
            doc2 = Nokogiri::HTML(open('http://eventhunt.io/event/' + event.uid))

              doc2.css('.event-container > *').each do |link1| 
                date = link1.css('.col-sm-8 > .event-info > .field-name-field-event-date').text
#                 url = link1.css('.col-sm-4 > .event-links').text
#                 adr - link1.css('.view-map > .view-content > .view-rows > div:nth-child(3) > div > p').text
                puts "#{date}"
              end
            
              event.date = date 
#             event.url = url 
#             event.adr = adr

          end.save  #end of create loop
       end
        
    end  #  end doc loop 
  

