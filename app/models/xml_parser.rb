require 'nokogiri'

module XMLParser

  def self.parse(xml)
    doc = Nokogiri::XML.parse(xml)

    result = doc.xpath('//result').children

    results = Hash.new
    result.each do |node|
      if node.name == "rowset"
        puts name = node.attribute('name').to_s
        puts key = node.attribute('key').to_s
        puts columns = node.attribute('columns').to_s

        rows = Hash.new

        #get the information from the rowset
        node.children.compact.each do |row|
          attributes = Hash.new

          columns.split(',').compact.each do |column|
            attributes[column] = row.attribute(column).to_s
          end

          rows[attributes[key]] = attributes
        end
        results[name] = rows
        puts results
        results
      end
    end

    puts results.inspect
    results
  end
end
