class ReportsController < ApplicationController
  def new
  end

  def create
    @user_ids = user_ids(reports_params[:names])
    render text: @user_ids
  end

  private

  def reports_params
    params.require(:report).permit(:names)
  end

  def user_ids(names)
    #eingabeliste by umbrüchen splitten, leere eintraege entfernen, dann wieder comma sepperated zusammenfügen zum string
    name_list = names.split("\r\n").compact.join(',')

    character_ids = EveApiService.character_id(name_list)
  end

  def user_info(character_id)
    EveApiService.character_info(character_id)
  end

  def save_character(character_ids)
    character_ids.each do |name, character_id|
      @character = Character.new(name:name, characterID:character_id)
      @character.save
    end
  end
end
