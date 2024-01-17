from flask import Flask,render_template,request,redirect,url_for,g,flash,session
import pyodbc

app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
conn = pyodbc.connect('Driver={MySQL ODBC 8.0 ANSI Driver};'
                      'Server=localhost;'
                      'Database=dbms_project;'
                      'UID=root;'
                      'PWD=root')

def get_db():
    if 'db' not in g:
        g.db = conn
    return g.db

@app.teardown_appcontext
def close_db(error):
    if 'db' in g:
        g.db.close()

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE username=? AND password=?", (username, password))
        user = cursor.fetchone()
        if user is not None:
            session['logged_in'] = True
            session['user_id'] = user[0]
            return redirect(url_for('programs'))
        else:
            error = 'Invalid Credentials. Please try again.'
    return render_template('login.html', error=error)

@app.route('/register', methods=['POST'])
def register():
    # Get the form data
    username = request.form['username']
    email = request.form['email']
    password = request.form['password']
    confirm_password = request.form['confirm_password']

    # Check if the passwords match
    if password != confirm_password:
        return 'Passwords do not match'

    # Insert the data into the database
    cursor = conn.cursor()
    cursor.execute("INSERT INTO users (username, email, password) VALUES (?, ?, ?)", (username, email, password))
    conn.commit()

    # Return a success message
    return redirect(url_for('login'))

@app.route('/patient')
def patient():
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM patient')
    patient = cursor.fetchall()
    return render_template('patient.html', patient=patient)

@app.route('/add_patient', methods=['POST'])
def add_patient():
    cursor = conn.cursor()
    try:
        # Get form data from request
        patient_id = request.form['patient_id']
        patient_name = request.form['patient_name']
        dob = request.form['dob']
        sex = request.form['sex']
        address = request.form['address']
        doc_referral = request.form['doc_referral']
        patient_status = request.form['patient_status']
        total_duration = request.form['total_duration']
        program_code = request.form['program_code']

        # Insert new row into patient table
        cursor.execute('INSERT INTO patient (patient_id, patient_name, dob, sex, address, doc_referral, patient_status, total_duration, program_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', (patient_id, patient_name, dob, sex, address, doc_referral, patient_status, total_duration, program_code))
        conn.commit()

        # Redirect back to index page
        return redirect(url_for('patient'))

    except Exception as e:
        # Rollback changes if there was an error
        conn.rollback()
        flash('Error inserting new patient: ' + str(e))
        return redirect(url_for('patient'))
    
@app.route('/')
def programs():
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM programs')
    programs = cursor.fetchall()
    return render_template('programs.html', programs=programs)



app.run(debug=True)
