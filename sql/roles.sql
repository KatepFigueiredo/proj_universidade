CREATE ROLE role_estudante NOLOGIN; -- NOLOGIN: Esta role não pode ser usada para login direto
CREATE ROLE role_professor NOLOGIN; -- NOLOGIN: Esta role não pode ser usada para login direto

-- Privilégios para role_estudante (apenas consulta em todas as tabelas)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_estudante;

-- Importante: para tabelas criadas no futuro
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT SELECT ON TABLES TO role_estudante;

-- Privilégios para role_professor (consulta e alteração em todas as tabelas)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO role_professor;

-- Importante: para tabelas criadas no futuro
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO role_professor;

-- Criação de um utilizador com as roles definidas
CREATE USER app_user WITH PASSWORD 'xoN924kot';

-- Atribuição das roles ao utilizador
GRANT role_estudante TO app_user;
GRANT role_professor TO app_user;
