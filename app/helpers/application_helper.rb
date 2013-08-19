module ApplicationHelper

  def full_title(page_title)
    base_title = "Hydro Flask"
  	if page_title.empty?
  	  base_title
  	else
  	  "#{base_title} | #{page_title}"
  	end
  end

  def display_account
  	link_to "My Account", orders_url if current_account.present?
  end
end