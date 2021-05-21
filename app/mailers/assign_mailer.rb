class AssignMailer < ApplicationMailer
  default from: 'from@example.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email.split(","), subject: I18n.t('views.messages.complete_registration')
  end

  def owner_change_mail(email)
    # @owner = owner.pluck(:email)
    mail to: email, subject: I18n.t('views.messages.change_owner')
  end

  def delete_agenda_mail(users)
    # binding.irb
    @email = users.pluck(:email)
    mail to: @email, subject: I18n.t('views.messages.delete_sitaYo')
    # selectはアクティブレコードが返る
    # pluckは配列として返る
    # @email = users.select(:email)
    
  end
end