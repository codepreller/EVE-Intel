require 'open-uri'

module EveApiService
  BASE_PATH = "https://api.eveonline.com/eve"

  #eve api endpoints
  CHARACTER_ID_ENDPOINT_PATH = "/CharacterID.xml.aspx?names="
  CHARACTER_INFO_ENDPOINT_PATH = "/CharacterInfo.xml.aspx?characterID="


  def self.character_id(name_list)
    result = EveApiService.eve_api_call(CHARACTER_ID_ENDPOINT_PATH, name_list)

    character_ids = Hash.new
    result['characters'].each do |character_id, character_info|
      character_ids[character_info["name"]] = character_id
    end

    character_ids
  end

  def self.character_info(character_id)
    result = EveApiService.eve_api_call(CHARACTER_INFO_ENDPOINT_PATH, character_id)
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
