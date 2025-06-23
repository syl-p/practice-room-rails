module PracticesHelper
  def current_practice
    current_practice_id =  session[:practice_id]
    if current_practice_id.present?
      @current_practices = Current.user.practices.find(current_practice_id)
    else
      @current_practices = Current.user.practices.first
      if @current_practices.present?
        session[:practice_id] = @current_practices.id
      end
    end

    @current_practices
  end
end
