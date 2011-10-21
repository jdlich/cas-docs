
def chapters
  @items.select { |i| i.identifier =~ %r{^/chapters/} }
end

def titleize(identifier)
  filename = identifier.split("/").last
  filename.split("-")[1..-1].map { |w| w.capitalize }.join(" ")
end