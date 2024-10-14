class ContactMailer < ApplicationMailer
  def send_group_message(user, message) #メソッドに対して引数を設定
    @user = user #ユーザー情報
    @message = message.message #返信内容
    mail(
      to: @user.email,
      subject: message.title
    )
  end
end
