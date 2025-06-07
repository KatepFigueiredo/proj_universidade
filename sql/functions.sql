CREATE OR REPLACE FUNCTION criar_utilizador(
    p_nome TEXT,
    p_email TEXT,
    p_password TEXT,
    p_tipo TEXT
)
RETURNS INT
AS $$
DECLARE
    novo_id INT;
BEGIN
    INSERT INTO utilizadores (nome, email, password, tipo_utilizador)
    VALUES (p_nome, p_email, p_password, p_tipo)
    RETURNING id INTO novo_id;

    IF p_tipo = 'estudante' THEN
        INSERT INTO estudantes_info (id_utilizador) VALUES (novo_id);
    ELSIF p_tipo = 'professor' THEN
        INSERT INTO professores_info (id_utilizador) VALUES (novo_id);
    END IF;

    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION procurar_utilizador_por_email(p_email TEXT)
RETURNS TABLE (id INT, password TEXT, tipo_utilizador TEXT)
AS $$
BEGIN
    RETURN QUERY
    SELECT id, password, tipo_utilizador
    FROM utilizadores
    WHERE email = p_email;
END;
$$ LANGUAGE plpgsql;
