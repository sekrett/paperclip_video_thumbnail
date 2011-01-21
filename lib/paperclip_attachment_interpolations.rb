Paperclip.interpolates :content_type_extension do |attachment, style_name|
  case
    when ((style = attachment.styles[style_name]) && !style[:format].blank?) then style[:format]
    when style_name.to_s == 'transcoded' then 'flv'
    when style_name.to_s != 'original' then 'jpg'
  else
    File.extname(attachment.original_filename).gsub(/^\.+/, "")
  end
end
