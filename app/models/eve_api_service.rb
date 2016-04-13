require 'open-uri'

module EveApiService
  BASE_PATH = "https://api.eveonline.com/eve"

  #eve api endpoints
  CHARACTER_ID_ENDPOINT_PATH = "/CharacterID.xml.aspx?names="
  CHARACTER_INFO_ENDPOINT_PATH = "/CharacterInfo.xml.aspx?characterID="
  CHARACTER_AFFILIATION_PATH = "/CharacterAffiliation.xml.aspx?ids="

  def self.character_id(names)
    EveApiService.eve_api_call(CHARACTER_ID_ENDPOINT_PATH, names)
  end

  def self.character_info(character_id)
    EveApiService.eve_api_call(CHARACTER_INFO_ENDPOINT_PATH, character_id)
  end

  def self.character_affiliation(character_ids)
    EveApiService.eve_api_call(CHARACTER_AFFILIATION_PATH, character_ids)
  end

  def self.eve_api_call(endpoint_path, argument)
    #CGI.escape wandelt den kram http konform um, nice one!
    xml = open(BASE_PATH + endpoint_path + CGI.escape(argument)).read
    XMLParser.parse(xml)
  end

  def self.element_value(eve_xml, element)
    value = eve_xml[element]
    if value.nil?
      value = ""
    else
      value
    end
  end
end
