def full_title(page_title)
  base_title = "Hotels"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end
def human_boolean(boolean)
  boolean ? 'Yes' : 'No'
end


