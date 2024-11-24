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
        '+998903456789',
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
        '+998902345678',
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
        '+998901234567',
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
        '+998901234568',
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
        '+998901234569',
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