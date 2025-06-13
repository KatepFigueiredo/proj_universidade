-- 1. Criação das roles solicitadas (estudante e professor)
CREATE ROLE role_estudante NOLOGIN;
CREATE ROLE role_professor NOLOGIN;

-- 2. Conceder privilégios nas tabelas já EXISTENTES
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_estudante;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO role_professor;

-- 3. Definir ALTER DEFAULT PRIVILEGES para OBJETOS FUTUROS

ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT SELECT ON TABLES TO role_estudante;
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO role_professor;

-- Para Sequências Futuras (necessário para SERIAL/BIGSERIAL para que as roles possam usar os IDs)
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT USAGE ON SEQUENCES TO role_estudante;
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT USAGE ON SEQUENCES TO role_professor;

-- Para Funções e Procedimentos Futuros (essencial para que as roles possam CHAMAR as suas funções/procedimentos)
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT EXECUTE ON FUNCTIONS TO role_estudante;
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
GRANT EXECUTE ON FUNCTIONS TO role_professor;

-- 4. Criação do utilizador da aplicação
CREATE USER app_user WITH PASSWORD 'xoN924kot';

-- 5. Atribuição das nossas roles ao utilizador da aplicação
GRANT role_estudante TO app_user;
GRANT role_professor TO app_user;