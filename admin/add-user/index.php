<?php

session_start();

if (!isset($_SESSION['loggedin']) || $_SESSION['loggedin'] !== true) {
    header("Location: ../../login/");
    exit;
}

if ($_SESSION['role'] != 'admin') {
    header("Location: ../../login/");
    exit;
}

include '../../config.php';
$query = new Database();

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $first_name = $query->validate($_POST['first_name']);
    $last_name = $query->validate($_POST['last_name']);
    $role = $query->validate($_POST['role']);
    $birth_date = $query->validate($_POST['birth_date']);
    $phone = $query->validate($_POST['phone']);
    $email = $query->validate($_POST['email']);
    $username = $query->validate($_POST['username']);
    $password = $query->hashPassword($_POST['password']);

    $data = [
        'first_name' => $first_name,
        'last_name' => $last_name,
        'birth_date' => $birth_date,
        'phone' => $phone,
        'email' => $email,
        'username' => $username,
        'password' => $password,
        'role' => $role
    ];

    $result = $query->insert('users', $data);

    if ($result) {
?>
        <script>
            window.onload = function() {
                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: 'Foydalanuvchini qo\'shish muvaffaqiyatli',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    window.location.href = './';
                });
            };
        </script>
<?php
    } else {
        echo "<script>
                    Swal.fire({
                        icon: 'error',
                        title: 'Xato...',
                        text: 'Foydalanuvchini qo\'shish muammosi yuz berdi. Iltimos, keyinroq qaytadan urinib ko\'ring.',
                    });
                  </script>";
    }
}

?>

<!DOCTYPE html>
<html lang="uz">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="../../favicon.ico">
    <title>Ro'yxatdan o'tish</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../../src/css/login_signup.css">
</head>

<style>
    body {
        padding: 45px 0px;
    }
</style>

<body>
    <div class="form-container">
        <form id="signupForm" method="post" action="">
            <div class="form-group">
                <label for="first_name">Ism</label>
                <input type="text" id="first_name" name="first_name" required maxlength="30">
            </div>
            <div class="form-group">
                <label for="last_name">Familiya</label>
                <input type="text" id="last_name" name="last_name" required maxlength="30">
            </div>
            <div class="form-group">
                <label for="role">Roli</label>
                <select id="role" name="role" required>
                    <option value="student">Talaba</option>
                    <option value="teacher">O'qituvchi</option>
                </select>
            </div>
            <div class="form-group">
                <label for="birth_date">Tug'ilgan sana</label>
                <input type="date" id="birth_date" name="birth_date" required>
            </div>
            <div class="form-group">
                <label for="phone">Telefon raqami</label>
                <input type="tel" id="phone" name="phone" required oninput="formatPhoneNumber(this)" onkeydown="removeSpace(event)"
                    maxlength="17" required value="+998 ">
                <p id="phone-message"></p>
            </div>
            <div class="form-group">
                <label for="email">Elektron pochta</label>
                <input type="email" id="email" name="email" required maxlength="100">
                <p id="email-message"></p>
            </div>
            <div class="form-group">
                <label for="username">Foydalanuvchi nomi</label>
                <input type="text" id="username" name="username" required maxlength="30">
                <p id="username-message"></p>
            </div>
            <div class="form-group">
                <label for="password">Parol</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" required maxlength="255">
                    <button type="button" id="toggle-password" class="password-toggle"><i
                            class="fas fa-eye"></i></button>
                </div>
            </div>
            <div class="form-group">
                <button type="submit" id="submit">Foydalanuvchini qo'shish</button>
            </div>
        </form>
    </div>

    <script src="../../src/js/sweetalert2.js"></script>

    <script>
        let isphoneAvailable = false;
        let isEmailAvailable = false;
        let isUsernameAvailable = false;

        function formatPhoneNumber(input) {
            let phoneNumber = input.value.replace(/\D/g, '');

            if (phoneNumber.length > 0) {
                phoneNumber = '+998 ' + phoneNumber.substring(3, 5) + ' ' + phoneNumber.substring(5, 8) + ' ' + phoneNumber.substring(8, 10) + ' ' + phoneNumber.substring(10, 12);
            }

            input.value = phoneNumber;
        }

        function removeSpace(event) {
            let input = event.target;
            if (event.key === 'Backspace' || event.key === 'Delete') {
                input.value = input.value.replace(/\s/g, '');
            }
        }

        document.getElementById('phone').addEventListener('input', function() {
            let phone = this.value;
            if (phone.length > 0) {
                fetch('check_availability.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `phone=${encodeURIComponent(phone)}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        const messageElement = document.getElementById('phone-message');
                        if (data.exists) {
                            messageElement.textContent = 'Bu telefon raqam mavjud!';
                            isphoneAvailable = false;
                        } else {
                            messageElement.textContent = '';
                            isphoneAvailable = true;
                        }
                    });
            }
        });

        document.getElementById('email').addEventListener('input', function() {
            let email = this.value;
            if (email.length > 0) {
                fetch('check_availability.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `email=${encodeURIComponent(email)}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        const messageElement = document.getElementById('email-message');
                        if (data.exists) {
                            messageElement.textContent = 'Bu elektron pochta mavjud!';
                            isEmailAvailable = false;
                        } else {
                            messageElement.textContent = '';
                            isEmailAvailable = true;
                        }
                    });
            }
        });

        function validateEmailFormat(email) {
            const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            return emailPattern.test(email);
        }

        document.getElementById('submit').addEventListener('click', function(event) {
            let email = document.getElementById('email').value;
            const messageElement = document.getElementById('email-message');

            if (!validateEmailFormat(email)) {
                messageElement.textContent = 'Elektron pochta formati noto\'g\'ri!';
                event.preventDefault();
                return;
            }

            if (isEmailAvailable === false) {
                messageElement.textContent = 'Bu elektron pochta mavjud!';
                event.preventDefault();
            }
        });


        document.getElementById('username').addEventListener('input', function() {
            let username = this.value;
            if (username.length > 0) {
                fetch('check_availability.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `username=${encodeURIComponent(username)}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        const messageElement = document.getElementById('username-message');
                        if (data.exists) {
                            messageElement.textContent = 'Bu foydalanuvchi nomi mavjud!';
                            isUsernameAvailable = false;
                        } else {
                            messageElement.textContent = '';
                            isUsernameAvailable = true;
                        }
                    });
            }
        });

        document.getElementById('toggle-password').addEventListener('click', function() {
            const passwordField = document.getElementById('password');
            const toggleIcon = this.querySelector('i');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        });
    </script>
</body>

</html>