json.array! @items do |item|
  json.id item.id
  json.value item.full_name
end
