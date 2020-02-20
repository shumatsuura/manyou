class TaskMailer < ApplicationMailer
  def notification_mail(target_task)
    @target_task = target_task
    mail to: "#{@target_task.user.email}", subject: "Notification"
  end
end
