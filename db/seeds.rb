# Seeds para o Gerenciador de Cadastros

puts "Limpando dados existentes..."
Tecnico.destroy_all
Revenda.destroy_all
User.destroy_all
UserProfile.destroy_all

puts "Criando perfis de usuário..."
profiles = [
  { name: "administrador", active: true },
  { name: "gerente_contas", active: true },
  { name: "basico", active: true },
  { name: "revenda_admin", active: true },
  { name: "revenda_tecnico", active: true }
]

profiles.each do |profile_data|
  UserProfile.create!(profile_data)
end

puts "Criando usuários WebPosto..."
# Administrador (homem)
admin_user = User.create!(
  name: "Carlos Silva",
  email: "admin@gerenciador.com",
  login: "admin",
  password: "123456",
  password_confirmation: "123456",
  user_profile: UserProfile.find_by(name: "administrador"),
  active: true
)

# Gerentes de Contas (mulheres)
gerente1 = User.create!(
  name: "Maria Santos",
  email: "maria.santos@gerenciador.com",
  login: "maria.santos",
  password: "123456",
  password_confirmation: "123456",
  user_profile: UserProfile.find_by(name: "gerente_contas"),
  active: true
)

gerente2 = User.create!(
  name: "Ana Costa",
  email: "ana.costa@gerenciador.com",
  login: "ana.costa",
  password: "123456",
  password_confirmation: "123456",
  user_profile: UserProfile.find_by(name: "gerente_contas"),
  active: true
)

gerente3 = User.create!(
  name: "Lucia Oliveira",
  email: "lucia.oliveira@gerenciador.com",
  login: "lucia.oliveira",
  password: "123456",
  password_confirmation: "123456",
  user_profile: UserProfile.find_by(name: "gerente_contas"),
  active: true
)

# Usuário Básico (homem)
basico_user = User.create!(
  name: "João Pereira",
  email: "joao.pereira@gerenciador.com",
  login: "joao.pereira",
  password: "123456",
  password_confirmation: "123456",
  user_profile: UserProfile.find_by(name: "basico"),
  active: true
)

puts "Criando revendas..."
# Revenda 1
revenda1 = Revenda.new(
  cnpj: "11222333000181",
  razao_social: "TechSolutions Ltda",
  nome_fantasia: "TechSolutions",
  tipo_contato: "celular",
  telefone_suporte: "(11) 99999-1234",
  email_suporte: "suporte@techsolutions.com.br",
  responsavel: "Roberto Silva",
  cep: "01310-100",
  logradouro: "Av. Paulista",
  numero: "1000",
  complemento: "Sala 101",
  bairro: "Bela Vista",
  cidade: "São Paulo",
  uf: "SP",
  classificacao: "ouro",
  gerente_contas: gerente1
)
revenda1.save!(validate: false)

# Revenda 2
revenda2 = Revenda.new(
  cnpj: "98765432000110",
  razao_social: "InfoSystems S.A.",
  nome_fantasia: "InfoSystems",
  tipo_contato: "fixo",
  telefone_suporte: "(21) 3333-4567",
  email_suporte: "contato@infosystems.com.br",
  responsavel: "Patricia Lima",
  cep: "22071-900",
  logradouro: "Rua das Laranjeiras",
  numero: "500",
  bairro: "Laranjeiras",
  cidade: "Rio de Janeiro",
  uf: "RJ",
  classificacao: "prata",
  gerente_contas: gerente2
)
revenda2.save!(validate: false)

# Revenda 3
revenda3 = Revenda.new(
  cnpj: "11222333000144",
  razao_social: "DataTech Informática Ltda",
  nome_fantasia: "DataTech",
  tipo_contato: "0800",
  telefone_suporte: "0800-123-4567",
  email_suporte: "help@datatech.com.br",
  responsavel: "Fernando Costa",
  cep: "30112-000",
  logradouro: "Rua da Bahia",
  numero: "1200",
  complemento: "Andar 5",
  bairro: "Centro",
  cidade: "Belo Horizonte",
  uf: "MG",
  classificacao: "bronze",
  gerente_contas: gerente3
)
revenda3.save!(validate: false)

puts "Criando técnicos..."
# Técnicos da TechSolutions
Tecnico.create!(
  revenda: revenda1,
  name: "André Souza",
  email: "andre.souza@techsolutions.com.br",
  telefone: "(11) 98765-4321",
  funcao: "supervisor",
  especialista: true,
  perfil_acesso: "administrador",
  username: "andre.souza",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda1,
  name: "Bruno Lima",
  email: "bruno.lima@techsolutions.com.br",
  telefone: "(11) 97654-3210",
  funcao: "suporte",
  especialista: false,
  perfil_acesso: "tecnico",
  username: "bruno.lima",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda1,
  name: "Carlos Mendes",
  email: "carlos.mendes@techsolutions.com.br",
  telefone: "(11) 96543-2109",
  funcao: "desenvolvedor",
  especialista: true,
  perfil_acesso: "tecnico",
  username: "carlos.mendes",
  password: "123456"
)

# Técnicos da InfoSystems
Tecnico.create!(
  revenda: revenda2,
  name: "Diego Santos",
  email: "diego.santos@infosystems.com.br",
  telefone: "(21) 99876-5432",
  funcao: "analista",
  especialista: true,
  perfil_acesso: "administrador",
  username: "diego.santos",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda2,
  name: "Eduardo Silva",
  email: "eduardo.silva@infosystems.com.br",
  telefone: "(21) 98765-4321",
  funcao: "suporte",
  especialista: false,
  perfil_acesso: "tecnico",
  username: "eduardo.silva",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda2,
  name: "Felipe Costa",
  email: "felipe.costa@infosystems.com.br",
  telefone: "(21) 97654-3210",
  funcao: "dba",
  especialista: true,
  perfil_acesso: "tecnico",
  username: "felipe.costa",
  password: "123456"
)

# Técnicos da DataTech
Tecnico.create!(
  revenda: revenda3,
  name: "Gabriel Oliveira",
  email: "gabriel.oliveira@datatech.com.br",
  telefone: "(31) 99999-8888",
  funcao: "supervisor",
  especialista: true,
  perfil_acesso: "administrador",
  username: "gabriel.oliveira",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda3,
  name: "Henrique Alves",
  email: "henrique.alves@datatech.com.br",
  telefone: "(31) 98888-7777",
  funcao: "plantao",
  especialista: false,
  perfil_acesso: "tecnico",
  username: "henrique.alves",
  password: "123456"
)

Tecnico.create!(
  revenda: revenda3,
  name: "Igor Ferreira",
  email: "igor.ferreira@datatech.com.br",
  telefone: "(31) 97777-6666",
  funcao: "comercial",
  especialista: false,
  perfil_acesso: "tecnico",
  username: "igor.ferreira",
  password: "123456"
)

puts "\n=== BANCO POPULADO COM SUCESSO! ==="
puts "\nUsuários WebPosto:"
puts "Administrador: admin@gerenciador.com / 123456"
puts "Gerente 1: maria.santos@gerenciador.com / 123456"
puts "Gerente 2: ana.costa@gerenciador.com / 123456"
puts "Gerente 3: lucia.oliveira@gerenciador.com / 123456"
puts "Básico: joao.pereira@gerenciador.com / 123456"
puts "\nRevendas criadas: #{Revenda.count}"
puts "Técnicos criados: #{Tecnico.count}"
puts "\nTodos os usuários e técnicos têm senha: 123456"