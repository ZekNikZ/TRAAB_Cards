require 'squib'
require 'game_icons'

#data = Squib.csv file: 'data.csv'
data = Squib.xlsx file: 'data.xlsx'

primary_colors = { 'BLUE' => '#505EA7', 'RED' => '#9F2A27', 'GRAY' => '#999999', 'YELLOW' => '#A79850', 'PURPLE' => '#A450A7', 'GREEN' => '#50A757', 'PINK' => '#D675C7' }
secondary_colors = { 'BLUE' => '#7F8DBE', 'RED' => '#B76969', 'GRAY' => '#CCCCCC', 'YELLOW' => '#BEB37F', 'PURPLE' => '#BC7FBE', 'GREEN' => '#7FBE84', 'PINK' => '#F986E8' }
team_icons = { 'BLUE' => 'allied-star', 'RED' => 'unlit-bomb', 'GRAY' => 'perspective-dice-six-faces-random', 'YELLOW' => 'on-sight', 'PURPLE' => 'perspective-dice-six-faces-random', 'GREEN' => 'perspective-dice-six-faces-random', 'PINK' => 'easter-egg' }.map { |k, str| [k, GameIcons.get(str).recolor(fg: 'fff', bg: 'fff0').string] }.to_h
custom_icons = { 'YOG SOTHOTH' => 'interlaced-tentacles', 'ZOMBIE' => 'raise-zombie', 'BEHOLDER' => 'cowled', 'LEPRECHAUN' => 'shamrock' }.map { |k, str| [k, GameIcons.get(str).recolor(fg: 'fff', bg: 'fff0').string] }.to_h
names = ['RED', 'BLUE', 'GRAY', 'YELLOW', 'PURPLE', 'GREEN']

counts = data['count']
data = data.each{|name, values| data[name] = values.zip(counts).map{|index, count| [index]*count.to_i}.flatten}

#hint_state = 'off'
hint_state = 'black'

Squib::Deck.new(width: '2.5in', height: '3.5in', cards: data['role'].size, layout: 'layout.yml') do
  rect layout: 'background', fill_color: data['color'].map { |color| color ? secondary_colors[color.upcase] : 'white' }

  main_color = data['color'].map { |color| color ? primary_colors[color.upcase] : 'black' }

  triangle layout: 'toptri', fill_color: main_color
  rect layout: 'toprect', fill_color: main_color
  triangle layout: 'bottri', fill_color: main_color
  rect layout: 'botrect', fill_color: main_color

  svg layout: 'teamicon', data: data['color'].each_with_index.map { |color, i| custom_icons.key?(data['role'][i].upcase) ? custom_icons[data['role'][i].upcase] : team_icons[color ? color.upcase : 'BLUE'] }
  text layout: 'teamtext', str: data['color'].map { |color| (!color || color.upcase == 'PURPLE' ? '????' : color.upcase) + ' TEAM' }, hint: hint_state

  text layout: 'rolename', str: data['role'].map { |role| role.upcase }, hint: hint_state, font_size: data['role'].map { |role| !role || role.length < 14 ? 14 : role.length < 16 ? 13 : 12 }

  text layout: 'wincond', str: data['wincond'], hint: hint_state
  
  text layout: 'flavortext', str: data['flavor'], hint: hint_state, font_size: data['flavor'].map { |flavor| !flavor || flavor.length < 20 ? 13 : flavor.length < 24 ? 12 : 11 }
  text layout: 'abilitytext', str: data['ability'], hint: hint_state, font_size: data['ability'].map { |ability| !ability || ability.length < 120 ? 12 : ability.length < 140 ? 11 : ability.length < 160 ? 10 : 9 }

  save_pdf gap: 5
end