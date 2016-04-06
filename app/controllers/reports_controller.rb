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

    EveApiService.character_id(name_list)
  end
end
