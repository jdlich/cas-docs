class PDFKitFilter < Nanoc3::Filter
  
  identifier :pdfkit
  type :text => :binary
  
  def run(content, params={})
    PDFKit.new(content, :page_size => 'Letter').to_file(output_filename)
  end
  
end