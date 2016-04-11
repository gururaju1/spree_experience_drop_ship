module Spree
  class ExperienceMailer < Spree::BaseMailer

    default from: Spree::Store.current.mail_from_address

    def welcome(experience_id)
      @experience = Experience.find experience_id
      mail to: @experience.email, subject: Spree.t('experience_mailer.welcome.subject')
    end

  end
end