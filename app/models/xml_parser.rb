require 'nokogiri'

module XMLParser

  def self.parse(xml)
    doc = Nokogiri::XML.parse(xml)

    result = doc.xpath('//result').children

    results = Hash.new
    result.each do |node|
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
        #TODO: herausfinden wie ich vernuenftig den rest parse

      end
    end
    puts results.inspect
    results
  end
end
