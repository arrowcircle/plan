namespace :import do
  task basic: :environment do
    Item.delete_all
    Item.find_by_sql("select setval('items_id_seq', 1);")
    doc = SimpleXlsxReader.open('tmp/full_items_names.xlsx')
    sql_template = <<-SQL
      insert into items (name, articul, account_id, created_at, updated_at) values
    SQL
    account = Account.first
    @inserter = []
    doc.sheets.first.rows.each do |row|
      name, articul = row.first, row.last
      name = articul if name.nil? || name.size < 2
      if name && articul && name.size > 2 && articul.size > 2
        @inserter << "('#{name}','#{articul}',#{account.id}, now(), now())"
        print '.'
      else
        print 'x'
      end
    end
    Item.find_by_sql("#{sql_template} #{@inserter.join(',')}")
  end

  task sheets: :environment do
    @not_found = []
    doc = SimpleXlsxReader.open('tmp/erp.xlsx')
    ac_id = Account.first.id
    sheets = doc.sheets if doc.sheets.size == 1
    sheets = doc.sheets[0..-2] if doc.sheets.size > 1
    sheets.each { |sheet| s = SheetParser.new(sheet, ac_id); s.parse; @not_found = @not_found + s.not_found }
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

  def quantity1
    row[3].try(:to_f)
  end

  def quantity2
    row[4].try(:to_f)
  end

  def quantity
    if quantity1 && quantity2
      return quantity1 if quantity1 > quantity2
      quantity2
    elsif quantity1.nil?
      quantity2
    else
      quantity1
    end
  end

  def item
    @item = Item.where(articul: articul).first
    @item ||= Item.where(name: name).first
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
    n, a = name, articul
    n = articul unless n.present?
    a = n unless a.present?
    i = Item.create(name: n, articul: a, account_id: account_id) if n.present? && a.present?
    puts i.errors.full_messages if i && i.errors.any?
    i
  end

  def info
    "name: #{name}, articul: #{articul}, quantity: #{quantity}"
  end
end
