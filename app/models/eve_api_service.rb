require 'open-uri'

module EveApiService
  BASE_PATH = "https://api.eveonline.com/eve"

  def self.character_id(name_list)
    #CGI.escape wandelt den kram http konform um, nice one!
    xml = open(BASE_PATH + "/CharacterID.xml.aspx?names=" + CGI.escape(name_list)).read
    XMLParser.parse(xml)
  end
end
