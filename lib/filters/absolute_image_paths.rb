
#
# wkhtmltopdf requires absolute image paths.
#
# So, this filter updates each img tag's src attribute
# with the absolute path from your system's root
#

class AbsoluteImagePaths < Nanoc3::Filter
  
  identifier :absolute_image_paths
  type :text
  
  def run(content, params={})
    doc = Nokogiri::HTML(content)
    doc.css("img").each do |img|
      img["src"] = path_from_system_root(img["src"])
    end
    doc.to_html
  end
  
  def path_from_system_root(path)
    filename = path.split("/").last.split(".").first
    image = find_item %r{.+images.+#{filename}}
    begin
      File.absolute_path(nanoc_root) + "/content" + image.identifier.chomp("/") + "." + image[:extension]
    rescue NoMethodError
      raise "Could not find the following image: #{filename}."
    end
  end
    
end