<?php

session_start();

if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] === true) {
    if ($_SESSION['role'] == 'admin') {
        header("Location: ../admin/");
        exit;
    } else if ($_SESSION['role'] == 'teacher') {
        header("Location: ../teacher/");
        exit;
    } else {
        header("Location: ../");
        exit;
    }
}

include '../config.php';
$query = new Database();

if (isset($_COOKIE['username']) && isset($_COOKIE['session_token'])) {

    if (session_id() !== $_COOKIE['session_token']) {
        session_write_close();
        session_id($_COOKIE['session_token']);
        session_start();
    }

    $result = $query->select('users', '*', 'username', $_COOKIE['username'])[0];

    $_SESSION['loggedin'] = true;
    $_SESSION['username'] = $_COOKIE['username'];
    $_SESSION['user_id'] = $result['id'];
    $_SESSION['first_name'] =  $result['first_name'];
    $_SESSION['last_name'] =  $result['last_name'];
    $_SESSION['birth_date'] =  $result['birth_date'];
    $_SESSION['phone'] =  $result['phone'];
    $_SESSION['email'] =  $result['email'];
    $_SESSION['role'] =  $result['role'];
    $_SESSION['profile_picture'] =  $result['profile_picture'];

    if ($_SESSION['role'] == 'admin') {
        header("Location: ../admin/");
        exit;
    } else if ($_SESSION['role'] == 'teacher') {
        header("Location: ../teacher/");
        exit;
    } else {
        header("Location: ../");
        exit;
    }
}

if (isset($_POST['submit'])) {
    $username = $_POST['username'];
    $password = $query->hashPassword($_POST['password']);
    $result = $query->select('users', '*', "username = ? AND password = ?", [$username, $password], 'ss');

    if (count($result) > 0) {
        $user = $result[0];

        $_SESSION['loggedin'] = true;
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['first_name'] =  $user['first_name'];
        $_SESSION['last_name'] =  $user['last_name'];
        $_SESSION['birth_date'] =  $user['birth_date'];
        $_SESSION['phone'] =  $user['phone'];
        $_SESSION['email'] =  $user['email'];
        $_SESSION['role'] =  $user['role'];
        $_SESSION['profile_picture'] =  $user['profile_picture'];

        setcookie('username', $username, time() + (86400 * 30), "/", "", true, true);
        setcookie('session_token', session_id(), time() + (86400 * 30), "/", "", true, true);

        $redirectPath = '../';
        if ($result['role'] == 'admin') {
            $redirectPath = '../admin/';
        } else if ($_SESSION['role'] == 'teacher') {
            $redirectPath = "../teacher/";
        }
?>
        <script>
            window.onload = function() {
                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: 'Muvaffaqiyatli kirish',
                    showConfirmButton: false,
                    timer: 1500
                }).then(() => {
                    window.location.href = '<?php echo $redirectPath; ?>';
                });
            };
        </script>
    <?php
    } else {
    ?>
        <script>
            window.onload = function() {
                Swal.fire({
                    position: 'top-end',
                    icon: 'error',
                    title: 'Noto\'g\'ri ma\'lumot',
                    text: 'Login yoki parol noto\'g\'ri',
                    showConfirmButton: true
                });
            };
        </script>
<?php
    }
}
?>

<!DOCTYPE html>
<html lang="uz">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="../favicon.ico">
    <title>Kirish</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../src/css/login_signup.css">
</head>

<style>
    .logo-container {
        text-align: center;
        margin-bottom: 20px;
    }

    .logo {
        width: 150px;
        height: 150px;
        object-fit: contain;
        border-radius: 50%;
    }
</style>

<body>

    <div class="form-container">

        <h1>Kirish</h1>

        <form method="post" action="">
            <div class="form-group">
                <label for="username">Foydalanuvchi nomi</label>
                <input type="text" id="username" name="username" required maxlength="30">
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
                <button type="submit" name="submit" id="submit">Kirish</button>
            </div>
        </form>

    </div>

    <script src="../src/js/sweetalert2.js"></script>
    <script>
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