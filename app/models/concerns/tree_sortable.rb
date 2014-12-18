module TreeSortable
  extend ActiveSupport::Concern

  module ClassMethods
    def sort(list = {})
      temp = {}

      list.each do |key, value|
        if temp[value]
          temp[value] << key
        else
          temp[value] = [key]
        end
      end

      temp.each do |parent, cats|
        i = 1
        if parent == 'root'
          pid = nil
        else
          pid = self.class.find(parent).id
        end
        cats.each do |cat|
          self.class.find(cat).update(parent_id: pid, position: i)
          i += 1
        end
      end
    end # end def sort
  end # end module ClassMethods
end # end module TreeSortable
