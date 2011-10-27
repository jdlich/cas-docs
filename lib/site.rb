
CAS_VERSION = "3.4.1"

### View helpers

def chapters
  @items.select { |i| i.identifier =~ %r{^/chapters/} }
end

def first_chapter
  find_item %r{^/chapters/01.+/}
end

def titleize(identifier)
  filename = identifier.split("/").last
  filename.split("-")[1..-1].map { |w| w.capitalize }.join(" ")
end

def pdf
  find_item %r{^/download/pdf/}
end

def headers(html, tag)
  Nokogiri::HTML(html).css(tag)
end

def snapshot(item)
  item.compiled_content :snapshot => :pre
end

def styles
  find_item %r{/styles/styles/}
end

def cas_logo
  find_item %r{/images/cas_logo/}
end

def to_id(header_text)
  header_text.downcase.split(" ").map { |w| w.gsub(/[^a-zA-Z\-]/, '') }.join("-")
end

### Private

def find_item(regex)
  @items.find { |i| i.identifier =~ regex }
end