class ReportsController < ApplicationController
  def new
  end

  def show
    @alliance_count = ReportInformation.where(report_id: params[:id]).group("alliance_name").count
  end

  def create
    #get the character ids from character_name: character_id hash
    character_ids = character_ids(reports_params[:names]).keys

    @report = Report.create

    #get the character affiliation informations and persist them
    character_affiliation(character_ids, @report.id)

    redirect_to @report
  end

  private

  def reports_params
    params.require(:report).permit(:names)
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
          character_id: character_info["characterID"],
          character_name: character_info["characterName"],
          corporation_id: character_info["corporationID"],
          alliance_id: character_info["allianceID"]
        )
      else
        character.update(
          character_name: character_info["characterName"],
          corporation_id: character_info["corporationID"],
          alliance_id: character_info["allianceID"]
        )
      end
    end
    character_infos
  end

  def character_affiliation(character_ids, report_id)
    character_result = EveApiService.character_affiliation(character_ids.compact.join(','))
    characters_affiliations = character_result["characters"]

    character_ids.each do |character_id|
      character_affiliations = characters_affiliations[character_id]

      #save unknown alliances
      alliance_id = character_affiliations["allianceID"]
      save_alliance(alliance_id, character_affiliations["allianceName"])

      #save report information
      save_report_informations(character_affiliations, report_id)
    end
  end

  def save_report_informations(character_affiliations, report_id)
    ReportInformation
      .create(
        report_id: report_id,
        character_id: character_affiliations["characterID"],
        character_name: character_affiliations["characterName"],
        alliance_id: character_affiliations["allianceID"],
        alliance_name: character_affiliations["allianceName"],
        corporation_id: character_affiliations["allianceID"],
        corporation_name: character_affiliations["allianceName"]
      )
  end

  def save_alliance(alliance_id, alliance_name)
    Alliance
      .create_with(alliance_id: alliance_id, alliance_name: alliance_name)
      .find_or_create_by(alliance_id: alliance_id)
  end
end
