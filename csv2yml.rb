#!/usr/bin/env ruby

require 'csv'
require 'yaml'

dctrl = { 'members' => [] }

CSV.foreach("members.csv", options = { :headers => :first_row }) do |row|

  member = {}
  member['First'] = row['First']
  member['Last'] = row['Last']
  member['Email'] = row['Email']
  member['BTCAddr'] = row['Receiving Address']

  dctrl['members'] << member
end

puts YAML.dump(dctrl)
