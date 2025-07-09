from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired
from prometheus_flask_exporter import PrometheusMetrics
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY')

metrics = PrometheusMetrics(app)

db_url = os.getenv('DATABASE_URL')
if db_url and db_url.startswith("mysql://"):
    db_url = db_url.replace("mysql://", "mysql+mysqlconnector://")

app.config['SQLALCHEMY_DATABASE_URI'] = db_url or "sqlite:///tasks.db"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    status = db.Column(db.String(20), default='Pending')

class TaskForm(FlaskForm):
    title = StringField('Task Title', validators=[DataRequired()])
    submit = SubmitField('Add Task')

with app.app_context():
    db.create_all()

@app.route('/')
def index():
    form = TaskForm()
    tasks = Task.query.all()
    return render_template('index.html', tasks=tasks, form=form)


@app.route('/add', methods=['POST'])
def add_task():
    form = TaskForm()
    if form.validate_on_submit():
        new_task = Task(title=form.title.data)
        db.session.add(new_task)
        db.session.commit()
        flash("Task added successfully!", "success")
    else:
        flash("Task title cannot be empty!", "error")
    return redirect(url_for('index'))

@app.route('/delete/<int:task_id>')
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)
    db.session.delete(task)
    db.session.commit()
    flash("Task deleted successfully!", "success")
    return redirect(url_for('index'))

@app.route('/update/<int:task_id>')
def update_task(task_id):
    task = Task.query.get_or_404(task_id)
    task.status = 'Completed'
    db.session.commit()
    flash("Task marked as completed!", "success")
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
