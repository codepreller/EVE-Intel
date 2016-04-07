class ReportsController < ApplicationController
  def new
  end

  def create
    @character_ids = character_ids(reports_params[:names])
    @character_infos = character_info(@character_ids.values)

    @alliance_count = alliances(@character_infos)
    render text: @alliance_count
  end

  private

  def reports_params
    params.require(:report).permit(:names)
  end

  def alliance(character_info)
    alliance = character_info["alliance"]
    if alliance.nil?
      puts "testnil"
      alliance = "ohne Corp"
    else
      puts alliance
      alliance
    end
  end

  def alliances(character_infos)
    alliance_count = Hash.new(0)
    character_infos.values.each do |character_info|
      alliance = alliance(character_info)
      puts alliance
      alliance_count[alliance] += 1
    end

    alliance_count
  end

  def character_ids(names)
    #eingabeliste by umbrüchen splitten, leere eintraege entfernen, dann wieder comma separated zusammenfügen zum string
    name_list = names.split("\r\n").compact.join(',')

    character_ids = EveApiService.character_id(name_list)
  end

  def character_info(character_ids)
    character_infos = Hash.new
    character_ids.each do |character_id|
      character_infos[character_id] = EveApiService.character_info(character_id)
    end
    character_infos
  end

  def save_character(character_ids)
    character_ids.each do |name, character_id|
      @character = Character.new(name:name, characterID:character_id)
      @character.save
    end
  end
end
