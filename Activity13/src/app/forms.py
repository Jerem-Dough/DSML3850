'''
DSML3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
'''

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, TextAreaField, SelectField, SubmitField, validators
from wtforms.validators import DataRequired

class SignUpForm(FlaskForm):
    id = StringField('Id', validators=[DataRequired()])
    name = StringField('Name', validators=[DataRequired()])
    about = TextAreaField('About')
    passwd = PasswordField('Password', validators=[DataRequired()])
    passwd_confirm = PasswordField('Confirm Password', validators=[DataRequired()])
    submit = SubmitField('Confirm')

class LoginForm(FlaskForm):
    id = StringField('Id', validators=[DataRequired()])
    passwd = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Confirm')

class RecipeForm(FlaskForm):
    number = StringField('Recipe#', validators=[DataRequired()])
    title = StringField('Title', validators=[DataRequired()])
    type = SelectField('Type', choices=['breakfast', 'appetizer', 'side dish', 'main course', 'dessert'], validators=[DataRequired()])
    tags = StringField('Tags')
    submit = SubmitField('Submit')
