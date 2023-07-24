module UsersHelper
  def level_progress_percentage(user)
    current_level_exp = user.exp - user.exp_needed_for_current_level
    progress_percentage = (current_level_exp.to_f / Experience::LEVEL_UP_EXPERIENCE) * 100
    [progress_percentage, 100].min # プログレスバーの最大幅は100%に制限します
  end



  
end
