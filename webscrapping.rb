require 'nokogiri'
require 'open-uri'

document=Nokogiri::HTML(open('http://www.simplyrecipes.com'))   #main web page
a1=document.xpath('//a[text()="Receipe Index"]/@href')          #find Receipe-Index

document1=Nokogiri::HTML(open("http://www.simplyrecipes.com/index")) ;          #index page
document1.xpath('//div[@class="entry-content"]/p/a').each_with_index do |node,index1|      #outer loop
name=node.content           #name of recipes 
url=node['href']            #links of recipes

document2=Nokogiri::HTML(open(url))          #open each link of index page
document2.xpath('//h2/a').each_with_index do |node1, index2|
name1=node1.content
url1=node1['href'].to_s()

document3=Nokogiri::HTML(open(url1))        #open recipe page.
description_of_recipe=document3.xpath('//div[@class="entry-content"]/div[@itemprop="description"]').to_s()
method1=document3.xpath('//div[@id="recipe-method"]/div[@itemprop="recipeInstructions"]').to_s()
method2=document3.xpath('//div[@id="recipe-method"]/span[@class="yield"]').to_s()
method3=method1 + method2

end  #end of inner loop
end  #end of outer loop
