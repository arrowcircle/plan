module CategoriesHelper
  def ancestry_options(items, &block)
    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id]
      #this is a recursive call:
      result += ancestry_options(sub_items) {|i| "#{'--' * i.depth} #{i.name}" }
    end
    result
  end

  def sortable(url)
    html = %Q{
      <script type="text/javascript">
      $(document).ready(function() {
        $("table.sortable").each(function(){
          var self = $(this);
          self.sortable({
            dropOnEmpty: false,
            cursor: 'crosshair',
            opacity: 0.75,
            handle: '.handle',
            axis: 'y',
            items: 'tr',
            scroll: true,
            update: function() {
              $.ajax({
                type: 'post',
                data: self.sortable('serialize') + '&authenticity_token=#{u(form_authenticity_token)}',
                dataType: 'script',
                url: '#{url}'
                })
              }
              });
              });
              });
              </script>
            }.gsub(/[\n ]+/, ' ').strip.html_safe
    content_for(:js, html)
  end
end
