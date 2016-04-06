require 'nokogiri'

module XMLParser

  def self.parse(xml)
    doc = Nokogiri::XML.parse(xml)
    children = doc.xpath('//result').children

    children.each_with_object({}) do |result, node|
      if node.name == "rowset"

        name = node.attribute('name').to_s
        key = node.attribute('key').to_s
        columns = node.attribute('columns').to_s.split(',')
  
        #get the information from the rowset
        node.children.each_with_object({}) do |result, row|
          attributes = Hash.new
  
          columns.each do |column|
            attributes[column] = row.attribute(column).to_s
          end
  
          rows[attributes[key]] = attributes
        end
        
        result[name] = rows
      end
    end

    puts results.inspect
    results
  end