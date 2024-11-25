CREATE DATABASE IF NOT EXISTS iqbolsho_students;

USE iqbolsho_students;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    birth_date DATE NOT NULL,
    phone VARCHAR(17) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'teacher', 'student') NOT NULL DEFAULT 'student',
    profile_picture VARCHAR(255) DEFAULT 'default.png',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS course_groups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    group_name VARCHAR(100) NOT NULL,
    course_id INT NOT NULL,
    teacher_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS group_users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES course_groups(id) ON DELETE CASCADE,
    UNIQUE (user_id, group_id)
);

CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    status ENUM('paid', 'unpaid') NOT NULL,
    month_start_date DATE,
    month_end_date DATE,
    payment_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS lesson_times (
    id INT PRIMARY KEY AUTO_INCREMENT,
    group_id INT NOT NULL,
    lesson_date DATE NOT NULL,
    FOREIGN KEY (group_id) REFERENCES course_groups(id) ON DELETE CASCADE,
    UNIQUE (group_id, lesson_date)
);

CREATE TABLE IF NOT EXISTS attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lesson_time_id INT NOT NULL,
    group_id INT NOT NULL,
    user_id INT NOT NULL,
    status ENUM('came', 'did-not-come') NOT NULL DEFAULT 'came',
    FOREIGN KEY (lesson_time_id) REFERENCES lesson_times(id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES course_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    group_id INT NOT NULL,
    lesson_time_id INT NOT NULL,
    deadline DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES course_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_time_id) REFERENCES lesson_times(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS task_submissions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    code TEXT NOT NULL,
    score INT DEFAULT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO
    users (
        first_name,
        last_name,
        birth_date,
        phone,
        email,
        username,
        password,
        role,
        profile_picture
    )
VALUES
    (
        'Admin',
        'Ilhomjonov',
        '2005-04-20',
        '+998 90 345 67 89',
        'admin@gmail.com',
        'admin',
        '65c2a32982abe41b1e6ff888d351ee6b7ade33affd4a595667ea7db910aecaa8',
        'admin',
        'default.png'
    ),
    (
        'Teacher',
        'Ilhomjonov',
        '2005-04-20',
        '+998 90 234 56 78',
        'teacher@gmail.com',
        'teacher',
        '65c2a32982abe41b1e6ff888d351ee6b7ade33affd4a595667ea7db910aecaa8',
        'teacher',
        'default.png'
    ),
    (
        'Student1',
        'Ilhomjonov',
        '2005-04-20',
        '+998 90 123 45 67',
        'student@gmail.com',
        'student',
        '65c2a32982abe41b1e6ff888d351ee6b7ade33affd4a595667ea7db910aecaa8',
        'student',
        'default.png'
    ),
    (
        'Student2',
        'Tursunov',
        '2005-04-20',
        '+998 90 123 45 68',
        'student2@gmail.com',
        'student2',
        '65c2a32982abe41b1e6ff888d351ee6b7ade33affd4a595667ea7db910aecaa8',
        'student',
        'default.png'
    ),
    (
        'Student3',
        'Sharipov',
        '2005-04-20',
        '+998 90 123 45 69',
        'student3@gmail.com',
        'student3',
        '65c2a32982abe41b1e6ff888d351ee6b7ade33affd4a595667ea7db910aecaa8',
        'student',
        'default.png'
    );

INSERT INTO
    courses (course_name, price)
VALUES
    ('C++', 200000.00),
    ('Frontend', 300000.00),
    ('Backend', 400000.00);

INSERT INTO
    course_groups (group_name, course_id, teacher_id)
VALUES
    ('C++ Introduction', 1, 2),
    ('Frontend Basics', 2, 2),
    ('Backend Mastery', 3, 2);

INSERT INTO
    group_users (user_id, group_id)
VALUES
    (3, 1),
    (3, 2),
    (3, 3),
    (4, 1),
    (4, 2),
    (4, 3),
    (5, 1),
    (5, 2);

INSERT INTO
    payments (
        user_id,
        course_id,
        status,
        month_start_date,
        month_end_date,
        payment_date
    )
VALUES
    (
        3,
        1,
        'paid',
        '2024-11-01',
        '2024-11-30',
        '2024-11-01 10:00:00'
    ),
    (
        3,
        2,
        'unpaid',
        '2024-12-01',
        '2024-12-31',
        '2024-12-05 15:00:00'
    ),
    (
        4,
        3,
        'paid',
        '2024-11-01',
        '2024-11-30',
        '2024-11-02 09:00:00'
    ),
    (
        5,
        1,
        'paid',
        '2024-11-01',
        '2024-11-30',
        '2024-11-03 11:00:00'
    );

INSERT INTO
    lesson_times (group_id, lesson_date)
VALUES
    (1, '2024-11-25'),
    (2, '2024-11-26'),
    (3, '2024-11-27');

INSERT INTO
    attendance (lesson_time_id, group_id, user_id, status)
VALUES
    (1, 1, 3, 'came'),
    (1, 1, 4, 'did-not-come'),
    (1, 1, 5, 'came'),
    (2, 2, 3, 'came'),
    (2, 2, 4, 'came'),
    (3, 3, 3, 'did-not-come'),
    (3, 3, 5, 'came');

INSERT INTO
    tasks (
        title,
        description,
        group_id,
        lesson_time_id,
        deadline
    )
VALUES
    (
        'Complete Chapter 1 Exercises',
        'Solve all exercises from Chapter 1 in the textbook.',
        1,
        1,
        '2024-11-30 23:59:59'
    ),
    (
        'Create a Responsive Navbar',
        'Build a responsive navigation bar using HTML, CSS, and JavaScript.',
        2,
        2,
        '2024-12-05 12:00:00'
    ),
    (
        'Set up a Database',
        'Create a relational database for the project using MySQL.',
        3,
        3,
        '2024-12-10 15:00:00'
    );

INSERT INTO
    task_submissions (task_id, user_id, code, score, submission_date)
VALUES
    (
        1,
        3,
        'Completed the exercises as instructed.',
        5,
        '2024-11-28 18:00:00'
    ),
    (
        1,
        4,
        'Attempted some exercises but faced issues.',
        5,
        '2024-11-29 20:00:00'
    ),
    (
        2,
        3,
        'Submitted the responsive navbar code.',
        5,
        '2024-12-04 10:00:00'
    ),
    (
        3,
        5,
        'Set up the database as instructed.',
        5,
        '2024-12-09 14:00:00'
    );