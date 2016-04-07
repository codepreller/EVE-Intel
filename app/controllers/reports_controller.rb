class ReportsController < ApplicationController
  def new
  end

  def create
    @character_ids = character_ids(reports_params[:names])
    @character_infos = character_info(@character_ids.values)
    render text: @character_infos
  end

  private

  def reports_params
    params.require(:report).permit(:names)
  end

  def character_ids(names)
    #eingabeliste by umbrüchen splitten, leere eintraege entfernen, dann wieder comma sepperated zusammenfügen zum string
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
