namespace :import do
  task all: :environment do
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
end
