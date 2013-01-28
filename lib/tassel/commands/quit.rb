register_command 'quit', :mnemonic => :q do
  save!
  exit
end
