from .estudantes import estudantes_bp

def register_blueprints(app):
    app.register_blueprint(estudantes_bp)