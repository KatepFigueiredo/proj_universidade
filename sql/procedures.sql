-- Procedimento para matricular estudante em aula
CREATE OR REPLACE PROCEDURE matricular_estudante_aula(
    p_id_estudante INT,
    p_id_aula INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    estudante_existe BOOLEAN;
    v_data_aula DATE;
    ja_matriculado BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM utilizadores WHERE id = p_id_estudante AND tipo_utilizador = 'estudante'
    ) INTO estudante_existe;

    IF NOT estudante_existe THEN
        RAISE EXCEPTION 'Estudante com ID % não encontrado ou não é um estudante válido.', p_id_estudante;
    END IF;

    SELECT data INTO v_data_aula
    FROM aulas
    WHERE id = p_id_aula;

    IF v_data_aula IS NULL THEN
        RAISE EXCEPTION 'Aula com ID % não encontrada.', p_id_aula;
    END IF;

    SELECT EXISTS (
        SELECT 1 FROM participacoes WHERE id_estudante = p_id_estudante AND id_aula = p_id_aula AND data_aula = v_data_aula
    ) INTO ja_matriculado;

    IF ja_matriculado THEN
        RAISE EXCEPTION 'Estudante com ID % já está matriculado na aula % na data %.', p_id_estudante, p_id_aula, v_data_aula;
    END IF;

    INSERT INTO participacoes (id_estudante, id_aula, data_aula)
    VALUES (p_id_estudante, p_id_aula, v_data_aula);

END;
$$;