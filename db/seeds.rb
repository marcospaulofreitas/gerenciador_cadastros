# Seeds para popular dados iniciais

# Criar perfis de usuário
profiles = [
  { name: 'administrador', active: true },
  { name: 'gerente_contas', active: true },
  { name: 'basico', active: true }
]

profiles.each do |profile_attrs|
  UserProfile.find_or_create_by!(name: profile_attrs[:name]) do |profile|
    profile.active = profile_attrs[:active]
  end
end

puts "Perfis de usuário criados com sucesso!"

# Criar usuário administrador padrão
admin_profile = UserProfile.find_by(name: 'administrador')

if admin_profile
  admin_user = User.find_or_create_by!(email: 'admin@gerenciador.com') do |user|
    user.name = 'Administrador'
    user.login = 'admin'
    user.password = '123456'
    user.password_confirmation = '123456'
    user.user_profile = admin_profile
    user.active = true
  end
  
  puts "Usuário administrador criado: #{admin_user.email}"
end
