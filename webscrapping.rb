require 'rubygems'
require 'active_record'
require 'nokogiri'
require 'open-uri'

ActiveRecord::Base.establish_connection(
:adapter => "mysql2",
:host => "localhost",
:database => "sr",
:username => "root",
:password => "webonise6186"
)

class Recipe < ActiveRecord::Base
end

#main web page
document=Nokogiri::HTML(open('http://www.simplyrecipes.com'))   
a1=document.xpath('//a[text()="Receipe Index"]/@href')  
     
 #find Receipe-Index Page 
document1=Nokogiri::HTML(open("http://www.simplyrecipes.com/index")) ;  
   
#search all links for alphabet   
document1.xpath('//div[@class="entry-content"]/p/a').each_with_index do |node,index1|      #outer loop
#name of recipes 
name=node.content   
#links of recipes
url=node['href']   

#limit the records if you remove if and else it will give you all records        
if (index1==2)
break
else
#open each link of index page
document2=Nokogiri::HTML(open(url))        
document2.xpath('//h2/a').each_with_index do |node1, index2|
name1=node1.content
url1=node1['href'].to_s()
 
#open recipe page.
document3=Nokogiri::HTML(open(url1))    

#find the path of instructions of recipe   
description_of_recipe=document3.xpath('//div[@class="entry-content"]/div[@itemprop="description"]').to_s
#remove html tags from information
desc=description_of_recipe.gsub!(/(<[^>]*>)|\n|\t/s) {""}
instruction=document3.xpath('//div[@id="recipe-method"]/div[@itemprop="recipeInstructions"]').to_s

#find the path of yield of recipe  
yield1=document3.xpath('//div[@id="recipe-method"]/p/span[@class="yield"]').to_s()
#remove html tags from information
instructions=instruction.gsub!(/(<[^>]*>)|\n|\t/s) {""}
yields=yield1.gsub!(/(<[^>]*>)|\n|\t/s) {""}
#ingredient=document3.css('li.ingredient')
ingredient=document3.xpath('//div[@id="recipe-ingredients"]/ul').to_s()
ingredients=ingredient.gsub!(/(<[^>]*>)|\n|\t/s) {""}
puts ingredients
#find the path of cook time
cooktime=document3.xpath('//div[@class="recipe-meta"]/ul/li/span[@class="cooktime"]').to_s()
#remove html tags from information
cooktime1=cooktime.gsub!(/(<[^>]*>)|\n|\t/s) {""}
#find the path of preparation time
preptime=document3.xpath('//div[@class="recipe-meta"]/ul/li/span[@class="preptime"]').to_s()
#remove html tags from information
preptime1=preptime.gsub!(/(<[^>]*>)|\n|\t/s) {""}
#insert the data into table recipes.
Recipe.create(:recipe_name=>name1,:recipe_description=>desc,:recipe_method=>instructions,:yield=>yields,:pre_time=>preptime1,:cook_time=>cooktime1,:ingredient=>ingredients)
end  #end of if-else
end  #end of inner loop
end  #end of outer loop

