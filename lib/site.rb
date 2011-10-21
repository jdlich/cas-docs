
CAS_VERSION = "3.4.1"

def select_items regex
  @items.select { |i| i.identifier =~ regex }
end

def chapters
  select_items %r{^/chapters/}
end

def titleize(identifier)
  filename = identifier.split("/").last
  filename.split("-")[1..-1].map { |w| w.capitalize }.join(" ")
end

def styles
  select_items(%r{/styles/styles/}).first
end

def cas_logo
  select_items(%r{/images/cas_logo/}).first
end