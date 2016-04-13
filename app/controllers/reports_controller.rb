class ReportsController < ApplicationController
  def new
  end

  def show
    render text:"Juhu, ne View"
  end

  def create
    #get the character ids from character_name: character_id hash
    character_ids = character_ids(reports_params[:names]).keys

    #get the character informations and save them in the db
    character_affiliation(character_ids)

    @alliance_count = count_alliances(character_ids)
    redirect_to action: "show", id: "5"
  end

  private

  def reports_params
    params.require(:report).permit(:names)
  end

  def count_alliances(character_ids)
    alliance_count = Hash.new(0)
    character_ids.each do |character_id|
      alliance = Character.find_by(character_id: character_id).alliance_name
      alliance_count[alliance] += 1
    end

    alliance_count
  end

  def character_ids(names)
    #eingabeliste by umbrüchen splitten, leere eintraege entfernen, dann wieder comma separated zusammenfügen zum string
    name_list = names.split("\r\n").compact.join(',')
    character_results = EveApiService.character_id(name_list)

    character_ids = Hash.new
    character_results["characters"].each do |name, character_id|
      character_ids[name] = character_id
    end

    character_ids
  end

  def character_info(character_ids)
    character_infos = Hash.new
    character_ids.each do |character_id|
      character_info = EveApiService.character_info(character_id)
      character_infos[character_id] = character_info

      character = Character.find_by(character_id: character_id)
      if character.nil?
        Character.create(
          character_id: EveApiService.element_value(character_info, "characterID"),
          character_name: EveApiService.element_value(character_info, "characterName"),
          corporation_id: EveApiService.element_value(character_info, "corporationID"),
          corporation_name: EveApiService.element_value(character_info, "corporation"),
          alliance_id: EveApiService.element_value(character_info, "allianceID"),
          alliance_name: EveApiService.element_value(character_info, "alliance")
        )
      else
        character.update(
          character_name: EveApiService.element_value(character_info, "characterName"),
          corporation_id: EveApiService.element_value(character_info, "corporationID"),
          corporation_name: EveApiService.element_value(character_info, "corporation"),
          alliance_id: EveApiService.element_value(character_info, "allianceID"),
          alliance_name: EveApiService.element_value(character_info, "alliance")
        )
      end
    end
    character_infos
  end

  def character_affiliation(character_ids)
    character_result = EveApiService.character_affiliation(character_ids.compact.join(','))
    characters_affiliations = character_result["characters"]

    character_ids.each do |character_id|
      character_affiliations = characters_affiliations[character_id]

      character = Character.find_by(character_id: character_id)
      if character.nil?
        Character.create(
          character_id: EveApiService.element_value(character_affiliations, "characterID"),
          character_name: EveApiService.element_value(character_affiliations, "characterName"),
          corporation_id: EveApiService.element_value(character_affiliations, "corporationID"),
          corporation_name: EveApiService.element_value(character_affiliations, "corporationName"),
          alliance_id: EveApiService.element_value(character_affiliations, "allianceID"),
          alliance_name: EveApiService.element_value(character_affiliations, "allianceName")
        )
      else
        character.update(
          character_name: EveApiService.element_value(character_affiliations, "characterName"),
          corporation_id: EveApiService.element_value(character_affiliations, "corporationID"),
          corporation_name: EveApiService.element_value(character_affiliations, "corporationName"),
          alliance_id: EveApiService.element_value(character_affiliations, "allianceID"),
          alliance_name: EveApiService.element_value(character_affiliations, "allianceName")
        )
      end

    end
  end

  def save_character(character_ids)
    character_ids.each do |name, character_id|
      @character = Character.new(name:name, character_id:character_id)
      @character.save
    end
  end
end
