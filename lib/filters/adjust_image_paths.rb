class AdjustImagePaths < Nanoc3::Filter
  
  identifier :adjust_image_paths
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
    image    = find_item %r{.+images.+#{filename}}
    File.absolute_path(nanoc_root) + "/content" + image.identifier.chomp("/") + "." + image[:extension]
  end
    
end