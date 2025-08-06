# Gerenciador de Cadastros

Sistema completo para gerenciamento de cadastros de revendas e técnicos, desenvolvido em Ruby on Rails seguindo as melhores práticas de programação.

## Funcionalidades

### Tela Inicial
- **Revenda**: Acesso via validação de CNPJ
- **WebPosto**: Acesso administrativo via login/senha

### Perfis de Usuário
- **Administrador**: Acesso total ao sistema
- **Gerente de Contas**: Acesso total vinculado a uma revenda específica
- **Básico**: Apenas visualização

### Modelos
- **Revendas**: Cadastro completo com CNPJ, endereço, classificação
- **Técnicos**: Vinculados às revendas com diferentes funções
- **Usuários**: Sistema de autenticação e autorização

## Tecnologias Utilizadas

- **Ruby on Rails 8.0**
- **PostgreSQL** (produção) / **SQLite** (desenvolvimento)
- **Devise** (autenticação)
- **CanCanCan** (autorização)
- **Bootstrap 5** (frontend)
- **RSpec** (testes)
- **Brakeman** (segurança)
- **RuboCop** (qualidade de código)

## Instalação

### Pré-requisitos
- Ruby 3.4.5+
- Rails 8.0+
- PostgreSQL (para produção)
- Node.js (para assets)

### Passos

1. **Clone o repositório**
   ```bash
   git clone <repository-url>
   cd gerenciador_cadastros
   ```

2. **Instale as dependências**
   ```bash
   bundle install
   ```

3. **Configure o banco de dados**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Inicie o servidor**
   ```bash
   rails server
   ```

5. **Acesse a aplicação**
   - URL: http://localhost:3000
   - Usuário admin: admin@gerenciador.com
   - Senha: 123456

## Estrutura do Projeto

### Controllers
- `HomeController`: Tela inicial e validação de CNPJ
- `DashboardsController`: Dashboards da Revenda e WebPosto
- `RevendasController`: CRUD de revendas
- `UsersController`: Gerenciamento de usuários
- `TecnicosController`: Gerenciamento de técnicos

### Models
- `User`: Usuários com Devise
- `UserProfile`: Perfis de usuário (Administrador, Gerente, Básico)
- `Revenda`: Cadastro de revendas com validação de CNPJ
- `Tecnico`: Técnicos vinculados às revendas

### Segurança
- Autenticação com Devise
- Proteção CSRF
- Validação de CNPJ
- Hash seguro de senhas
- Strong Parameters

### Frontend
- Layout responsivo com Bootstrap 5
- Modais para interações
- JavaScript para validação de CNPJ
- Componentes reutilizáveis

## Testes

```bash
# Executar todos os testes
rspec

# Executar testes com cobertura
rspec --format documentation
```

## Qualidade e Segurança

```bash
# Análise de segurança
brakeman

# Qualidade de código
rubocop
```

## Deploy

### Variáveis de Ambiente (Produção)
- `DATABASE_USERNAME`: Usuário do PostgreSQL
- `DATABASE_PASSWORD`: Senha do PostgreSQL
- `DATABASE_HOST`: Host do banco de dados
- `SECRET_KEY_BASE`: Chave secreta do Rails

### Comandos de Deploy
```bash
# Preparar assets
rails assets:precompile

# Executar migrations
rails db:migrate RAILS_ENV=production

# Popular dados iniciais
rails db:seed RAILS_ENV=production
```

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT.
