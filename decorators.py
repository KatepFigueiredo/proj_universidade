# decorators.py
from functools import wraps
from flask import jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from db import db_connection

def role_required(allowed_types): # allowed_types refere-se ao tipo_utilizador ('estudante', 'professor')
    def decorator(f):
        @wraps(f)
        @jwt_required()
        def decorated_function(*args, **kwargs):
            current_user_identity = get_jwt_identity() # Ex: {"id": 1, "tipo_utilizador": "estudante"}
            user_type = current_user_identity.get("tipo_utilizador")

            if user_type not in allowed_types:
                return jsonify({"erro": "Acesso não autorizado: tipo de utilizador sem permissão."}), 403

            # Mapeia o tipo de utilizador da aplicação para a role do PostgreSQL
            db_role = None
            if user_type == 'estudante':
                db_role = 'role_estudante'
            elif user_type == 'professor':
                db_role = 'role_professor'
            
            if not db_role:
                return jsonify({"erro": "Erro interno: Tipo de utilizador desconhecido ou role não mapeada."}), 500

            conn = None
            try:
                conn = db_connection(role=db_role) # A conexão é aberta com a role
                # Passa o ID do utilizador e a conexão para a função da rota
                kwargs['current_user_id'] = current_user_identity.get("id") 
                kwargs['conn'] = conn 
                result = f(*args, **kwargs)
                return result
            except Exception as e:
                # Captura erros do DB (ex: permissão negada pelo SET ROLE)
                return jsonify({"erro": f"Erro na base de dados: {str(e)}"}), 500
            finally:
                if conn:
                    conn.close() # Garante que a conexão seja fechada
        return decorated_function
    return decorator