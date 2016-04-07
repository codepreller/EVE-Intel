require 'nokogiri'

module XMLParser

  def self.parse(xml)
    doc = Nokogiri::XML.parse(xml)

    result = doc.xpath('//result').children

    results = Hash.new
    result.each do |node|
      #if the node is a rowset, parse the rowset
      if node.name == "rowset"
        name = node.attribute('name').to_s
        key = node.attribute('key').to_s
        columns = node.attribute('columns').to_s

        rows = Hash.new

        #get the information from the rowset
        node.xpath('//row').each do |row|
          attributes = Hash.new

          columns.split(',').each do |column|
            attributes[column] = row.attribute(column).to_s
          end

          rows[attributes[key]] = attributes
        end
        results[name] = rows
      else
        if (node.class.name == "Nokogiri::XML::Element")
          results[node.name] = node.content
        end
      end
    end
    results
  end
end
