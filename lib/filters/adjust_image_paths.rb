class AdjustImagePaths < Nanoc3::Filter
  
  identifier :adjust_image_paths
  type :text
  
  def run(content, params={})
    doc = Nokogiri::HTML(content)
    doc.css("img").each do |img|
      img["src"] = adjust_path(img["src"])
    end
    doc.to_html
  end
  
  def adjust_path(path)
    # directories = item.path.split("/").reject(&:empty?).length - 1
    # new_path    = "../" * directories
    path.gsub(/^(\/|\.\.\/)+/, "/")
  end
    
end