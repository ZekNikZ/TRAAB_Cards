require 'squib'
require 'game_icons'

#data = Squib.csv file: 'data.csv'
data = Squib.xlsx file: 'data.xlsx'

primary_colors = { 'BLUE' => '#505EA7', 'RED' => '#9F2A27', 'GRAY' => '#6F6F6F', 'YELLOW' => '#C9A82A', 'PURPLE' => '#8f14b8', 'GREEN' => '#4db353', 'PINK' => '#f76eb3', 'BLACK' => '#000' }
secondary_colors = { 'BLUE' => '#7F8DBE', 'RED' => '#B76969', 'GRAY' => '#999999', 'YELLOW' => '#D0BA62', 'PURPLE' => '#b366cc', 'GREEN' => '#7FBE84', 'PINK' => '#f5a3cc', 'BLACK' => '#000' }
team_icons = { 'BLUE' => 'allied-star', 'RED' => 'unlit-bomb', 'GRAY' => 'perspective-dice-six-faces-random', 'YELLOW' => 'on-sight', 'PURPLE' => 'perspective-dice-six-faces-random', 'GREEN' => 'perspective-dice-six-faces-random', 'PINK' => 'easter-egg' }.map { |k, str| [k, GameIcons.get(str).recolor(fg: 'fff', bg: 'fff0').string] }.to_h
custom_icons = { 'YOG SOTHOTH' => 'interlaced-tentacles', 'ZOMBIE' => 'raise-zombie', 'BEHOLDER' => 'cowled', 'LEPRECHAUN' => 'shamrock' }.map { |k, str| [k, GameIcons.get(str).recolor(fg: 'fff', bg: 'fff0').string] }.to_h
names = ['RED', 'BLUE', 'GRAY', 'YELLOW', 'PURPLE', 'GREEN']

counts = data['count']
data = data.each{|name, values| data[name] = values.zip(counts).map{|index, count| [index]*count.to_i}.flatten}

hint_state = 'off'
#hint_state = 'black'

Squib::Deck.new(width: '2.5in', height: '3.5in', cards: data['role'].size, layout: 'layout.yml') do
  rect layout: 'background', fill_color: data['color'].map { |color| color ? secondary_colors[color.upcase] : 'white' }

  main_color = data['color'].map { |color| color ? primary_colors[color.upcase] : 'black' }

  triangle layout: 'toptri', fill_color: main_color
  rect layout: 'toprect', fill_color: main_color
  triangle layout: 'bottri', fill_color: main_color
  rect layout: 'botrect', fill_color: main_color

  not_black_range = (0..(data['role'].size - 1)).to_a
  black_index = data['role'].find_index('THE BLACK')
  not_black_range.delete_at(black_index) if black_index 

  svg layout: 'teamicon', data: data['color'].each_with_index.map { |color, i| custom_icons.key?(data['role'][i].upcase) ? custom_icons[data['role'][i].upcase] : team_icons[color ? color.upcase : 'BLUE'] }, range: not_black_range
  text layout: 'teamtext', str: data['color'].each_with_index.map { |color, i| data['role'][i] == 'ZOMBIE' ? 'TEAM ZOMBIE' : (!color || color.upcase == 'PURPLE' ? '????' : color.upcase) + ' TEAM' }, hint: hint_state, range: not_black_range

  text layout: 'rolename', str: data['role'].map { |role| role.upcase }, hint: hint_state, font_size: data['role'].map { |role| !role || role.length < 8 ? 16 : role.length < 13 ? 15 : role.length < 14 ? 14 : role.length < 16 ? 13 : 12 }

  text layout: 'wincond', str: data['wincond'], hint: hint_state, font_size: data['wincond'].map { |wincond| !wincond || wincond.length < 127 ? 11 : wincond.length < 137 ? 10 : wincond.length < 180 ? 9 : 8}
  
  text layout: 'flavortext', str: data['flavor'].map { |flavor| flavor ? flavor.upcase : '' }, hint: hint_state, font_size: data['flavor'].map { |flavor| !flavor || flavor.length < 18 ? 12 : flavor.length < 22 ? 11 : 10 }
  text layout: 'abilitytext', str: data['ability'], hint: hint_state, font_size: data['ability'].map { |ability| !ability || ability.length < 120 ? 12 : ability.length < 135 ? 11 : ability.length < 186 ? 10 : ability.length < 246 ? 9 : 8}

  save_pdf gap: 5
  #save_pdf gap: 5, height: 3300, width: 5100
  #save_pdf gap: 5, height: 2550, width: 4200
end
