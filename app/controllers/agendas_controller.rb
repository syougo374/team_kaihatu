class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[destroy]
  before_action :authenticate_user!

  # binding.irb
  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def destroy
    # @team = Team.find(params[:id])
    @team = @agenda.team
    # メンバー全員にメール送るため、@team.members
    @users = @team.members
    path = Rails.application.routes.recognize_path(request.referer)
    # binding.irb
    if current_user.id == @agenda.user_id || current_user.id == @team.owner_id
      @agenda.destroy
      AssignMailer.delete_agenda_mail(@users).deliver
      redirect_to dashboard_path
    else
      redirect_to path
    end
  end


  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  private

  def set_agenda
    # binding.irb
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description ]
  end
end
