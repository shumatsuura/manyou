class MailBatch
  def self.execute
    threshold = DateTime.now + 1.week #期限直前の判定の閾値を設定（1週）
    target_tasks = Task.where('due <= ?', threshold).where("(status = ?) or (status = ?)", '未着手', '着手中')
    @target_task = target_tasks.first
    TaskMailer.notification_mail(@target_task).deliver
  end
end

MailBatch.execute
