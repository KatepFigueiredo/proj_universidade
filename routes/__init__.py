from .estudantes import estudantes_bp
from .auth import auth_bp
from .aulas import aulas_bp

def register_blueprints(app):
    app.register_blueprint(estudantes_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(aulas_bp)