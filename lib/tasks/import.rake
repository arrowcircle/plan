namespace :import do
  task all: :environment do
    ignored_sheets = %w{ Итого }
    @not_found = []
    doc = SimpleXlsxReader.open('tmp/erp.xlsx')
    ac_id = Account.first.id
    sheets = doc.sheets.select { |sheet| !ignored_sheets.include?(sheet.name) }
    sheets = doc.sheets[0..-2] if doc.sheets.size > 1
    sheets.each do |sheet|
      unless ignored_sheets.include? sheet.name
        s = SheetParser.new(sheet, ac_id)
        s.parse
        @not_found = @not_found + s.not_found
      end
    end
    puts @not_found
    puts @not_found.size
  end
end


class SheetParser
  attr_accessor :sheet, :parent, :account_id, :not_found
  delegate :rows, to: :sheet

  def initialize(sheet, account_id = nil)
    @sheet = sheet
    @account_id = account_id
    @not_found = []
  end

  def parse
    puts
    puts "-- Started parsing sheet #{sheet.name}"
    rows.each do |xlsrow|
      row = RowParser.new(xlsrow, account_id)
      if row.good_to_import?
        @parent = row.item if row.parent?
        it = row.itemization(@parent.id) if @parent
        if it.present? && @parent.present?
          if it.quantity != row.quantity
            it.quantity = row.quantity
            it.account_id = account_id
            if it.save
              print '.'
            else
              print '-'
            end
          end
        else
          puts row.info
          @not_found << "#{row.articul}::#{row.name}"
        end
      end
    end
  end
end


class RowParser
  attr_accessor :row, :account_id

  def initialize(row, account_id = nil)
    @row = row
    @account_id = account_id
  end

  def parent?
    row[5] && (%w{x х}.include? row[5])
  end

  def articul
    row[1]
  end

  def name
    row[2]
  end

  def quantity
    row[4].try(:to_f)
  end

  def item
    @item = Item.where(articul: articul).first
    @item ||= create_item
    @item
  end

  def itemization(parent_id)
    return nil unless item.present?
    i = Itemization.where(parent_id: parent_id, item_id: item.id).first
    i ||= Itemization.new(parent_id: parent_id, item_id: item.id)
    i
  end

  def good_to_import?
    parent? || (quantity.present? && item.present?)
  end

  def create_item
    n = name
    n = articul unless n.present?
    i = Item.create(name: n, articul: articul, account_id: account_id) if articul.present?
    puts i.errors.full_messages if i && i.errors.any?
    i
  end

  def info
    "articul: #{articul}, quantity: #{quantity}"
  end
end
